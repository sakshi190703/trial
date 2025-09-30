#!/bin/bash
# Script to fix index_together issues in models

echo "🔧 Fixing index_together to indexes in models..."

# Find and update models.py files (not migrations)
find . -name "models.py" -not -path "./env/*" -exec python3 -c "
import sys
import re

filename = sys.argv[1]
with open(filename, 'r') as f:
    content = f.read()

# Replace index_together with indexes
pattern = r'index_together\s*=\s*\[(.*?)\]'
def replace_index_together(match):
    fields_content = match.group(1).strip()
    if not fields_content:
        return 'indexes = []'
    
    # Convert tuples to Index objects
    lines = []
    for line in fields_content.split('\n'):
        line = line.strip()
        if line.startswith('(') and line.endswith(','):
            # Extract field names from tuple
            fields_str = line[1:-2]  # Remove ( and ),
            lines.append(f'            models.Index(fields=[{fields_str}]),')
    
    if lines:
        return 'indexes = [\n' + '\n'.join(lines) + '\n        ]'
    else:
        return 'indexes = []'

new_content = re.sub(pattern, replace_index_together, content, flags=re.DOTALL)

if new_content != content:
    with open(filename, 'w') as f:
        f.write(new_content)
    print(f'Updated {filename}')
" {} \;

echo "✅ Fixed index_together in models"
