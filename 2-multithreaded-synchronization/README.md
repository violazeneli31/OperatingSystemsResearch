# Paper 2: Multithreaded Synchronization

**Comparative Performance Evaluation of Multithreaded Synchronization Techniques in Producer–Consumer and Dining Philosophers Problems**

We implemented two classic concurrency problems with different synchronization techniques and compared their speed, resource use and scalability:

* **Producer–Consumer:** POSIX threads in C (mutex and semaphores) vs Java threads (`ArrayBlockingQueue`).
* **Dining Philosophers:** semaphores, a monitor (mutex and condition variables), and resource hierarchy (ordered fork pick-up).

📄 Full paper: [`Research Paper 2 Multithreaded Synchronization.pdf`](Research%20Paper%202%20Multithreaded%20Synchronization.pdf)

---

## Run everything with one command

```bash
bash run_all.sh
```
It compiles all five programs and runs them with the paper's settings, which takes about 40 seconds:
* **Producer–Consumer:** 100,000 items, 2 producers and 2 consumers, buffer sizes 10, 50 and 100, in C and Java.
* **Dining Philosophers:** 5, 10, 20 and 50 philosophers, 1000 rounds each, with all three techniques.

It prints two tables and saves them in `new_results/`.

Needs: `gcc`, Java 11 or newer, and `/usr/bin/time` (`sudo apt install build-essential default-jdk time`).

---

## What's inside

| File / folder | What it is |
|---|---|
| `code/pc_pthreads.c` | Producer–Consumer, POSIX threads (C) |
| `code/ProducerConsumer.java` | Producer–Consumer, Java threads |
| `code/dp_semaphore.c` | Dining Philosophers with semaphores |
| `code/dp_monitor.c` | Dining Philosophers with a monitor |
| `code/dp_hierarchy.c` | Dining Philosophers with resource hierarchy |
| `only_execution_time_results/` | Execution times for every configuration |
| `all_metrics_results/` | Full `/usr/bin/time -v` output: CPU, memory, context switches |
| `screenshots/` | Screenshots of the runs, metrics and scalability tests |
| `run_all.sh` | Builds and runs everything |

---

## Run a single program

```bash
mkdir -p build
gcc -O2 -pthread code/pc_pthreads.c -o build/pc
./build/pc 10 100000 2 2              # buffer size, items, producers, consumers

javac -d build code/ProducerConsumer.java
java -cp build ProducerConsumer 10 100000 2 2

gcc -O2 -pthread code/dp_semaphore.c -o build/dp_sem
./build/dp_sem 5 1000 1               # philosophers, rounds, mode (1 = deadlock-free ordering, 0 = naive)
```
`dp_monitor.c` and `dp_hierarchy.c` are built the same way and take `philosophers rounds`.

To see CPU, memory and context switches: `/usr/bin/time -v ./build/pc 10 100000 2 2`

---

## Main results

**Producer–Consumer: Java vs POSIX threads**

| Metric | Java | POSIX threads |
|---|---|---|
| Throughput (items/s) | **128,000** | 7,500 |
| Execution time (ms) | **78** | 210 |
| Memory (MB) | 45 | **1.77** |
| Voluntary context switches | **585** | 11,402 |

**Dining Philosophers: execution time (ms)**

| Philosophers | Semaphore | Monitor | Hierarchy |
|---|---|---|---|
| 5 | **160** | 410 | 160 |
| 10 | **170** | 190 | 460 |
| 20 | **230** | 260 | 920 |
| 50 | **260** | 430 | 2090 |

* A **bigger buffer** made Producer–Consumer faster, because threads waited for each other less often.
* **Java** had the best throughput; **POSIX threads** used much less memory.
* **Semaphores** scaled best for Dining Philosophers. **Resource hierarchy** is the clearest way to prevent deadlock, and the **monitor** was the simplest to write.
* **No deadlocks** were observed in any solution.
