#!/bin/bash

# Define your variables here
OUTPUT_BASE_PATH="$(pwd)/temp" # Replace <path> with your desired output base path
TASKS="fpsa"       # Replace <your-task-name> with the name of your task
SET="train"     # Replace <train | val | test> with the set type
NUM_FEWSHOT=1                  # Replace K with the desired number of few-shot examples
NUM_EXAMPLES=1                 # Replace N with the number of examples

MODEL="hf" 

                     # Model type for eval task
MODEL_ARGS="pretrained=meta-llama/Llama-3.1-8B"  # Pretrained model
DEVICE="cuda:0"                 # Default device
BATCH_SIZE=8                    # Default batch size

huggingface-cli login # use this if using a gated model

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

    # if -p True is passed then set parrel to true
    if [ "$2" == "-p" ]; then
        PARALLEL=True
    else
        PARALLEL=False
    fi

    # Run the eval task
    lm_eval --model "$MODEL" \
            --model_args "$MODEL_ARGS,parallelize=$PARALLEL" \
            --tasks "$TASKS" \
            --device "$DEVICE" \
            --batch_size "$BATCH_SIZE" \
            --trust_remote_code \
            --output_path "$OUTPUT_BASE_PATH" \
            
elif [ "$COMMAND" == "wandb_eval" ]; then
    pip install lm_eval[wandb]
    lm_eval --model "$MODEL" \
            --model_args "$MODEL_ARGS",  \
            --tasks "$TASKS" \
            --device "$DEVICE" \
            --batch_size "$BATCH_SIZE" \
            --trust_remote_code \
            --output_path "$OUTPUT_BASE_PATH" \
            --wandb_args project="llama-base-eval" \

elif [ "$COMMAND" == "test_eval" ]; then

    # check if there is a second argument that is an int and if there is set the lmit to that
    if [ "$2" -eq "$2" ] 2>/dev/null; then
        LIMIT="$2"
    else
        LIMIT=3
    fi

    lm_eval --model "$MODEL" \
            --model_args "$MODEL_ARGS" \
            --tasks "$TASKS" \
            --device "$DEVICE" \
            --trust_remote_code \
            --log_samples \
            --output_path "$OUTPUT_BASE_PATH" \
            --limit "$LIMIT" 



elif [ "$COMMAND" == "env" ]; then
    
    python3 -m venv venv
    source venv/bin/activate
    pip install -e .

else
    echo "Invalid command. Use 'data' to run the data task or 'eval' to run the eval task."
fi

