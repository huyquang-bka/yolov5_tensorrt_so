docker run -it -d --gpus all --net=host --name tensorrt-opencv -v folder_path/weight.pt:/weights/weight.pt -e CLASS_NUM=2 -e INPUT_H=640 -e INPUT_W=640 -e TYPE="s"  huyquang/tensorrt-opencv-ultralytics