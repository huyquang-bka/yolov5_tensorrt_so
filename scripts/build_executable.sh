cd /yolov5_tensorrt_so

# script python
python3 config_script.py

# set CMakeLists_exe.txt to CMakeLists.txt
mv CMakeLists_exe.txt CMakeLists.txt
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
