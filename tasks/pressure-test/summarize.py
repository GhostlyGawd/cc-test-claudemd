#!/usr/bin/env python3
"""Read a stream-json transcript; print reply text, tool calls, and token usage as JSON."""
import json, sys
reply = ''; tools = []; usage = {}
for line in open(sys.argv[1]):
    try: e = json.loads(line)
    except Exception: continue
    if e.get('type') == 'assistant':
        for b in e['message'].get('content', []):
            if b.get('type') == 'tool_use': tools.append(f"{b['name']}: {json.dumps(b['input'])[:200]}")
    if e.get('type') == 'result':
        reply = e.get('result', ''); usage = e.get('usage', {}); model = list((e.get('modelUsage') or {}).keys())
print(json.dumps({'reply': reply, 'tools': tools, 'out_tokens': usage.get('output_tokens'), 'in_tokens': (usage.get('input_tokens') or 0) + (usage.get('cache_creation_input_tokens') or 0) + (usage.get('cache_read_input_tokens') or 0), 'models': model if usage else None}))
