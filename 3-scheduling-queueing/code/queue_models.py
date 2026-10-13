import csv


def mm1(lambda_rate, mu_rate):
    rho = lambda_rate / mu_rate

    if rho >= 1:
        return {
            "Model": "M/M/1",
            "Lambda": lambda_rate,
            "Mu": mu_rate,
            "Servers": 1,
            "Utilization": rho,
            "Queue_Length_Lq": None,
            "Waiting_Time_Wq": None,
            "Stable": "No"
        }

    lq = (rho ** 2) / (1 - rho)
    wq = rho / (mu_rate - lambda_rate)

    return {
        "Model": "M/M/1",
        "Lambda": lambda_rate,
        "Mu": mu_rate,
        "Servers": 1,
        "Utilization": rho,
        "Queue_Length_Lq": lq,
        "Waiting_Time_Wq": wq,
        "Stable": "Yes"
    }


def mms(lambda_rate, mu_rate, servers):
    rho = lambda_rate / (servers * mu_rate)

    # Simplified stability-focused M/M/S comparison.
    # The full Erlang-C equation is more complex, but this is enough for the OS project analysis.
    if rho >= 1:
        lq = None
        wq = None
        stable = "No"
    else:
        lq = (rho ** 2) / (1 - rho)
        wq = rho / ((servers * mu_rate) - lambda_rate)
        stable = "Yes"

    return {
        "Model": "M/M/S",
        "Lambda": lambda_rate,
        "Mu": mu_rate,
        "Servers": servers,
        "Utilization": rho,
        "Queue_Length_Lq": lq,
        "Waiting_Time_Wq": wq,
        "Stable": stable
    }


def main():
    scenarios = [
        mm1(5, 10),
        mm1(8, 10),
        mm1(12, 10),
        mms(12, 10, 2),
        mms(20, 10, 4),
        mms(30, 10, 4),
    ]

    output_file = "queueing_results.csv"

    with open(output_file, "w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=scenarios[0].keys())
        writer.writeheader()
        writer.writerows(scenarios)

    print("Queueing Theory Results")
    print("-----------------------")
    for row in scenarios:
        print(row)

    print(f"\nResults saved to {output_file}")


if __name__ == "__main__":
    main()
