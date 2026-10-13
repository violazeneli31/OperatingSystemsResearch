# Paper 1: Shell Script Research

**Experimental Analysis, Optimization, and Design Patterns in Unix Shell Scripts for System-Level Automation**

We took 10 classic Unix shell scripts, measured how they behave (time, CPU, memory, system calls), wrote an optimized version of each, and compared the two. We also identified common design patterns and built a new tool, the **Intelligent File Organizer**.

📄 Full paper: [`Research Paper 1 Shell Script Research.pdf`](Research%20Paper%201%20Shell%20Script%20Research.pdf)

---

## Run everything with one command

```bash
bash run_all.sh        # 10 runs per script, like in the paper (~10 seconds)
bash run_all.sh 3      # quicker: 3 runs per script
```
It runs the original and optimized version of all 10 scripts and prints a table of average time (ms) and memory (KB). The table is saved to `new_results/timing.csv`.

Scripts that rename files only run inside a temporary test folder, so nothing of yours is touched.

Needs: Bash and `/usr/bin/time` (`sudo apt install time`).

---

## What's inside

| Folder | What it contains |
|---|---|
| `scripts/<name>/original/` | The original script |
| `scripts/<name>/analyzed/` | The same script with detailed comments and extra output explaining how it works |
| `scripts/<name>/optimized/` | Our faster version |
| `scripts/intelligent-file-organizer/` | Our new tool (section 7 of the paper) |
| `results/<name>/` | Raw measurements: `time`, memory, `perf` and `strace` for the original and optimized versions |
| `results/performance_comparison.csv` | All measurements for all scripts in one table |
| `results/performance_improvements.csv` | Original vs optimized, with the improvement in % |
| `screenshots/<name>/` | Screenshots of each run and its timing |
| `run_all.sh` | Repeats the whole comparison |

### The 10 scripts

| Script | What it does | Input |
|---|---|---|
| `blank-rename` | Replaces spaces with underscores in file names | works on the current folder |
| `collatz` | Prints the Collatz ("hailstone") sequence | optional starting number |
| `days-between` | Counts the days between two dates | two dates `M/D/YYYY` |
| `mailformat` | Cleans up e-mail text (carets, tabs, long lines) | a text file |
| `makedict` | Builds a sorted list of unique words from text | a text file |
| `primes` | Lists prime numbers up to 1000 | (optimized version: optional limit) |
| `random-password` | Generates a random password | (optimized version: optional length) |
| `rn` | Renames files in the current folder by pattern | old pattern, new pattern |
| `strip-header` | Removes the header from a mail/news message | a message file |
| `tree` | Shows a directory tree | optional folder |

**How we optimized them** (section 4 of the paper):
* replaced `sed`, `grep` and `expr` with Bash built-ins;
* removed unnecessary pipelines;
* used Bash parameter expansion for string work and `(( ))` for arithmetic;
* removed redundant operations.

The original scripts are classic examples from the *Advanced Bash-Scripting Guide*. Their original authors are credited in each script's header.

---

## Run a single script

```bash
bash scripts/primes/original/primes.sh
bash scripts/primes/optimized/primes_optimized.sh 1000
bash scripts/primes/analyzed/primes_analysis.sh
bash scripts/days-between/original/days-between.sh 1/1/2026 6/17/2026
bash scripts/mailformat/original/mailformat.sh scripts/mailformat/original/test_email.txt
```

> ⚠️ `blank-rename` and `rn` **rename the files in the folder you run them in**. Run them by hand only in a test folder.

Measure one the way we did:
```bash
/usr/bin/time -v bash scripts/primes/original/primes.sh     # time, CPU, memory, context switches
strace -c bash scripts/primes/original/primes.sh            # system calls
```

## Intelligent File Organizer

Sorts the files in a folder into `Documents`, `Images`, `Archives`, `Source_Code` and `Others` by their extension:
```bash
bash scripts/intelligent-file-organizer/intelligent-file-organizer.sh ~/Downloads
```
It **moves** files, so try it on a test folder first.

---

## Main results

| Script | Original (s) | Optimized (s) | Memory original → optimized (KB) |
|---|---|---|---|
| primes | 0.27 | 0.01 | 36,492 → 3,668 |
| tree | 0.44 | < 0.01 | 3,736 → 3,612 |
| blank-rename | 0.02 | < 0.01 | 3,732 → 3,624 |
| days-between | 0.02 | < 0.01 | 3,780 → 3,584 |
| makedict | 0.02 | 0.01 | 3,620 → 3,608 |

* The biggest gains came from **primes** (96% faster, 90% less memory) and **tree** (690 → 3 voluntary context switches).
* Scripts that were already light (mailformat, random-password, strip-header) showed little or no change.
* **Lesson:** avoiding external commands, extra pipelines and subshells, and using Bash built-ins, makes scripts faster and lighter without changing what they do.

Full tables, scalability tests and design patterns are in the paper (sections 4–8).
