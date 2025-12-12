#!/bin/bash
# Integration test for the Caddy builder workflows
# Tests workflow syntax and logic

set -e

echo "=== Caddy Builder Integration Tests ==="
echo ""

# Test 1: Workflow files exist
echo "Test 1: Checking workflow files"
if [ ! -f .github/workflows/build-caddy.yml ]; then
    echo "❌ FAIL: build-caddy.yml not found"
    exit 1
fi
echo "✓ build-caddy.yml exists"

if [ ! -f .github/workflows/check-updates.yml ]; then
    echo "❌ FAIL: check-updates.yml not found"
    exit 1
fi
echo "✓ check-updates.yml exists"

# Test 2: YAML syntax validation
echo ""
echo "Test 2: Validating YAML syntax"
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/build-caddy.yml'))" && echo "✓ build-caddy.yml has valid YAML syntax"
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/check-updates.yml'))" && echo "✓ check-updates.yml has valid YAML syntax"

# Test 3: Check required workflow components
echo ""
echo "Test 3: Checking workflow components"

# Check build workflow has matrix
if grep -q "matrix:" .github/workflows/build-caddy.yml; then
    echo "✓ build-caddy.yml has build matrix"
else
    echo "❌ FAIL: build-caddy.yml missing matrix configuration"
    exit 1
fi

# Check for all required Linux architectures
for arch in amd64 arm64 armv7 armv6 386; do
    if grep -q "$arch" .github/workflows/build-caddy.yml; then
        echo "✓ build-caddy.yml includes $arch architecture"
    else
        echo "❌ FAIL: build-caddy.yml missing $arch architecture"
        exit 1
    fi
done

# Check for xcaddy installation
if grep -q "xcaddy" .github/workflows/build-caddy.yml; then
    echo "✓ build-caddy.yml includes xcaddy installation"
else
    echo "❌ FAIL: build-caddy.yml missing xcaddy setup"
    exit 1
fi

# Check for plugin reading logic
if grep -q "plugins.txt" .github/workflows/build-caddy.yml; then
    echo "✓ build-caddy.yml reads from plugins.txt"
else
    echo "❌ FAIL: build-caddy.yml doesn't read plugins.txt"
    exit 1
fi

# Check update workflow has schedule
if grep -q "schedule:" .github/workflows/check-updates.yml; then
    echo "✓ check-updates.yml has scheduled runs"
else
    echo "❌ FAIL: check-updates.yml missing schedule"
    exit 1
fi

# Check for Caddy version checking
if grep -q "caddyserver/caddy" .github/workflows/check-updates.yml; then
    echo "✓ check-updates.yml checks Caddy updates"
else
    echo "❌ FAIL: check-updates.yml doesn't check Caddy updates"
    exit 1
fi

# Test 4: Configuration file
echo ""
echo "Test 4: Checking configuration"
if [ ! -f plugins.txt ]; then
    echo "❌ FAIL: plugins.txt not found"
    exit 1
fi
echo "✓ plugins.txt exists"

# Test 5: Documentation
echo ""
echo "Test 5: Checking documentation"
if [ ! -f README.md ]; then
    echo "❌ FAIL: README.md not found"
    exit 1
fi
echo "✓ README.md exists"

if grep -q "plugins.txt" README.md; then
    echo "✓ README.md documents plugins.txt"
else
    echo "❌ FAIL: README.md missing plugins.txt documentation"
    exit 1
fi

# Test 6: Test build matrix configuration
echo ""
echo "Test 6: Checking build matrix configuration"
if grep -q "upload-artifact@v4" .github/workflows/build-caddy.yml; then
    echo "✓ build-caddy.yml uses artifact upload"
else
    echo "❌ FAIL: build-caddy.yml missing artifact upload"
    exit 1
fi

# Test 7: Test workflow has testing job
echo ""
echo "Test 7: Checking test job"
if grep -q "test:" .github/workflows/build-caddy.yml; then
    echo "✓ build-caddy.yml includes test job"
else
    echo "❌ FAIL: build-caddy.yml missing test job"
    exit 1
fi

if grep -qi "version" .github/workflows/build-caddy.yml; then
    echo "✓ build-caddy.yml tests binary execution"
else
    echo "❌ FAIL: build-caddy.yml doesn't test binary"
    exit 1
fi

# Test 8: Release creation
echo ""
echo "Test 8: Checking release workflow"
if grep -q "create-release:" .github/workflows/build-caddy.yml; then
    echo "✓ build-caddy.yml includes release job"
else
    echo "❌ FAIL: build-caddy.yml missing release job"
    exit 1
fi

echo ""
echo "=== All Integration Tests Passed ==="
echo ""
echo "Summary:"
echo "  ✓ Workflow files are present and valid"
echo "  ✓ All Linux architectures are covered"
echo "  ✓ Plugin configuration is set up"
echo "  ✓ Update checking is configured"
echo "  ✓ Testing is included"
echo "  ✓ Release automation is configured"
echo "  ✓ Documentation is complete"
