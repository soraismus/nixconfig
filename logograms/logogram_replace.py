import json
import sys
import re

mode: str = sys.argv[1]  # "to_logogram" or "to_ascii"
buffer: str = sys.stdin.read()

with open(f"{sys.argv[2]}", "r", encoding="utf-8") as f:
    mapping: dict[str, str] = json.load(f)

if mode == "to_logogram":
    for word, logogram in mapping.items():
        buffer: str = re.sub(rf"\b{re.escape(word)}\b", logogram, buffer)
elif mode == "to_ascii":
    for word, logogram in mapping.items():
        buffer: str = buffer.replace(logogram, word)
else:
    raise ValueError("Unknown mode")

print(buffer)
