./scripts/echo.sh 
./scripts/build_wts.sh
./scripts/build_executable.sh
./scripts/export_engine.sh
./scripts/build_so.sh

# echo "Build success"
echo -e "${GREEN}Build success!${NC}"
echo -e "Info: \nCLASS_NUM: $CLASS_NUM\nINPUT_W: $INPUT_W\nINPUT_H: $INPUT_H\nGPU_NAME: $GPU_NAME"