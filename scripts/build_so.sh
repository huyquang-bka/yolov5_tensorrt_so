cd /yolov5_tensorrt_so

# script python
python3 config_script.py

# set CMakeLists_exe.txt to CMakeLists.txt
mv CMakeLists_so.txt CMakeLists.txt
# build executable
mkdir -p build
rm -rf build/*
cd build
cmake ../
make -j$(nproc)

# echo build status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build executable success${NC}"
else
    echo -e "${RED}Build executable failed${NC}"
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



