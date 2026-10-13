#!/bin/bash

# ==============================================================
# Primes Generator - Analysis Version
# Purpose:
# Generates all prime numbers up to a specified limit using
# trial division method with recursive optimization.
#
# Added:
# - Detailed comments explaining recursion logic
# - Prime counting and statistics
# - Execution trace information
# ==============================================================

echo "=================================="
echo "   Prime Number Generator"
echo "=================================="

LIMIT=1000
PRIME_COUNT=0

echo "Configuration:"
echo "  Upper limit: $LIMIT"
echo "  Method: Trial division with recursion"
echo "  Optimization: Square root check (i*i > n)"
echo ""
echo "Generating primes..."
echo ""

Primes() {
    (( n = $1 + 1 ))  # Move to next candidate
    shift
    
    # Base case: reached limit
    if (( n == LIMIT )); then
        echo $*
        return
    fi
    
    # Test against all previously found primes
    for i; do
        (( i * i > n )) && break  # Optimization: no need to check beyond sqrt(n)
        (( n % i )) && continue   # If not divisible, continue testing
        Primes $n $@              # Found divisor, recurse without this prime
        return
    done
    
    # No divisors found, n is prime
    Primes $n $@ $n  # Add n to the list of primes
}

# Generate and count primes
prime_list=$(Primes 1)
PRIME_COUNT=$(echo $prime_list | wc -w)

echo "=================================="
echo "       Primes Generated"
echo "=================================="
echo "$prime_list"
echo ""
echo "Statistics:"
echo "  Primes found: $PRIME_COUNT"
echo "  Range: 2 to $LIMIT"

exit $?
