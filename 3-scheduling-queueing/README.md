# Paper 3: Scheduling & Queueing

**Optimization of Multilevel Feedback Queue Scheduling and Queueing Models Using Simulation and Analytical Techniques**

We built a Python simulator of the **Multilevel Feedback Queue (MLFQ)** CPU scheduler, searched for the best settings with grid search (each averaged over 100 runs), checked system stability with **M/M/1 and M/M/S queueing models**, and tested how different arrival patterns (**uniform, exponential, Poisson**) affect performance.

📄 Full paper: [`Research Paper 3 Scheduling Queueing.pdf`](Research%20Paper%203%20Scheduling%20Queueing.pdf)

---

## Run everything with one command

```bash
pip install -r requirements.txt      # numpy, pandas, matplotlib (once)
bash run_all.sh
```
It runs the whole study in order (simulation, grid search, queueing models, randomness study, charts), which takes about 40 seconds. Everything is saved in `new_results/`: the text outputs, the CSV files and all the charts.

On Ubuntu you can install the libraries with `sudo apt install python3-numpy python3-pandas python3-matplotlib` instead of pip.

The workloads are random, so your numbers will be close to ours but not identical.

---

## What's inside

| File / folder | What it does |
|---|---|
| `code/mlfq_simulation.py` | The MLFQ scheduler simulator: generates random processes and reports waiting, turnaround and response times |
| `code/optimization.py` | Grid search over the scheduler settings (Q1, Q2, L1, L2, T), 100 runs each |
| `code/queue_models.py` | M/M/1 and M/M/S formulas: utilization, queue length, waiting time, stability |
| `code/randomness_study.py` | Compares uniform, exponential and Poisson workloads |
| `code/visualization.py` | Draws the heatmaps, 3D surface and comparison charts |
| `results/` | Our CSV results and the text output of each script |
| `plots/` | Our charts |
| `screenshots/` | Screenshots of each script running |
| `run_all.sh` | Runs the whole study |
| `requirements.txt` | The Python libraries needed |

To run one part on its own, for example only the queueing models:
```bash
cd code
python3 queue_models.py
```

---

## Main results

**Best vs worst scheduler settings (grid search)**

| | Q1 | Q2 | Average waiting time |
|---|---|---|---|
| Best | 10 | 40 | **11,850.8** |
| Worst | 40 | 100 | 14,380.5 |

**Workload distribution comparison**

| Distribution | Avg waiting time | Avg response time |
|---|---|---|
| Uniform | 12,304 | 726 |
| Exponential | **12,206** | 733 |
| Poisson | 12,256 | 782 |

* **Smaller time quanta** gave lower waiting times and better responsiveness. The gap between the best and worst settings was over 2,500 time units.
* **Queueing models:** the system stays stable only while utilization is below 1 (arrival rate < service rate). Adding servers (M/M/S) lowers utilization and keeps the queue short.
* **Arrival pattern matters a little:** exponential arrivals gave the lowest waiting time, and Poisson the highest response time. Throughput was the same for all three.
