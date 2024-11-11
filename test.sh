#!/bin/bash

# Define your variables here
OUTPUT_BASE_PATH="$(pwd)/temp" # Replace <path> with your desired output base path
TASKS="fpsa"       # Replace <your-task-name> with the name of your task
SET="train"     # Replace <train | val | test> with the set type
NUM_FEWSHOT=1                  # Replace K with the desired number of few-shot examples
NUM_EXAMPLES=1                 # Replace N with the number of examples

# Run the command
python -m scripts.write_out \
    --output_base_path "$OUTPUT_BASE_PATH" \
    --tasks "$TASKS" \
    --sets "$SET" \
    --num_fewshot "$NUM_FEWSHOT" \
    --num_examples "$NUM_EXAMPLES"
