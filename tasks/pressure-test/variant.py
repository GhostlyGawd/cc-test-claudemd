#!/usr/bin/env python3
"""Print CLAUDE.md with one rule removed. Usage: variant.py R120 [CLAUDE.md] [rules.tsv]. With 'full' prints the file unchanged."""
import re, sys
rule = sys.argv[1]
md = sys.argv[2] if len(sys.argv) > 2 else 'CLAUDE.md'
tsv = sys.argv[3] if len(sys.argv) > 3 else 'tasks/pressure-test/rules.tsv'
lines = open(md).read().split('\n')
if rule == 'full':
    print('\n'.join(lines), end=''); sys.exit(0)
row = next(r.split('\t') for r in open(tsv).read().split('\n')[1:] if r.startswith(rule + '\t'))
text = row[3]
# the parser joined continuation lines with ' / ', so match on the first line of the rule
head = text.split(' / ')[0][:50]
hits = [i for i, l in enumerate(lines) if re.sub(r'^(\d+\.|-) ', '', l.strip()).startswith(head) and not l.startswith(' ')]
if len(hits) != 1:
    sys.exit(f'{rule}: expected 1 match for {head!r}, found {len(hits)}')
s = hits[0]; e = s + 1
while e < len(lines) and lines[e].startswith(' '):
    e += 1
sys.stderr.write(f'{rule}: removed lines {s+1}-{e}\n')
print('\n'.join(lines[:s] + lines[e:]), end='')
