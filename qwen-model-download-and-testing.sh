#!/bin/bash

source /opt/venv/bin/activate

pip3 install modelscope


mkdir /opt/eswin/sample-code/npu_sample/qwen_sample/models
cd /opt/eswin/sample-code/npu_sample/qwen_sample/models
mkdir Qwen2 && cd Qwen2
modelscope download --model ZIFENG278/Qwen2-0.5B_ENNP --local_dir ./
## move as different folder
mv qwen2_0_5b_int8 ../qwen2_0_5b_1k_int8

## to Test CLI Tool for Qwen model for chat 

/opt/eswin/sample-code/npu_sample/qwen_sample/bin/es_qwen2 /opt/eswin/sample-code/npu_sample/qwen_sample/src/qwen2_0_5b_1k_int8/config.json 

