#!/bin/bash

# Define the arrays of values for p and c
# p_values=(1 5 10)  # Add or modify values as needed
# c_values=(1 4)  # Add or modify values as needed
p_values=(5)  # Add or modify values as needed
c_values=(1 4)  # Add or modify values as needed
num_npus=4
num_dims=1

TRACE_DIR="/data1/lichenni/projects/astra-sim/inputs/workload/trace"
TRACE_NAME="DLRM_HybridParallel"
TRACE_PATH="/data1/lichenni/projects/astra-sim/inputs/workload/ASTRA-sim-1.0/${TRACE_NAME}.txt"

# Loop through each combination of p and c
for p in "${p_values[@]}"; do
  for c in "${c_values[@]}"; do

    output_filename="${TRACE_DIR}/${TRACE_NAME}_p${p}_c${c}"
    
    # Execute the chakra_converter command
    chakra_converter --input_type Text --input_filename "${TRACE_PATH}" --output_filename "${output_filename}" --num_npus ${num_npus} --num_passes ${p} --num_dims ${num_dims} --num_concurrency ${c}
    
    if [ $? -eq 0 ]; then
      echo "chakra_converter successfully processed p=${p}, c=${c}"
    else
      echo "chakra_converter failed to process p=${p}, c=${c}"
      continue
    fi
    
    

    input_filename="${TRACE_DIR}/${TRACE_NAME}_p${p}_c${c}.0.et"
    output_pdf="${TRACE_DIR}/${TRACE_NAME}_p${p}_c${c}.0.pdf"
    output_json="${TRACE_DIR}/${TRACE_NAME}_p${p}_c${c}.0.json"
    
    chakra_jsonizer --input_filename "${input_filename}" --output_filename "${output_json}"

    # Execute the chakra_visualizer command
    chakra_visualizer --input_filename "${input_filename}" --output_filename "${output_pdf}"
    
    if [ $? -eq 0 ]; then
      echo "chakra_visualizer successfully processed p=${p}, c=${c}"
    else
      echo "chakra_visualizer failed to process p=${p}, c=${c}"
    fi
  done
done
