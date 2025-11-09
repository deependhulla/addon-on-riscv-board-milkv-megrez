#!/bin/bash

# Script: ollama-for-riscv.sh
# Purpose: Clones, builds, installs, and starts the Ollama service tailored for RISC-V
#          architectures, and downloads initial small LLMs for testing.
# Original thanks and credit to: 
# https://github.com/mengzhuo/ollama and 
# https://www.jeffgeerling.com/blog/2025/how-build-ollama-run-llms-on-risc-v-linux

## 1. Clone and Build Ollama for RISC-V
############################################################

echo "Starting Ollama setup for RISC-V..."

# Change to the /opt directory for cloning the repository
cd /opt/
# Clone the custom Ollama repository designed for RISC-V, including all necessary submodules
echo "Cloning ollama-for-riscv repository..."
git clone --recurse-submodules https://github.com/deependhulla/ollama-for-riscv
# Change into the cloned directory
cd /opt/ollama-for-riscv
# Build the Ollama binary using Go
echo "Building Ollama binary..."
go build .
## 2. Install and Configure Ollama Service
############################################################

# Create a symbolic link to the built binary so it can be executed from any location
echo "Installing Ollama binary to /usr/local/bin..."
ln -s /opt/ollama-for-riscv/ollama /usr/local/bin/ollama

# Copy the systemd service file to the appropriate location
echo "Copying systemd service file..."
/bin/cp /opt/ollama-for-riscv/ollama.service /etc/systemd/system/

# Reload the systemd manager configuration to recognize the new service file
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Start the Ollama service
echo "Starting Ollama service..."
systemctl start ollama

## 3. Download and Test Models
############################################################

# Wait a moment to ensure the Ollama service is fully running before pulling models
sleep 5

# Download the smallest available model (smollm:135m)
echo "Pulling smallest model: smollm:135m"
ollama pull smollm:135m

# Download the granite4:350m model
echo "Pulling granite4:350m model"
ollama pull granite4:350m

# Test the installation by running the smallest model interactively
echo "---------------------------------------------------------------------------"
echo "Ollama setup complete. Testing with 'smollm:135m'..."
echo "To exit the interactive session, type /bye."
echo "---------------------------------------------------------------------------"
ollama run smollm:135m

# The following command is commented out, but is available for running the larger model
# ollama run granite4:350m


### orginal thanks -credit to https://github.com/mengzhuo/ollama
## https://www.jeffgeerling.com/blog/2025/how-build-ollama-run-llms-on-risc-v-linux
