FROM huyquang/tensorrt-opencv-ultralytics:latest

# copy scripts folder
COPY scripts /scripts

# chmod +x for all scripts
RUN chmod +x /scripts/*.sh

# run the script
CMD ["./scripts/combined.sh"]




