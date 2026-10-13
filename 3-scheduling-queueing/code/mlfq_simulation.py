import random
from dataclasses import dataclass
from typing import List, Dict


@dataclass
class Process:
    pid: int
    arrival_time: int
    burst_time: int
    remaining_time: int
    first_execution_time: int = -1
    completion_time: int = 0


def generate_processes(
    num_processes: int = 50,
    burst_min: int = 10,
    burst_max: int = 1000,
    arrival_distribution: str = "uniform",
    seed: int | None = None
) -> List[Process]:
    """
    Generates a random workload.
    Burst times are between 10 and 1000 CPU time units.
    Arrival times are stochastic.
    """
    if seed is not None:
        random.seed(seed)

    processes = []
    current_arrival = 0

    for pid in range(1, num_processes + 1):
        burst = random.randint(burst_min, burst_max)

        if arrival_distribution == "uniform":
            interarrival = random.randint(0, 20)
        elif arrival_distribution == "exponential":
            interarrival = int(random.expovariate(1 / 10))
        elif arrival_distribution == "poisson":
            # Approximation of Poisson-style arrival gaps using exponential interarrival time
            interarrival = int(random.expovariate(1 / 8))
        else:
            raise ValueError("Invalid arrival distribution. Use uniform, exponential, or poisson.")

        current_arrival += interarrival

        processes.append(Process(
            pid=pid,
            arrival_time=current_arrival,
            burst_time=burst,
            remaining_time=burst
        ))

    return processes


def run_mlfq(
    processes: List[Process],
    q1: int,
    q2: int,
    l1: int,
    l2: int,
    threshold_t: int
) -> Dict[str, float]:
    """
    Runs a simplified three-level MLFQ scheduler:
    Q1: Round Robin
    Q2: Round Robin
    Q3: FCFS or SJF depending on threshold T
    """
    processes = sorted(processes, key=lambda p: p.arrival_time)
    time = 0
    completed = []
    not_arrived = processes[:]

    queue1 = []
    queue2 = []
    queue3 = []

    def add_arrivals():
        nonlocal not_arrived
        arrived = [p for p in not_arrived if p.arrival_time <= time]
        queue1.extend(arrived)
        not_arrived = [p for p in not_arrived if p.arrival_time > time]

    while len(completed) < len(processes):
        add_arrivals()

        if not queue1 and not queue2 and not queue3:
            if not_arrived:
                time = not_arrived[0].arrival_time
                add_arrivals()
            else:
                break

        if queue1:
            process = queue1.pop(0)
            quantum = q1 * l1
        elif queue2:
            process = queue2.pop(0)
            quantum = q2 * l2
        else:
            # T decides whether Q3 behaves more like SJF or FCFS.
            if threshold_t <= 200:
                queue3.sort(key=lambda p: p.remaining_time)
            process = queue3.pop(0)
            quantum = process.remaining_time

        if process.first_execution_time == -1:
            process.first_execution_time = time

        execution_time = min(quantum, process.remaining_time)
        process.remaining_time -= execution_time
        time += execution_time

        add_arrivals()

        if process.remaining_time == 0:
            process.completion_time = time
            completed.append(process)
        else:
            if quantum == q1 * l1:
                queue2.append(process)
            elif quantum == q2 * l2:
                queue3.append(process)
            else:
                queue3.append(process)

    total_time = max(p.completion_time for p in completed) if completed else 1

    turnaround_times = [p.completion_time - p.arrival_time for p in completed]
    waiting_times = [tat - p.burst_time for tat, p in zip(turnaround_times, completed)]
    response_times = [p.first_execution_time - p.arrival_time for p in completed]

    return {
        "throughput": len(completed) / total_time,
        "avg_turnaround_time": sum(turnaround_times) / len(turnaround_times),
        "avg_waiting_time": sum(waiting_times) / len(waiting_times),
        "avg_response_time": sum(response_times) / len(response_times),
        "completed_processes": len(completed),
        "total_time": total_time
    }


if __name__ == "__main__":
    workload = generate_processes(num_processes=50, arrival_distribution="uniform", seed=1)

    results = run_mlfq(
        processes=workload,
        q1=20,
        q2=60,
        l1=2,
        l2=3,
        threshold_t=200
    )

    print("MLFQ Simulation Results")
    print("----------------------")
    for key, value in results.items():
        print(f"{key}: {value:.4f}" if isinstance(value, float) else f"{key}: {value}")
