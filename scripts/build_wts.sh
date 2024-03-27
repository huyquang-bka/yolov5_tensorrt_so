cd /
# clone yolov5_tensorrt_so repo
git clone https://github.com/huyquang-bka/yolov5_tensorrt_so.git
# clone yolov5 repo
git clone https://github.com/ultralytics/yolov5.git

# copy gen_wts.py from yolov5_tensorrt_so to yolov5
cp yolov5_tensorrt_so/gen_wts.py yolov5/

# get filename in folder /weights without extension
weights_file=$(ls /weights | grep -oP '.*(?=\.pt)')
echo "Weights file: $weights_file"
# cd to yolov5 and generate wts file from weights file
cd yolov5
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