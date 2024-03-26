import os

suffix = "python"
# all var
var_dict = {"USE_FP16": "false", "DEVICE": 0, "NMS_THRESH": 0.4, "CONF_THRESH": 0.5, "BATCH_SIZE": 1, "MAX_IMAGE_INPUT_SIZE_THRESH": 3000 * 3000, "INPUT_H": 640, "INPUT_W": 640, "CLASS_NUM": 80}
# Load environment variables
for var_name, default_value in var_dict.items():
    var_dict[var_name] = os.getenv(var_name, default_value)

with open("yolov5_base.cpp", "r") as f:
    content = f.read()
    
if content:
    for var_name, value in var_dict.items():
        # replace var_name_suffix with value
        content = content.replace(f"{var_name}_{suffix}", str(value))
    with open("yolov5_custom.cpp", "w") as f:
        f.write(content)
    
