#!/bin/bash

# Automated test script for helm-microservice
# This script runs all test cases and verifies the output

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Directory containing test values
TEST_VALUES_DIR="$(dirname "$0")/test-values"
# Directory containing expected results
EXPECTED_RESULTS_DIR="$TEST_VALUES_DIR/expected-results"
# Temporary directory for test outputs
TMP_DIR="/tmp/helm-test-results"

# Create temporary directory if it doesn't exist
mkdir -p "$TMP_DIR"

# Function to display usage information
show_usage() {
    echo "Usage: $0 [OPTIONS] [TEST_NAME]"
    echo ""
    echo "Options:"
    echo "  --update-expected     Update all expected results"
    echo "  --help                Show this help message"
    echo ""
    echo "Arguments:"
    echo "  TEST_NAME             Run only the specified test (without .yaml extension)"
    echo ""
    echo "Examples:"
    echo "  $0                    Run all tests"
    echo "  $0 sts                Run only the 'sts' test"
    echo "  $0 --update-expected  Update all expected results"
}

echo -e "${YELLOW}Starting Helm chart tests...${NC}"

# Function to run a test case
run_test() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .yaml)
    local output_file="$TMP_DIR/$test_name.yaml"
    
    echo -e "${YELLOW}Running test: $test_name${NC}"
    
    # Run helm template with the test values
    helm template --debug --values "$test_file" release-name .. > "$output_file" 
    
    # Check if expected result exists
    if [ -f "$EXPECTED_RESULTS_DIR/$test_name.yaml" ]; then
        # Normalize chart versions in both files to avoid version-specific differences
        expected_normalized="$TMP_DIR/${test_name}_expected_normalized.yaml"
        output_normalized="$TMP_DIR/${test_name}_output_normalized.yaml"
        
        # Replace chart version with a placeholder in both files
        sed 's/helm.sh\/chart: app-[0-9]\+\.[0-9]\+\.[0-9]\+/helm.sh\/chart: app-VERSION/g' "$EXPECTED_RESULTS_DIR/$test_name.yaml" > "$expected_normalized"
        sed 's/helm.sh\/chart: app-[0-9]\+\.[0-9]\+\.[0-9]\+/helm.sh\/chart: app-VERSION/g' "$output_file" > "$output_normalized"
        
        # Compare normalized files
        if diff -u "$expected_normalized" "$output_normalized" > "$TMP_DIR/$test_name.diff"; then
            echo -e "${GREEN}✓ Test passed: $test_name${NC}"
            return 0
        else
            echo -e "${RED}✗ Test failed: $test_name${NC}"
            echo -e "${YELLOW}Diff:${NC}"
            cat "$TMP_DIR/$test_name.diff"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ No expected result for $test_name. Generating expected result.${NC}"
        # Copy output as expected result
        cp "$output_file" "$EXPECTED_RESULTS_DIR/$test_name.yaml"
        echo -e "${GREEN}✓ Expected result generated: $test_name${NC}"
        return 0
    fi
}

# Function to update expected results
update_expected_results() {
    echo -e "${YELLOW}Updating expected results...${NC}"
    
    for test_file in "$TEST_VALUES_DIR"/*.yaml; do
        local test_name=$(basename "$test_file" .yaml)
        local output_file="$TMP_DIR/$test_name.yaml"
        
        # Run helm template with the test values
        helm template --debug --values "$test_file" release-name .. > "$output_file" 2>/dev/null
        
        # Copy output as expected result
        cp "$output_file" "$EXPECTED_RESULTS_DIR/$test_name.yaml"
        echo -e "${GREEN}✓ Updated expected result: $test_name${NC}"
    done
}

# Parse command line arguments
if [ "$1" == "--help" ]; then
    show_usage
    exit 0
fi

if [ "$1" == "--update-expected" ]; then
    update_expected_results
    exit 0
fi

# Initialize counters
failed_tests=0
total_tests=0

# Check if a specific test name was provided
if [ -n "$1" ]; then
    # Run only the specified test
    test_file="$TEST_VALUES_DIR/$1.yaml"
    
    if [ -f "$test_file" ]; then
        total_tests=1
        if ! run_test "$test_file"; then
            failed_tests=1
        fi
    else
        echo -e "${RED}Error: Test file '$1.yaml' not found in $TEST_VALUES_DIR${NC}"
        echo -e "Available tests:"
        for available_test in "$TEST_VALUES_DIR"/*.yaml; do
            echo "  $(basename "$available_test" .yaml)"
        done
        exit 1
    fi
else
    # Run all tests
    for test_file in "$TEST_VALUES_DIR"/*.yaml; do
        total_tests=$((total_tests + 1))
        if ! run_test "$test_file"; then
            failed_tests=$((failed_tests + 1))
        fi
    done
fi

# Print summary
echo -e "${YELLOW}Test summary:${NC}"
echo -e "Total tests: $total_tests"
echo -e "Failed tests: $failed_tests"

if [ $failed_tests -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
