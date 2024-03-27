import os

suffix = "REPLACE"
# all var
var_dict = {"CLASS_NUM": 80, "INPUT_H": 640, "INPUT_W": 640}
# Load environment variables
for var_name, default_value in var_dict.items():
    var_dict[var_name] = os.getenv(var_name, default_value)

with open("yololayer_base.h", "r") as f:
    content = f.read()
    
if content:
    for var_name, value in var_dict.items():
        # replace var_name_suffix with value
        content = content.replace(f"{var_name}_{suffix}", str(value))
    with open("yololayer.h", "w") as f:
        f.write(content)
    
