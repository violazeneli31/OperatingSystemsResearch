#!/bin/bash
# Builds and runs all five programs with the settings used in the paper.
# Run from this folder:   bash run_all.sh
# Results are saved in new_results/. Your original result folders are not touched.

cd "$(dirname "$0")" || exit 1
mkdir -p build new_results

echo "=== Building ==="
gcc -O2 -pthread code/pc_pthreads.c  -o build/pc       || exit 1
gcc -O2 -pthread code/dp_semaphore.c -o build/dp_sem   || exit 1
gcc -O2 -pthread code/dp_monitor.c   -o build/dp_mon   || exit 1
gcc -O2 -pthread code/dp_hierarchy.c -o build/dp_hier  || exit 1
if javac -version >/dev/null 2>&1; then
  javac -d build code/ProducerConsumer.java            || exit 1
  JAVA_RUN="java -cp build ProducerConsumer"
else
  JAVA_RUN="java code/ProducerConsumer.java"           # Java 11+ can run the source file directly
fi
echo "OK"

# ---------- Producer-Consumer: 100,000 items, 2 producers, 2 consumers ----------
echo
echo "=== Producer-Consumer (time in seconds) ==="
printf "%-8s %14s %14s\n" "Buffer" "POSIX (C)" "Java"
echo "Buffer,POSIX Time (s),Java Time (s)" > new_results/producer_consumer.csv
for B in 10 50 100; do
  c=$(./build/pc "$B" 100000 2 2 | grep -o 'TIME=[0-9.]*' | cut -d= -f2)
  j=$($JAVA_RUN "$B" 100000 2 2 | grep -o 'TIME=[0-9.]*' | cut -d= -f2)
  printf "%-8s %14s %14s\n" "$B" "$c" "$j"
  echo "$B,$c,$j" >> new_results/producer_consumer.csv
done

# ---------- Dining Philosophers: 1000 rounds each ----------
elapsed() { /usr/bin/time -f "%e" "$@" 2>&1 >/dev/null | tail -1; }

echo
echo "=== Dining Philosophers, 1000 rounds (time in seconds) ==="
printf "%-13s %12s %12s %12s\n" "Philosophers" "Semaphore" "Monitor" "Hierarchy"
echo "Philosophers,Semaphore (s),Monitor (s),Hierarchy (s)" > new_results/dining_philosophers.csv
for N in 5 10 20 50; do
  s=$(elapsed ./build/dp_sem "$N" 1000 1)
  m=$(elapsed ./build/dp_mon "$N" 1000)
  h=$(elapsed ./build/dp_hier "$N" 1000)
  printf "%-13s %12s %12s %12s\n" "$N" "$s" "$m" "$h"
  echo "$N,$s,$m,$h" >> new_results/dining_philosophers.csv
done

echo
echo "Saved: new_results/producer_consumer.csv and new_results/dining_philosophers.csv"
