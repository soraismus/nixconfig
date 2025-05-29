import json
import sys
import re

mode = sys.argv[1]  # "to_logogram" or "to_ascii"
buffer = sys.stdin.read()

with open(f"{sys.argv[2]}", "r", encoding="utf-8") as f:
    mapping = json.load(f)

if mode == "to_logogram":
    for word, logogram in mapping.items():
        buffer = re.sub(rf"\b{re.escape(word)}\b", logogram, buffer)
elif mode == "to_ascii":
    for word, logogram in mapping.items():
        buffer = buffer.replace(logogram, word)
else:
    raise ValueError("Unknown mode")

print(buffer)
