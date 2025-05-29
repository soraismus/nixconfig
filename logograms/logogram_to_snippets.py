import json
import sys
from pathlib import Path

def make_snippets(word, symbol):
    lowercase_trigger = word.lower()
    capitalized_trigger = word[0].upper() + word[1:].lower()

    # (0) Ordinary manual snippet
    snippet_0 = f"""snippet {lowercase_trigger} "Logogram for {word}" b
{symbol}
endsnippet
"""

    # (1) Autosnippet (lowercase, whole word)
    snippet_1 = f"""snippet {lowercase_trigger} "Auto-logogram for {word}" w
{symbol}
endsnippet
"""

    # (2) Autosnippet (capitalized, whole word)
    snippet_2 = f"""snippet {capitalized_trigger} "Auto-logogram for {word} (Capitalized)" w
{symbol}
endsnippet
"""

    return snippet_0 + snippet_1 + snippet_2

# Check for correct number of arguments.
if len(sys.argv) != 3:
    print("Usage: python logogram_to_snippets.py <input_json> <output_snippets_file>")
    sys.exit(1)

input_json_path = Path(sys.argv[1])
output_snippets_path = Path(sys.argv[2])

# Read JSON.
with open(input_json_path, 'r', encoding='utf-8') as f:
    mapping = json.load(f)

# Generate snippets.
snippets_output = ""
for word, symbol in mapping.items():
    snippets_output += make_snippets(word, symbol)

# Write to output file.
output_snippets_path.parent.mkdir(parents=True, exist_ok=True)
output_snippets_path.write_text(snippets_output, encoding='utf-8')
