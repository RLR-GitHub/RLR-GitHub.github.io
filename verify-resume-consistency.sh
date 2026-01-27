#!/bin/bash

# Cross-Platform Resume Verification Script
# Validates resume data consistency across all portfolio platforms
# Date: November 30, 2025

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Cross-Platform Resume Verification                       ║${NC}"
echo -e "${BLUE}║  Date: $(date '+%Y-%m-%d %H:%M:%S')                          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to check if string exists in content
check_content() {
    local url=$1
    local search_string=$2
    local description=$3

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    echo -n "  Testing: $description... "

    # Fetch content (follow redirects, timeout after 10s)
    content=$(curl -sL --max-time 10 "$url" 2>/dev/null || echo "FETCH_FAILED")

    if [[ "$content" == "FETCH_FAILED" ]]; then
        echo -e "${RED}✗ FAILED (Could not fetch URL)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi

    if echo "$content" | grep -q "$search_string"; then
        echo -e "${GREEN}✓ PASSED${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        echo -e "${RED}✗ FAILED (String not found)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# Function to check HTTP status
check_url_status() {
    local url=$1
    local description=$2

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    echo -n "  Testing: $description... "

    status=$(curl -sL -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")

    if [[ "$status" == "200" ]]; then
        echo -e "${GREEN}✓ PASSED (HTTP $status)${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        echo -e "${RED}✗ FAILED (HTTP $status)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}1. URL Accessibility Tests${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"

check_url_status "https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html" \
    "MASTER Resume (rory.engineer)"

check_url_status "https://rodericklrenwick.com/__RLR_RESUME2025-v3.html" \
    "Resume Mirror (rodericklrenwick.com)"

check_url_status "https://rlr-github.github.io/2026resume.html" \
    "Resume Mirror (rlr-github.github.io)"

check_url_status "https://rory.computer" \
    "Terminal CV (rory.computer)"

check_url_status "https://github.com/RLR-GitHub" \
    "GitHub Profile (RLR-GitHub)"

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}2. Graduation Status Verification${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"

check_content "https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html" \
    "February 2026" \
    "Purdue graduation (rory.engineer)"

check_content "https://rodericklrenwick.com/__RLR_RESUME2025-v3.html" \
    "February 2026" \
    "Purdue graduation (rodericklrenwick.com)"

check_content "https://github.com/RLR-GitHub" \
    "February 2026" \
    "Purdue graduation (GitHub profile)"

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}3. UM-Dearborn Graduation Verification${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"

check_content "https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html" \
    "Winter 2020" \
    "UM-D graduation date (rory.engineer)"

check_content "https://rodericklrenwick.com/__RLR_RESUME2025-v3.html" \
    "Winter 2020" \
    "UM-D graduation date (rodericklrenwick.com)"

check_content "https://github.com/RLR-GitHub" \
    "Winter 2020" \
    "UM-D graduation date (GitHub profile)"

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}4. Experience Timeline Verification${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"

check_content "https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html" \
    "Summer 2023" \
    "Raytheon timeline (rory.engineer)"

check_content "https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html" \
    "Summer 2017" \
    "Ford timeline (rory.engineer)"

check_content "https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html" \
    "Summer 2018" \
    "MDAS.ai timeline (rory.engineer)"

check_content "https://github.com/RLR-GitHub" \
    "Summer 2023" \
    "Raytheon timeline (GitHub profile)"

check_content "https://github.com/RLR-GitHub" \
    "Summer 2017" \
    "Ford timeline (GitHub profile)"

check_content "https://github.com/RLR-GitHub" \
    "Summer 2018" \
    "MDAS.ai timeline (GitHub profile)"

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}5. Deprecated Language Check (Should NOT Exist)${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"

# These should FAIL to find (which means PASS for our purposes)
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "  Testing: No 'Expected' language (rory.engineer)... "
if curl -sL "https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html" 2>/dev/null | grep -q "Expected.*2025"; then
    echo -e "${RED}✗ FAILED (Found deprecated language)${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
else
    echo -e "${GREEN}✓ PASSED (No deprecated language)${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
fi

TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "  Testing: No 'Candidate' language (GitHub)... "
if curl -sL "https://github.com/RLR-GitHub" 2>/dev/null | grep -q "M.S. Candidate"; then
    echo -e "${RED}✗ FAILED (Found deprecated language)${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
else
    echo -e "${GREEN}✓ PASSED (No deprecated language)${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "  Total Tests:  $TOTAL_TESTS"
echo -e "  ${GREEN}Passed:       $PASSED_TESTS${NC}"
echo -e "  ${RED}Failed:       $FAILED_TESTS${NC}"
echo ""

# Calculate pass rate
if [ $TOTAL_TESTS -gt 0 ]; then
    pass_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "  Pass Rate:    ${pass_rate}%"
    echo ""

    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "${GREEN}✓ ALL TESTS PASSED - Resume consistency verified!${NC}"
        exit 0
    elif [ $pass_rate -ge 80 ]; then
        echo -e "${YELLOW}⚠ MOSTLY PASSING - Some issues detected${NC}"
        exit 1
    else
        echo -e "${RED}✗ SIGNIFICANT FAILURES - Review resume content${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ NO TESTS RUN${NC}"
    exit 1
fi
