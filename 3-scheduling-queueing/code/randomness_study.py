import csv
from mlfq_simulation import generate_processes, run_mlfq


TRIALS = 100
NUM_PROCESSES = 50
DISTRIBUTIONS = ["uniform", "exponential", "poisson"]


def average_results(results_list):
    keys = results_list[0].keys()
    return {
        key: sum(r[key] for r in results_list) / len(results_list)
        for key in keys
    }


def main():
    rows = []

    # Use one reasonable configuration found from the parameter study.
    q1 = 20
    q2 = 60
    l1 = 2
    l2 = 3
    t = 200

    print("Starting randomness study...")
    print(f"Trials per distribution: {TRIALS}")

    for distribution in DISTRIBUTIONS:
        trial_results = []

        for trial in range(TRIALS):
            workload = generate_processes(
                num_processes=NUM_PROCESSES,
                arrival_distribution=distribution,
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
            "Distribution": distribution,
            "Throughput": avg["throughput"],
            "Average_Turnaround_Time": avg["avg_turnaround_time"],
            "Average_Waiting_Time": avg["avg_waiting_time"],
            "Average_Response_Time": avg["avg_response_time"],
            "Completed_Processes": avg["completed_processes"],
            "Total_Time": avg["total_time"]
        }

        rows.append(row)

        print(
            f"{distribution}: Waiting={row['Average_Waiting_Time']:.2f}, "
            f"Response={row['Average_Response_Time']:.2f}, "
            f"Throughput={row['Throughput']:.4f}"
        )

    output_file = "distribution_results.csv"

    with open(output_file, "w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)

    print(f"\nResults saved to {output_file}")


if __name__ == "__main__":
    main()
