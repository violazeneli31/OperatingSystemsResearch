#!/bin/bash

# Optimized Primes Generator
# Uses Sieve of Eratosthenes for better performance

LIMIT=${1:-1000}

# Mark all numbers initially as prime
declare -a is_prime
for ((i=2; i<=LIMIT; i++)); do
    is_prime[$i]=1
done

# Sieve of Eratosthenes
for ((i=2; i*i<=LIMIT; i++)); do
    if [[ ${is_prime[$i]} -eq 1 ]]; then
        for ((j=i*i; j<=LIMIT; j+=i)); do
            is_prime[$j]=0
        done
    fi
done

# Output primes
for ((i=2; i<=LIMIT; i++)); do
    [[ ${is_prime[$i]} -eq 1 ]] && echo -n "$i "
done

echo ""
exit 0
