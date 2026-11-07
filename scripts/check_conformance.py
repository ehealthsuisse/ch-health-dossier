#!/usr/bin/env python3
"""Check the conformance statements of the IG.

The conformance statements are not marked in the markdown pages. They are listed in
input/data/conformance.json (page -> statements, in the order they appear on the page) with the exact
markdown they cover ("text", and "before" when the text alone is not unique on the page). The local template
(local-template/package/includes/conformance-markers.html) puts the IG Publisher markers (§id^actors:text§,
§§id^actors:summary^text§§) around these texts when the pages are rendered, so the IG Publisher builds the
table of conformance statements and Requirements/fromNarrative as if the markers were in the markdown.

This script checks that:
- every statement's text is found exactly once on its page, the statements of a page are in page order and
  don't overlap, ids are unique and every statement has at least one actor
- every capitalised RFC 2119 keyword (SHALL, SHOULD, MAY, MUST, ...) in the pages is inside a statement or in
  input/data/conformance-ignore.json (page -> sentences that are not conformance statements, or "*" for a
  page that is not checked at all)

The IG Publisher only does the second check for IGs with an hl7.org/fhir canonical, see
https://github.com/HL7/fhir-ig-publisher/issues/1459

usage: check_conformance.py [--suggest [--write]] [--ignore] [ig-root]
  --suggest  print a statement for every sentence with a keyword outside a statement, with the next free id
  --write    with --suggest: add them to conformance.json (without actors: add these before committing)
  --ignore   add the sentences with a keyword outside a statement to conformance-ignore.json
exit code 1 if a problem is found (without --write / --ignore)
"""
import argparse
import glob
import json
import os
import re
import sys

KEYWORD = re.compile(r'\b(SHALL|SHOULD|MAY|MUST|REQUIRED|RECOMMENDED|OPTIONAL)\b')
BLOCK_START = re.compile(r'(?m)^[ \t]*(?:[-*+]|\d+\.|#+|>)[ \t]+')
SENTENCE_END = re.compile(r'(?<!\be\.g)(?<!\bi\.e)(?<!\betc)\.(?=\s|$)')
ID = re.compile(r'^(.*?)(\d+)$')


def load(path, default):
    if not os.path.exists(path):
        return default
    with open(path, encoding='utf-8') as fp:
        return json.load(fp)


def save(path, data):
    with open(path, 'w', encoding='utf-8') as fp:
        json.dump(data, fp, indent=2, ensure_ascii=False)
        fp.write('\n')


def sentence_at(md, pos, covered):
    """The sentence (paragraph, list item or table cell) around pos, not overlapping a statement"""
    start = md.rfind('\n\n', 0, pos)
    start = 0 if start < 0 else start + 2
    end = md.find('\n\n', pos)
    end = len(md) if end < 0 else end
    for m in BLOCK_START.finditer(md, start, pos):
        start = m.end()
    m = BLOCK_START.search(md, pos, end)
    if m:
        end = md.rfind('\n', pos, m.start())
    line_start = md.rfind('\n', 0, pos) + 1
    line_end = md.find('\n', pos)
    line_end = len(md) if line_end < 0 else line_end
    if md[line_start:line_end].lstrip().startswith('|'):  # table cell
        start = max(start, md.rfind('|', line_start, pos) + 1)
        cell_end = md.find('|', pos, line_end)
        end = min(end, cell_end if cell_end >= 0 else line_end)
    for m in SENTENCE_END.finditer(md, start, pos):
        start = m.end()
    m = SENTENCE_END.search(md, pos, end)
    if m:
        end = m.end()
    for a, b, _ in covered:
        if start <= b <= pos:
            start = b
        if pos <= a <= end:
            end = a
    while start < end and md[start].isspace():
        start += 1
    while end > start and md[end - 1].isspace():
        end -= 1
    return start, end


def unique_before(md, start, end):
    k = 0
    while md.count(md[start - k:start] + md[start:end]) != 1 and k < start:
        k += 1
    return md[start - k:start]


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('root', nargs='?', default='.')
    ap.add_argument('--suggest', action='store_true')
    ap.add_argument('--write', action='store_true')
    ap.add_argument('--ignore', action='store_true')
    args = ap.parse_args()

    data_path = os.path.join(args.root, 'input/data/conformance.json')
    ignore_path = os.path.join(args.root, 'input/data/conformance-ignore.json')
    data = load(data_path, {})
    ignore = load(ignore_path, {})
    pages = {os.path.basename(f)[:-3]: f for f in glob.glob(os.path.join(args.root, 'input/pagecontent/*.md'))}

    problems = []
    ids = {}
    for page, stmts in data.items():
        if page not in pages:
            problems.append(f'conformance.json: page {page}.md does not exist')
        for s in stmts:
            if s['id'] in ids:
                problems.append(f"conformance.json: id {s['id']} is used on {ids[s['id']]} and {page}")
            ids[s['id']] = page

    found = {}  # page -> [(page, start, end, before)] of the sentences with a keyword outside a statement
    for page in sorted(pages):
        with open(pages[page], encoding='utf-8') as fp:
            md = fp.read()
        covered = []
        last = -1
        for s in data.get(page, []):
            before = s.get('before', '')
            n = md.count(before + s['text'])
            if n != 1:
                problems.append(f"{page}.md: statement {s['id']} found {n} times: {s['text'][:80]!r}")
                continue
            start = md.index(before + s['text']) + len(before)
            if start < last:
                problems.append(f"{page}.md: statement {s['id']} is not in page order in conformance.json")
            if any(a < start + len(s['text']) and start < b for a, b, _ in covered):
                problems.append(f"{page}.md: statement {s['id']} overlaps another statement")
            if not s.get('actors'):
                problems.append(f"{page}.md: statement {s['id']} has no actors")
            last = start
            covered.append((start, start + len(s['text']), s['id']))
        page_ignore = ignore.get(page, [])
        if page_ignore == '*':
            continue
        ignored = []
        for snippet in page_ignore:
            i = md.find(snippet)
            if i < 0:
                problems.append(f'{page}.md: ignored sentence not found: {snippet[:80]!r}')
            else:
                ignored.append((i, i + len(snippet)))
        for m in KEYWORD.finditer(md):
            if any(a <= m.start() < b for a, b, _ in covered) or any(a <= m.start() < b for a, b in ignored):
                continue
            start, end = sentence_at(md, m.start(), covered)
            if (start, end) in [(f[1], f[2]) for f in found.get(page, [])]:
                continue
            found.setdefault(page, []).append((md, start, end, unique_before(md, start, end)))
            line = md.count('\n', 0, m.start()) + 1
            problems.append(f'{page}.md:{line}: {m.group(1)} outside a conformance statement: '
                            f'{md[start:end][:120]!r}')

    if args.suggest:
        used = set(ids)

        def next_id(page):
            prefixes = [ID.match(s['id']).group(1) for s in data.get(page, []) if ID.match(s['id'])]
            prefix = max(set(prefixes), key=prefixes.count) if prefixes else page.replace('-', '') + '-'
            n = max([int(ID.match(i).group(2)) for i in used
                     if ID.match(i) and ID.match(i).group(1) == prefix] or [0]) + 1
            used.add(prefix + str(n))
            return prefix + str(n)

        suggestions = {}
        for page, items in found.items():
            for md, start, end, before in items:
                s = {'id': next_id(page), 'actors': [], 'text': md[start:end]}
                if before:
                    s['before'] = before
                suggestions.setdefault(page, []).append((start, s))
        if args.write:
            for page, items in suggestions.items():
                with open(pages[page], encoding='utf-8') as fp:
                    md = fp.read()
                merged = [(md.index(s.get('before', '') + s['text']) + len(s.get('before', '')), s)
                          for s in data.get(page, [])] + items
                data[page] = [s for _, s in sorted(merged, key=lambda x: x[0])]
                for _, s in items:
                    del s['actors']
            save(data_path, data)
            print(f'added {sum(len(v) for v in suggestions.values())} statements to {data_path}: '
                  'check the text and add the actors')
            return 0
        print(json.dumps({p: [s for _, s in v] for p, v in suggestions.items()}, indent=2, ensure_ascii=False))
        return 0

    if args.ignore:
        for page, items in found.items():
            ignore.setdefault(page, []).extend(md[start:end] for md, start, end, _ in items)
        save(ignore_path, ignore)
        print(f'added {sum(len(v) for v in found.values())} sentences to {ignore_path}')
        return 0

    print('\n'.join(problems) or f'ok: {len(ids)} conformance statements')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
