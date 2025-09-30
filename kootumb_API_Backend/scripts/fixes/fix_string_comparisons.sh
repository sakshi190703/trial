#!/bin/bash
# Script to fix string identity comparisons (is '' → == '')

echo "🔧 Fixing string identity comparisons..."

# Fix 'is' with empty string comparisons
find . -name "*.py" -not -path "./env/*" -exec sed -i "s/ is ''/ == ''/g" {} \;
find . -name "*.py" -not -path "./env/*" -exec sed -i "s/ is \"\"/ == \"\"/g" {} \;

# Fix 'is' with string literal comparisons  
find . -name "*.py" -not -path "./env/*" -exec sed -i "s/ is 'en'/ == 'en'/g" {} \;
find . -name "*.py" -not -path "./env/*" -exec sed -i "s/ is 'zh-cn'/ == 'zh-cn'/g" {} \;
find . -name "*.py" -not -path "./env/*" -exec sed -i "s/ is 'zh-tw'/ == 'zh-tw'/g" {} \;
find . -name "*.py" -not -path "./env/*" -exec sed -i "s/ is '0'/ == '0'/g" {} \;

echo "✅ Fixed string identity comparisons"
echo "🎉 String comparison fixes complete!"
