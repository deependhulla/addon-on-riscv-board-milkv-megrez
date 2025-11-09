#!/bin/bash

# Script: qwen-model-download-and-testing.sh
# Purpose: Activates the Python virtual environment, installs the ModelScope library,
#          downloads the optimized Qwen2-0.5B model for the Eswin NPU, and prepares
#          for CLI-based testing.

## 1. Environment Setup
############################################################

echo "Activating Python Virtual Environment..."
# Activate the virtual environment created in the first setup script.
# This ensures packages are installed locally without polluting the global system environment.
source /opt/venv/bin/activate

echo "Installing modelscope library..."
# Install the ModelScope library, which is used to download models from the ModelScope platform.
pip3 install modelscope

# Create the directory structure where the NPU sample code expects the models to reside.
mkdir /opt/eswin/sample-code/npu_sample/qwen_sample/models

# Navigate into the newly created models directory.
cd /opt/eswin/sample-code/npu_sample/qwen_sample/models

# Create a dedicated directory for the Qwen2 model and enter it.
mkdir Qwen2 && cd Qwen2

# Download the Qwen2-0.5B model specifically optimized for the Eswin NPU (ENNP).
# The '--local_dir ./' flag ensures the files are saved in the current directory.
modelscope download --model ZIFENG278/Qwen2-0.5B_ENNP --local_dir ./

# Move and rename the downloaded model directory to a standardized path
# that is expected by the Eswin sample application binaries.
# This step ensures the model configuration file can be found correctly.
mv qwen2_0_5b_int8 ../qwen2_0_5b_1k_int8

## 3. Qwen Model Testing via CLI
############################################################

# Execute the command-line interface (CLI) tool for the Qwen model.
# This typically loads the model onto the NPU using the specified configuration file
# and launches an interactive chat session for testing.

/opt/eswin/sample-code/npu_sample/qwen_sample/bin/es_qwen2 /opt/eswin/sample-code/npu_sample/qwen_sample/src/qwen2_0_5b_1k_int8/config.json 


