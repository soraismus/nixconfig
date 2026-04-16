import json
import sys
from pathlib import Path
from typing import Any


def make_snippets(word: str, symbol: str) -> str:
    lowercase_trigger: str = word.lower()
    capitalized_trigger: str = word[0].upper() + word[1:].lower()

    # (0) Ordinary manual snippet
    snippet_0: str = f"""snippet {lowercase_trigger} "Logogram for {word}" b
{symbol}
endsnippet
"""

    # (1) Autosnippet (lowercase, whole word)
    snippet_1: str = f"""snippet {lowercase_trigger} "Auto-logogram for {word}" w
{symbol}
endsnippet
"""

    # (2) Autosnippet (capitalized, whole word)
    snippet_2: str = f"""snippet {capitalized_trigger} "Auto-logogram for {word} (Capitalized)" w
{symbol}
endsnippet
"""

    return snippet_0 + snippet_1 + snippet_2

# Check for correct number of arguments.
if len(sys.argv) != 3:
    print("Usage: python logogram_to_snippets.py <input_json> <output_snippets_file>")
    sys.exit(1)

input_json_path: Path = Path(sys.argv[1])
output_snippets_path: Path = Path(sys.argv[2])

# Read JSON.
with open(input_json_path, 'r', encoding='utf-8') as f:
    mapping: dict[str, str] = json.load(f)

# Generate snippets.
snippets_output: str = ""
for word, symbol in mapping.items():
    snippets_output += make_snippets(word, symbol)

# Write to output file.
output_snippets_path.parent.mkdir(parents=True, exist_ok=True)
output_snippets_path.write_text(snippets_output, encoding='utf-8')
