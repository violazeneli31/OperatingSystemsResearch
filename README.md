# Operating Systems: Research Papers

Three research papers for the **Operating Systems** course at Epoka University (Department of Computer Engineering). Each one comes with the code we wrote, the raw measurements and screenshots, plus a `run_all.sh` script that repeats the whole experiment with one command.

| # | Paper | Topic | Language |
|---|---|---|---|
| 1 | [Shell Script Research](1-shell-script-research/) | Measuring and optimizing 10 Unix shell scripts | Bash |
| 2 | [Multithreaded Synchronization](2-multithreaded-synchronization/) | Producer–Consumer and Dining Philosophers with different synchronization techniques | C (POSIX threads), Java |
| 3 | [Scheduling & Queueing](3-scheduling-queueing/) | Tuning a Multilevel Feedback Queue scheduler with simulation and queueing theory | Python |

Each folder has its own README that explains what the paper does, what's inside, how to run it and the main results.

---

## Main findings at a glance

* **Paper 1:** small changes to shell scripts make a big difference. Using Bash built-ins instead of external commands and fewer pipelines made the prime generator **96% faster** with **90% less memory**, and the directory tree viewer went from **0.44 s to under 0.01 s**.
* **Paper 2:** for Producer–Consumer, **Java threads** gave the highest throughput (128,000 items/s vs 7,500 for POSIX threads), while **POSIX threads** used far less memory (1.8 MB vs 45 MB). For Dining Philosophers, the **semaphore** solution scaled best. No deadlocks occurred in any solution.
* **Paper 3:** smaller time quanta (Q1 = 10, Q2 = 40) gave the **lowest waiting time**, more than 2,500 time units better than the worst setting. The queueing models showed the system is only stable while utilization stays below 1.

---

## Run it yourself

All experiments were run on **Ubuntu Linux** (in VirtualBox).

**1. Install what's needed (once):**
```bash
sudo apt update
sudo apt install -y time strace build-essential default-jdk python3-numpy python3-pandas python3-matplotlib
```

**2. Go into a paper's folder and run its script:**

| Paper | Commands | Takes |
|---|---|---|
| 1 | `cd 1-shell-script-research` then `bash run_all.sh` | ~10 s |
| 2 | `cd 2-multithreaded-synchronization` then `bash run_all.sh` | ~40 s |
| 3 | `cd 3-scheduling-queueing` then `bash run_all.sh` | ~40 s |

Each script prints a results table and saves everything in a new `new_results/` folder inside that paper's folder. The published results are never overwritten.

Times depend on the computer, so your numbers will differ from ours, but the comparisons (which version is faster, which technique scales better) should come out the same.

---

## Authors

Sidrit Rrustemi, Viola Zeneli, Artemisa Hasalami
