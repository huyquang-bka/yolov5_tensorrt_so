cd /
# set variable
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color
# echo all env vars
echo "CLASS_NUM: $CLASS_NUM"
echo "INPUT_W: $INPUT_W"
echo "INPUT_H: $INPUT_H"

# echo file in folder /weights, if empty, exit all process
echo "Weights file in /weights: "
ls /weights
if [ "$(ls -A /weights)" ]; then
    echo -e "${GREEN}Weights ready in /weights${NC}"
else
    echo -e "${RED}No weights file found in /weights, exit${NC}"
    exit 1
fi

# echo gpus info 
gpu_name=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | head -n 1)
# if gpu_name is empty, exit all process
if [ -z "$gpu_name" ]; then
    echo -e "${RED}No GPU found, exit${NC}"
    exit 1
fi
#replace space with underscore
gpu_name=${gpu_name// /_}
export GPU_NAME=$gpu_name
echo -e "${GREEN}GPU_NAME: $GPU_NAME${NC}"
