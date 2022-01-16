FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04

RUN apt-get -y update && apt-get -y install ffmpeg && \
    apt-get install -y build-essential && \
    apt-get install -y vim git curl wget htop unzip && \
    apt-get install -y software-properties-common && \
    yes | add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.6 && \
    apt-get install -y python3-distutils && \
    apt-get install -y python3.6-dev && \
    (curl https://bootstrap.pypa.io/get-pip.py | python3.6) && \
    rm -rf __pycache__ && \
    pip install 'tensorflow-gpu==1.14' && \
    apt-get install -y wget && \
    wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz && \
    tar -xf mujoco210-linux-x86_64.tar.gz && \
    cp -r mujoco210/bin/* /usr/lib/ && \
    mkdir ~/.mujoco && \
    cp -r mujoco210 ~/.mujoco && \
#   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/content/mujoco210/bin:/root/.mujoco/mujoco210/bin && \
    ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so && \
    apt install -y libosmesa6-dev libgl1-mesa-glx libglfw3 && \
    apt install -y patchelf && \
    apt-get install -y libglew-dev && \
    apt-get install -y cmake libopenmpi-dev python3-dev zlib1g-dev && \
    cd / && git clone https://github.com/rll/rllab.git && \
    cd /rllab && git checkout b3a28992eca103cab3cb58363dd7a4bb07f250a0
    
    
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/mujoco210/bin:/root/.mujoco/mujoco210/bin:/rllab"
ENV PYTHONPATH="${PYTHONPATH}:/rllab:/src"

COPY . /src
WORKDIR /src

CMD /bin/bash
