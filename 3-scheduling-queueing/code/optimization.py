import csv
from mlfq_simulation import generate_processes, run_mlfq


Q1_VALUES = [10, 20, 30, 40]
Q2_VALUES = [40, 60, 80, 100]
L1_VALUES = [1, 2, 3]
L2_VALUES = [2, 3, 4]
T_VALUES = [100, 200, 300]

TRIALS = 100
NUM_PROCESSES = 50


def average_results(results_list):
    keys = results_list[0].keys()
    return {
        key: sum(r[key] for r in results_list) / len(results_list)
        for key in keys
    }


def main():
    output_file = "optimization_results.csv"
    rows = []

    print("Starting grid search optimization...")
    print(f"Trials per configuration: {TRIALS}")

    for q1 in Q1_VALUES:
        for q2 in Q2_VALUES:
            for l1 in L1_VALUES:
                for l2 in L2_VALUES:
                    for t in T_VALUES:
                        trial_results = []

                        for trial in range(TRIALS):
                            workload = generate_processes(
                                num_processes=NUM_PROCESSES,
                                arrival_distribution="uniform",
                                seed=trial
                            )

                            result = run_mlfq(
                                processes=workload,
                                q1=q1,
                                q2=q2,
                                l1=l1,
                                l2=l2,
                                threshold_t=t
                            )
                            trial_results.append(result)

                        avg = average_results(trial_results)

                        row = {
                            "Q1": q1,
                            "Q2": q2,
                            "L1": l1,
                            "L2": l2,
                            "T": t,
                            "Throughput": avg["throughput"],
                            "Average_Turnaround_Time": avg["avg_turnaround_time"],
                            "Average_Waiting_Time": avg["avg_waiting_time"],
                            "Average_Response_Time": avg["avg_response_time"],
                            "Completed_Processes": avg["completed_processes"],
                            "Total_Time": avg["total_time"]
                        }
                        rows.append(row)

                        print(
                            f"Tested Q1={q1}, Q2={q2}, L1={l1}, L2={l2}, T={t} | "
                            f"Waiting={row['Average_Waiting_Time']:.2f}, "
                            f"Throughput={row['Throughput']:.4f}"
                        )

    with open(output_file, "w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)

    best_waiting = min(rows, key=lambda r: r["Average_Waiting_Time"])
    best_response = min(rows, key=lambda r: r["Average_Response_Time"])
    best_throughput = max(rows, key=lambda r: r["Throughput"])

    print("\nGrid search completed.")
    print(f"Results saved to {output_file}")

    print("\nBest configuration by waiting time:")
    print(best_waiting)

    print("\nBest configuration by response time:")
    print(best_response)

    print("\nBest configuration by throughput:")
    print(best_throughput)


if __name__ == "__main__":
    main()
