#!/bin/bash

# Define your variables here
OUTPUT_BASE_PATH="$(pwd)/temp" # Replace <path> with your desired output base path
TASKS="fpsa"       # Replace <your-task-name> with the name of your task
SET="train"     # Replace <train | val | test> with the set type
NUM_FEWSHOT=1                  # Replace K with the desired number of few-shot examples
NUM_EXAMPLES=1                 # Replace N with the number of examples

MODEL="hf"                      # Model type for eval task
MODEL_ARGS="pretrained=EleutherAI/gpt-j-6B"  # Pretrained model
DEVICE="cuda:0"                 # Default device
BATCH_SIZE=8                    # Default batch size

# Parse arguments
COMMAND=$1  # First argument should be either "data" or "eval"

if [ "$COMMAND" == "data" ]; then
    # Run the data task
    mkdir -p "$OUTPUT_BASE_PATH"  # Ensure output directory exists

    # Run the command
    python -m scripts.write_out \
        --output_base_path "$OUTPUT_BASE_PATH" \
        --tasks "$TASKS" \
        --sets "$SET" \
        --num_fewshot "$NUM_FEWSHOT" \
        --num_examples "$NUM_EXAMPLES"

elif [ "$COMMAND" == "eval" ]; then
    # Run the eval task
    lm_eval --model "$MODEL" \
            --model_args "$MODEL_ARGS" \
            --tasks "$TASKS" \
            --device "$DEVICE" \
            --batch_size "$BATCH_SIZE"

else
    echo "Invalid command. Use 'data' to run the data task or 'eval' to run the eval task."
fi

