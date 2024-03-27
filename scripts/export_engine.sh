cd /yolov5_tensorrt_so/build
# set type = "s" if not defined else use the value of type
TYPE=${TYPE:-"s"}
# if type not equal "n" or "s" or "m" or "l" or "x", use "s"
if [ "$type" != "n" ] && [ "$type" != "s" ] && [ "$type" != "m" ] && [ "$type" != "l" ] && [ "$type" != "x" ]; then
    TYPE="s"
fi
# echo type
echo -e "${GREEN}Export with type: $TYPE, GPU_NAME: $GPU_NAME${NC}"
# export engine
./yolov5 -s /weights/$weights_file.wts /weights/$weights_file_$GPU_NAME.engine $TYPE
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