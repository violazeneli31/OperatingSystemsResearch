#!/bin/bash
# Runs every original and optimized script and compares their speed and memory.
# Run from this folder:   bash run_all.sh        (10 runs per script, like in the paper)
#                         bash run_all.sh 3      (quicker: 3 runs per script)
# Results are saved in new_results/timing.csv. Your original results/ folder is not touched.

RUNS=${1:-10}
HERE="$(cd "$(dirname "$0")" && pwd)"
S="$HERE/scripts"
OUT="$HERE/new_results"
BOX="$(mktemp -d)"            # a safe test folder (some scripts rename files)
MEM="$(mktemp)"               # where /usr/bin/time writes the memory figure
mkdir -p "$OUT"

# Fresh test folder before every run: files with spaces, files to rename, a few subfolders
prepare_box() {
  rm -rf "$BOX"/*
  touch "$BOX/my file 1.txt" "$BOX/my file 2.txt" "$BOX/old_report.txt" "$BOX/old_notes.txt"
  mkdir -p "$BOX/a/b/c" "$BOX/d/e" "$BOX/f"
}

# Arguments each script needs
args_for() {
  case "$1" in
    collatz)      echo "27" ;;
    days-between) echo "1/1/2026 6/17/2026" ;;
    mailformat)   echo "$S/mailformat/original/test_email.txt" ;;
    makedict)     echo "$S/mailformat/original/test_email.txt" ;;
    rn)           echo "old new" ;;
    strip-header) echo "$S/strip-header/original/test_header.txt" ;;
    tree)         echo "$BOX" ;;
    *)            echo "" ;;
  esac
}

# Runs one script RUNS times; prints "average_milliseconds average_memory_KB"
# (time from Bash's microsecond clock, peak memory from /usr/bin/time)
measure() {
  local file="$1" name="$2" total_t=0 total_m=0 start end m
  for ((r = 1; r <= RUNS; r++)); do
    prepare_box
    start=$EPOCHREALTIME
    ( cd "$BOX" && /usr/bin/time -f "%M" -o "$MEM" bash "$file" $(args_for "$name") >/dev/null 2>&1 )
    end=$EPOCHREALTIME
    m=$(tail -1 "$MEM")
    total_t=$(awk "BEGIN{print $total_t + ($end - $start) * 1000}")
    total_m=$(awk "BEGIN{print $total_m + $m}")
  done
  awk "BEGIN{printf \"%.2f %d\", $total_t / $RUNS, $total_m / $RUNS}"
}

echo "Script,Original Time (ms),Optimized Time (ms),Original Memory (KB),Optimized Memory (KB)" > "$OUT/timing.csv"
printf "%-16s %14s %14s %14s %14s\n" "Script" "Original (ms)" "Optimized (ms)" "Orig mem (KB)" "Opt mem (KB)"

for name in blank-rename collatz days-between mailformat makedict primes random-password rn strip-header tree; do
  read -r t1 m1 <<< "$(measure "$(ls "$S/$name"/original/*.sh)"  "$name")"
  read -r t2 m2 <<< "$(measure "$(ls "$S/$name"/optimized/*.sh)" "$name")"
  printf "%-16s %14s %14s %14s %14s\n" "$name" "$t1" "$t2" "$m1" "$m2"
  echo "$name,$t1,$t2,$m1,$m2" >> "$OUT/timing.csv"
done

rm -rf "$BOX" "$MEM"
echo
echo "Saved: new_results/timing.csv ($RUNS runs per script)"
