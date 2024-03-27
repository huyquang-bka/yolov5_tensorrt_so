export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/TensorRT-8.6.1.6/lib
cd /
# set variable
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color
# echo all env vars
echo "Model: $MODEL"
echo "CLASS_NUM: $CLASS_NUM"
echo "INPUT_W: $INPUT_W"
echo "INPUT_H: $INPUT_H"

# echo model file in /weights
echo "Weights file in /weights: "
ls /weights
# if model in /weights not found or model is empty, exit all process, else echo success
if [ ! -f /weights/$MODEL ]; then
    echo -e "${RED}Model not found, exit${NC}"
    exit 1
else
    echo -e "${GREEN}Model found!${NC}"
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

# build wts file
cd /
# clone yolov5_tensorrt_so repo
git clone https://github.com/huyquang-bka/yolov5_tensorrt_so.git
# clone yolov5 repo
git clone https://github.com/ultralytics/yolov5.git

# copy gen_wts.py from yolov5_tensorrt_so to yolov5
cp /yolov5_tensorrt_so/gen_wts.py yolov5/

# get filename by $MODEL without extension
weights_file=$(echo $MODEL | grep -oP '.*(?=\.pt)')
echo "Weights file: $weights_file"
# cd to yolov5 and generate wts file from weights file
cd /yolov5
python3 gen_wts.py -w /weights/$weights_file.pt -o /weights/$weights_file.wts
# echo wts file in folder /weights
echo "Wts file in /weights: "
ls /weights

# if not .wts file found, exit all process
if [ "$(ls -A /weights | grep -oP '.*(?=\.wts)')" ]; then
    echo "Wts ready in /weights"
else
    echo "No wts file found in /weights"
    exit 1
fi

# build executable
cd /yolov5_tensorrt_so

# script python
python3 config_script.py

# set CMakeLists_exe.txt to CMakeLists.txt
mv CMakeLists_exe.txt CMakeLists.txt
# build executable
mkdir -p build
rm -rf build/*
cd build
# build with cmake in silent mode
cmake ../ > /dev/null 2>&1
# make with nproc in silent mode
make -j$(nproc) > /dev/null 2>&1

# echo build status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build executable success${NC}"
else
    echo -e "${RED}Build executable failed${NC}"
    exit 1
fi

# export engine
cd /yolov5_tensorrt_so/build/
# echo LD_LIBRARY_PATH
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
# set type = "s" if not defined else use the value of type
TYPE=${TYPE:-"s"}
# if type not equal "n" or "s" or "m" or "l" or "x", use "s"
if [ "$type" != "n" ] && [ "$type" != "s" ] && [ "$type" != "m" ] && [ "$type" != "l" ] && [ "$type" != "x" ]; then
    TYPE="s"
fi
# echo type
echo -e "${GREEN}Export with type: $TYPE, GPU_NAME: $GPU_NAME${NC}"
weights_file=$(echo $MODEL | grep -oP '.*(?=\.pt)')
# set engine name = $weights_file_$GPU_NAME
engine_name=$weights_file"_"$GPU_NAME
# export engine
echo "Command: ./yolov5 -s /weights/$weights_file.wts /weights/$engine_name.engine $TYPE"
./yolov5 -s /weights/$weights_file.wts /weights/$engine_name.engine $TYPE
# echo build status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Export engine success${NC}"
else
    echo -e "${RED}Export engine failed${NC}"
fi
# echo engine file in folder /weights
echo "Engine file in /weights: "
ls /weights
# if not .engine file found, exit all process
if [ "$(ls -A /weights | grep -oP '.*(?=\.engine)')" ]; then
    echo -e "${GREEN}Engine ready in /weights${NC}"
else
    echo -e "${RED}No engine file found in /weights${NC}"
    exit 1
fi

# build so
cd /yolov5_tensorrt_so

# script python
python3 config_script.py

# set CMakeLists_exe.txt to CMakeLists.txt
mv CMakeLists_so.txt CMakeLists.txt
# build executable
mkdir -p build
rm -rf build/*
cd build
# build with cmake in silent mode
cmake ../ > /dev/null 2>&1
# make with nproc in silent mode
make -j$(nproc) > /dev/null 2>&1

# echo build status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build so success${NC}"
else
    echo -e "${RED}Build so failed${NC}"
    exit 1
fi

# mv libyolov5.so to /weights
mv libyolov5.so /weights
# echo libyolov5.so in /weights
echo "libyolov5.so in /weights: "
ls /weights
# if not .so file found, exit all process
if [ "$(ls -A /weights | grep -oP '.*(?=\.so)')" ]; then
    echo "libyolov5.so ready in /weights"
else
    echo "No libyolov5.so file found in /weights"
    exit 1
fi

# upload to neptune
pip3 install neptune-client
# run python script to upload to neptune
python3 /upload_neptune.py