from ctypes import *
import cv2
import numpy as np
import numpy.ctypeslib as npct
import time

class Detector():
    def __init__(self,model_path,dll_path):
        self.yolov5 = CDLL(dll_path)
        self.yolov5.Detect.argtypes = [c_void_p,c_int,c_int,c_float,c_float,POINTER(c_ubyte),npct.ndpointer(dtype = np.float32, ndim = 2, shape = (50, 6), flags="C_CONTIGUOUS")]
        self.yolov5.Init.restype = c_void_p
        self.yolov5.Init.argtypes = [c_void_p]
        self.yolov5.cuda_free.argtypes = [c_void_p]
        self.c_point = self.yolov5.Init(model_path)

    def predict(self,img):
        rows, cols = img.shape[0], img.shape[1]
        res_arr = np.zeros((50,6),dtype=np.float32)
        self.yolov5.Detect(self.c_point,c_int(rows), c_int(cols),c_float(0.5),c_float(0.4), img.ctypes.data_as(POINTER(c_ubyte)),res_arr)
        self.bbox_array = res_arr[~(res_arr==0).all(1)]
        return self.bbox_array

    def free(self):
        self.yolov5.cuda_free(self.c_point)

def visualize(img,bbox_array):
    for temp in bbox_array:
        x1,y1,x2,y2 = [temp[0],temp[1],temp[2],temp[3]]  #xywh
        clas = int(temp[4])
        score = temp[5]
        img = cv2.rectangle(img, (int(x1),int(y1)), (int(x2),int(y2)), (105, 237, 249), 1)
        img = cv2.putText(img, "class:"+str(clas)+" "+str(round(score,2)), (int(temp[0]),int(temp[1])-5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (105, 237, 249), 1)
    return img

det = Detector(model_path=b"/home/a100/Yolov5_Tensorrt_Win10/build_1/yolov5.engine",dll_path="/home/a100/Yolov5_Tensorrt_Win10/build/libyolov5.so")  # b'' is needed
img = cv2.imread("/home/a100/Yolov5_Tensorrt_Win10/pictures/bus.jpg")
for i in range(1000):
    pre_time = time.time()
    result = det.predict(img)
    print("time:",(time.time()-pre_time)*1000,"ms")
img = visualize(img,result)
cv2.imwrite("result.jpg",img)
# cv2.imshow("img",img)
# cv2.waitKey(0)
det.free()
# cv2.destroyAllWindows()