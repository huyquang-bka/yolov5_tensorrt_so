#include <iostream>

#define USE_FP16  // set USE_INT8 or USE_FP16 or USE_FP32
#define DEVICE 0  // GPU id
#define NMS_THRESH 0.4
#define CONF_THRESH 0.5
#define BATCH_SIZE 1
#define MAX_IMAGE_INPUT_SIZE_THRESH 3000 * 3000 // ensure it exceed the maximum size in the input images !

static constexpr int LOCATIONS = 4;
struct alignas(float) Detection {
    //center_x center_y w h
    float bbox[LOCATIONS];
    float conf;  // bbox_conf * cls_conf
    float class_id;
};

// stuff we know about the network and the input/output blobs
static const int INPUT_H = 640;
static const int INPUT_W = 640;
static const int CLASS_NUM = 3;
static const int OUTPUT_SIZE = 1000 * sizeof(Detection) / sizeof(float) + 1;  // we assume the yololayer outputs no more than MAX_OUTPUT_BBOX_COUNT boxes that conf >= 0.1
const char* INPUT_BLOB_NAME = "data";
const char* OUTPUT_BLOB_NAME = "prob";

int main(int argc, char** argv) {
    std::cout << "INPUT_H: " << INPUT_H << std::endl;
    std::cout << "INPUT_W: " << INPUT_W << std::endl;
    std::cout << "CLASS_NUM: " << CLASS_NUM << std::endl;
    std::cout << "OUTPUT_SIZE: " << OUTPUT_SIZE << std::endl;
    std::cout << "INPUT_BLOB_NAME: " << INPUT_BLOB_NAME << std::endl;
    std::cout << "OUTPUT_BLOB_NAME: " << OUTPUT_BLOB_NAME << std::endl;
}