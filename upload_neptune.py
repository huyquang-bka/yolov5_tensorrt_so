import neptune
import os

# get the model name from the environment variable without extension
fn = os.environ["MODEL"]
fn = os.path.splitext(fn)[0]

gpu_name = os.environ["GPU_NAME"]

pt_path = f"/weights/{fn}.pt"
engine_path = f"/weights/{fn}_{gpu_name}.engine"
so_path = f"/weights/libyolov5.so"

neptune_model = os.environ["NEPTUNE_MODEL"]

model_version = neptune.init_model_version(
    model=neptune_model,
    project="huyquang-bka/ATIN",
    api_token="eyJhcGlfYWRkcmVzcyI6Imh0dHBzOi8vYXBwLm5lcHR1bmUuYWkiLCJhcGlfdXJsIjoiaHR0cHM6Ly9hcHAubmVwdHVuZS5haSIsImFwaV9rZXkiOiI5OWQyM2Y2MS0yMGQxLTRiNzYtOTBiYy1kMmUxOTZiYmEzN2MifQ==", # your credentials
)

model_version["model/pt"].upload(pt_path)
model_version["model/engine"].upload(engine_path)
model_version["lib/so"].upload(so_path)
model_version["sys/tags"].add([fn, gpu_name])