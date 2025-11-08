#!/bin/bash

cd /opt/
git clone --recurse-submodules https://github.com/deependhulla/ollama-for-riscv

cd /opt/ollama-for-riscv
go build .
ln -s /opt/ollama-for-riscv/ollama /usr/local/bin/ollama

/bin/cp /opt/ollama-for-riscv/ollama.service /etc/systemd/system/
systemctl daemon-reload

systemctl start ollama
## download smallest model
ollama pull smollm:135m
ollama pull granite4:350m

## Test it
ollama run smollm:135m

#ollama run granite4:350m

### orginal thanks -credit to https://github.com/mengzhuo/ollama
## https://www.jeffgeerling.com/blog/2025/how-build-ollama-run-llms-on-risc-v-linux
