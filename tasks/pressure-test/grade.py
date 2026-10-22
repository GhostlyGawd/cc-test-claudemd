#!/usr/bin/env python3
"""Grade transcripts. Usage: grade.py <scenarios.tsv> <rules.tsv> <transcript_dir> <out.tsv>
Grades every transcript for every rule its scenario targets. Output columns: sid, variant, run, rule, verdict, evidence, out_tokens, in_tokens."""
import json, os, re, subprocess, sys, tempfile
from concurrent.futures import ThreadPoolExecutor
here = os.path.dirname(os.path.abspath(__file__))
sc_file, rules_file, tdir, out = sys.argv[1:5]
tmpl = open(os.path.join(here, 'grader.md')).read()
rows = [l.split('\t') for l in open(sc_file).read().strip().split('\n')[1:]]
scen = {r[0]: dict(prompt=r[2], rules=r[3].split(','), expect=r[4]) for r in rows}
rules = {l.split('\t')[0]: l.split('\t') for l in open(rules_file).read().strip().split('\n')[1:]}
jobs = []
for f in sorted(os.listdir(tdir)):
    m = re.match(r'(\w+?)_(full|R\d+)_(\d+)\.jsonl$', f)
    if not m: continue
    for r in scen[m[1]]['rules']: jobs.append((m[1], m[2], m[3], r, os.path.join(tdir, f)))
def grade(j):
    sid, var, run, rule, path = j
    s = json.loads(subprocess.run([sys.executable, '-I', os.path.join(here, 'summarize.py'), path], capture_output=True, text=True).stdout)
    # each scenario has one "expect" paragraph naming several rules; keep only the sentences for this rule
    parts = re.split(r'(?<=\.) (?=R\d{3} )', scen[sid]['expect'])
    exp = ' '.join(p for p in parts if p.startswith(rule)) or scen[sid]['expect']
    p = tmpl.format(rule=rules[rule][3], why=rules[rule][4], expect=exp, prompt=scen[sid]['prompt'], tools='\n'.join(s['tools']) or '(none)', reply=s['reply'])
    with tempfile.TemporaryDirectory() as d:
        r = subprocess.run(['claude', '-p', p, '--model', 'claude-sonnet-5-5', '--output-format', 'json', '--setting-sources', 'project'], cwd=d, capture_output=True, text=True, timeout=300)
    try:
        res = json.loads(r.stdout)['result']; v = json.loads(re.search(r'\{.*\}', res, re.S).group(0))
    except Exception as e:
        v = {'verdict': 'grader_error', 'evidence': str(e)[:80]}
    return [sid, var, run, rule, v['verdict'], v['evidence'].replace('\t', ' ').replace('\n', ' '), str(s['out_tokens']), str(s['in_tokens'])]
with ThreadPoolExecutor(6) as ex: res = list(ex.map(grade, jobs))
open(out, 'w').write('sid\tvariant\trun\trule\tverdict\tevidence\tout_tokens\tin_tokens\n' + '\n'.join('\t'.join(r) for r in res) + '\n')
print(len(res), 'graded')
