#!/bin/bash
# Script to fix all ugettext_lazy imports to gettext_lazy

echo "🔧 Fixing ugettext_lazy imports to gettext_lazy..."

# Find and replace in all Python files, excluding env directory
find . -name "*.py" -not -path "./env/*" -exec sed -i 's/from django\.utils\.translation import ugettext_lazy as _/from django.utils.translation import gettext_lazy as _/g' {} \;
find . -name "*.py" -not -path "./env/*" -exec sed -i 's/from django\.utils\.translation import ugettext as _/from django.utils.translation import gettext as _/g' {} \;

echo "✅ Fixed ugettext_lazy imports"

# Also fix any standalone ugettext imports
find . -name "*.py" -not -path "./env/*" -exec sed -i 's/ugettext_lazy/gettext_lazy/g' {} \;
find . -name "*.py" -not -path "./env/*" -exec sed -i 's/ugettext(/gettext(/g' {} \;

echo "✅ Fixed all ugettext references"
echo "🎉 Django translation API fixes complete!"
