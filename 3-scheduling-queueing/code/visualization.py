import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np


def plot_heatmap(data, value_column, output_name, title):
    pivot = data.pivot_table(
        values=value_column,
        index="Q1",
        columns="Q2",
        aggfunc="mean"
    )

    fig, ax = plt.subplots(figsize=(10, 7))
    
    # Use a better colormap and normalize the values
    im = ax.imshow(pivot.values, aspect="auto", cmap='RdYlGn_r', interpolation='nearest')

    ax.set_xticks(range(len(pivot.columns)))
    ax.set_xticklabels(pivot.columns)
    ax.set_yticks(range(len(pivot.index)))
    ax.set_yticklabels(pivot.index)

    ax.set_xlabel("Q2 Time Quantum", fontsize=12, fontweight='bold')
    ax.set_ylabel("Q1 Time Quantum", fontsize=12, fontweight='bold')
    ax.set_title(title, fontsize=14, fontweight='bold')

    # Improved text annotations with better contrast
    for i in range(len(pivot.index)):
        for j in range(len(pivot.columns)):
            value = pivot.values[i, j]
            ax.text(j, i, f"{value:.1f}", ha="center", va="center", 
                   color="white" if value > np.nanmean(pivot.values) else "black",
                   fontweight='bold', fontsize=9)

    cbar = fig.colorbar(im, ax=ax)
    cbar.set_label(value_column.replace('_', ' '), fontsize=11, fontweight='bold')
    plt.tight_layout()
    plt.savefig(output_name, dpi=300)
    plt.close()


def plot_surface(data):
    grouped = data.groupby(["Q1", "Q2"], as_index=False)["Average_Waiting_Time"].mean()

    fig = plt.figure(figsize=(11, 8))
    ax = fig.add_subplot(111, projection="3d")

    surf = ax.plot_trisurf(
        grouped["Q1"],
        grouped["Q2"],
        grouped["Average_Waiting_Time"],
        cmap='viridis',
        linewidth=0.2,
        antialiased=True,
        alpha=0.8
    )

    ax.set_xlabel("Q1 Time Quantum", fontsize=11, fontweight='bold')
    ax.set_ylabel("Q2 Time Quantum", fontsize=11, fontweight='bold')
    ax.set_zlabel("Average Waiting Time", fontsize=11, fontweight='bold')
    ax.set_title("3D Performance Surface: Waiting Time", fontsize=13, fontweight='bold')
    
    fig.colorbar(surf, ax=ax, label="Waiting Time")

    plt.tight_layout()
    plt.savefig("surface_waiting_time.png", dpi=300)
    plt.close()


def plot_distribution_comparison():
    data = pd.read_csv("results/distribution_results.csv")

    fig, ax = plt.subplots(figsize=(10, 6))
    bars = ax.bar(data["Distribution"], data["Average_Waiting_Time"], color='steelblue', edgecolor='navy', linewidth=1.5)
    
    # Add value labels on bars
    for bar in bars:
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2., height,
               f'{height:.1f}',
               ha='center', va='bottom', fontweight='bold', fontsize=10)
    
    ax.set_xlabel("Distribution", fontsize=12, fontweight='bold')
    ax.set_ylabel("Average Waiting Time", fontsize=12, fontweight='bold')
    ax.set_title("Waiting Time Comparison by Workload Distribution", fontsize=13, fontweight='bold')
    ax.grid(axis='y', alpha=0.3, linestyle='--')
    plt.xticks(rotation=15, ha='right')
    plt.tight_layout()
    plt.savefig("distribution_comparison.png", dpi=300)
    plt.close()


def plot_queueing_results():
    data = pd.read_csv("results/queueing_results.csv")

    labels = data["Model"] + " S=" + data["Servers"].astype(str) + " λ=" + data["Lambda"].astype(str)

    fig, ax = plt.subplots(figsize=(11, 6))
    bars = ax.bar(labels, data["Utilization"], color='coral', edgecolor='darkred', linewidth=1.5)
    
    # Add value labels on bars
    for bar in bars:
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2., height,
               f'{height:.3f}',
               ha='center', va='bottom', fontweight='bold', fontsize=9)
    
    ax.set_xlabel("Queueing Scenario", fontsize=12, fontweight='bold')
    ax.set_ylabel("Utilization", fontsize=12, fontweight='bold')
    ax.set_title("Queueing Model Utilization Comparison", fontsize=13, fontweight='bold')
    ax.grid(axis='y', alpha=0.3, linestyle='--')
    ax.set_ylim(0, max(data["Utilization"]) * 1.15)
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    plt.savefig("queueing_utilization.png", dpi=300)
    plt.close()


def main():
    data = pd.read_csv("results/optimization_results.csv")

    plot_heatmap(
        data,
        value_column="Average_Waiting_Time",
        output_name="heatmap_waiting_time.png",
        title="Heatmap of Average Waiting Time"
    )

    plot_heatmap(
        data,
        value_column="Throughput",
        output_name="heatmap_throughput.png",
        title="Heatmap of Throughput"
    )

    plot_surface(data)
    plot_distribution_comparison()
    plot_queueing_results()

    print("Visualization files generated:")
    print("- heatmap_waiting_time.png")
    print("- heatmap_throughput.png")
    print("- surface_waiting_time.png")
    print("- distribution_comparison.png")
    print("- queueing_utilization.png")


if __name__ == "__main__":
    main()
