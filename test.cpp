#include <iostream>
#include <cstdlib>
#include <string>


// Retrieve environment variables or use default values
#define USE_FP16 (getenv("USE_FP16") ? atoi(getenv("USE_FP16")) : true)
#define DEVICE (getenv("DEVICE") ? atoi(getenv("DEVICE")) : 0)
#define NMS_THRESH (getenv("NMS_THRESH") ? atof(getenv("NMS_THRESH")) : 0.4)
#define CONF_THRESH (getenv("CONF_THRESH") ? atof(getenv("CONF_THRESH")) : 0.5)
#define BATCH_SIZE (getenv("BATCH_SIZE") ? atoi(getenv("BATCH_SIZE")) : 1)
#define MAX_IMAGE_INPUT_SIZE_THRESH (getenv("MAX_IMAGE_INPUT_SIZE_THRESH") ? atoi(getenv("MAX_IMAGE_INPUT_SIZE_THRESH")) : 3000 * 3000)

int INPUT_H = getenv("INPUT_H") ? atoi(getenv("INPUT_H")) : 640;
int INPUT_W = getenv("INPUT_W") ? atoi(getenv("INPUT_W")) : 640;
int CLASS_NUM = getenv("CLASS_NUM") ? atoi(getenv("CLASS_NUM")) : 80;

// Stuff we know about the network and the input/output blobs
static const int INPUT_H_CONST = INPUT_H;
static const int INPUT_W_CONST = INPUT_W;
static const int CLASS_NUM_CONST = CLASS_NUM;

const char* INPUT_BLOB_NAME = "data";
const char* OUTPUT_BLOB_NAME = "prob";

int main(int argc, char** argv) {
    std::cout << "USE_FP16: " << USE_FP16 << std::endl;
    std::cout << "DEVICE: " << DEVICE << std::endl;
    std::cout << "NMS_THRESH: " << NMS_THRESH << std::endl;
    std::cout << "CONF_THRESH: " << CONF_THRESH << std::endl;
    std::cout << "BATCH_SIZE: " << BATCH_SIZE << std::endl;
    std::cout << "MAX_IMAGE_INPUT_SIZE_THRESH: " << MAX_IMAGE_INPUT_SIZE_THRESH << std::endl;

    return 0;
}