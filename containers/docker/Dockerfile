FROM nvidia/cuda:11.4.2-runtime-ubuntu20.04 AS builder

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

LABEL maintainer="Filip Bjelonic" mail="filipb@leggedrobotics.com"

# To avoid tzdata asking for geographic location...
ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_frontend noninteractive

# Create folders for cloning
ENV WORKSPACE=/isaac_ws
RUN mkdir -p $WORKSPACE && mkdir -p $WORKSPACE/isaacgymenvs && mkdir -p $WORKSPACE/rsl_rl && mkdir -p $WORKSPACE/isaacgymenvs

ENV CXX=/usr/bin/g++
ENV CC=/usr/bin/gcc

# Install dependencies
RUN apt-get update --fix-missing && apt-get install -y apt-utils git wget vim openscad python3-dev python3-distutils python3-pip libpython3-dev
#MY ADDED DEPENDENCIES FROM REQUIREMENTS.TXT
RUN pip3 install gym==0.24.1 torch omegaconf termcolor hydra-core>=1.1 rl-games==1.5.2
pyvirtualdisplay

RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip3 install matplotlib tensorboard trimesh warp-lang trimesh pytest GitPython numpy==1.23.0 imageio ninja pillow pyyaml scipy

# Install IsaacGym
ADD isaacgym $WORKSPACE/isaacgym
RUN cd $WORKSPACE/isaacgym/python && pip install -e .

# Install rsl_rl
ADD rsl_rl $WORKSPACE/rsl_rl
RUN cd $WORKSPACE/rsl_rl && pip install -e .

# Install legged_gym
ADD isaacgymenvs $WORKSPACE/isaacgymenvs
RUN cd $WORKSPACE/isaacgymenvs && pip install -e .

# delete folders for mounting your changes on the cluster 
# (uncomment the next line if you have changes in rsl_rl that needs to be mounted on the cluster)
#RUN rm -r $WORKSPACE/rsl_rl/* && rm -rf rsl_rl/{,.[!.],..?}*  # deletes normal files && hidden files
RUN rm -r $WORKSPACE/isaacgymenvs/* && rm -rf isaacgymenvs/{,.[!.],..?}*  # deletes normal files && hidden files

RUN mkdir -p $WORKSPACE/isaacgymenvs/logs
