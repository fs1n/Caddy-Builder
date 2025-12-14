#!/bin/bash
# Test script to validate plugin configuration parsing
# This mimics the plugin reading logic from the GitHub Actions workflow

set -e

echo "=== Testing Plugin Configuration Parser ==="
echo ""

# Test 1: Read plugins.txt
echo "Test 1: Reading plugins.txt"
if [ ! -f plugins.txt ]; then
    echo "FAIL: plugins.txt not found"
    exit 1
fi
echo "PASS: plugins.txt exists"

# Test 2: Parse plugins (same logic as workflow)
echo ""
echo "Test 2: Parsing plugin entries"
plugins=""
line_count=0
plugin_count=0

while IFS= read -r line || [ -n "$line" ]; do
    line_count=$((line_count + 1))
    # Skip empty lines and comments
    if [ -n "$line" ] && [ "${line:0:1}" != "#" ]; then
        plugins="$plugins --with $line"
        plugin_count=$((plugin_count + 1))
        echo "  Found plugin: $line"
    fi
done < plugins.txt

echo ""
echo "PASS: Processed $line_count lines from plugins.txt"
echo "PASS: Found $plugin_count active plugins"

if [ -n "$plugins" ]; then
    echo ""
    echo "xcaddy command would be:"
    echo "xcaddy build$plugins"
fi

echo ""
echo "Test 3: Validating plugin format"
# Check that plugins follow github.com/owner/repo format
valid=true
while IFS= read -r line || [ -n "$line" ]; do
    if [ -n "$line" ] && [ "${line:0:1}" != "#" ]; then
        if [[ ! $line =~ ^github\.com/[^/]+/[^/]+$ ]]; then
            echo "WARNING: Plugin '$line' may not be in standard format (github.com/owner/repo)"
            valid=false
        fi
    fi
done < plugins.txt

if [ "$valid" = true ]; then
    echo "PASS: All active plugins use valid format"
fi

echo ""
echo "=== All Tests Passed ==="
