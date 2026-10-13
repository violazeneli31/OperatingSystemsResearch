#!/bin/bash
# Runs the whole study: simulation, grid search, queueing models, randomness study and charts.
# Run from this folder:   bash run_all.sh      (takes about 1 minute)
# Everything is saved in new_results/. Your original results/ and plots/ folders are not touched.

cd "$(dirname "$0")" || exit 1
mkdir -p new_results/results
cd new_results || exit 1

echo "1/5 MLFQ simulation...";        python3 ../code/mlfq_simulation.py  > mlfq_simulation_output.txt
echo "2/5 Grid-search optimization..."; python3 ../code/optimization.py   > optimization_output.txt
echo "3/5 Queueing models...";          python3 ../code/queue_models.py   > queueing_output.txt
echo "4/5 Randomness study...";         python3 ../code/randomness_study.py > randomness_output.txt
mv ./*.csv results/

echo "5/5 Charts...";                   python3 ../code/visualization.py  > /dev/null

echo
echo "Best configuration found:"
grep -A1 "Best configuration by waiting time" optimization_output.txt | tail -1
echo
echo "Saved in new_results/: text outputs, results/*.csv and the PNG charts"
