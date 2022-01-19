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
    pip install 'tensorflow-gpu==1.14'

RUN cd / && git clone https://github.com/Picooooo/rllab.git && \
    apt-get install -y wget && \
    wget -P . https://www.roboti.us/download/mjpro131_linux.zip && \
    unzip mjpro131_linux.zip && \
    mkdir /rllab/vendor/mujoco && \
    cp ./mjpro131/bin/libmujoco131.so /rllab/vendor/mujoco && \
    cp ./mjpro131/bin/libglfw.so.3 /rllab/vendor/mujoco && \
    wget https://www.roboti.us/file/mjkey.txt && \
    cp /mjkey.txt /rllab/vendor/mujoco && \
    wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz && \
    tar -xf mujoco210-linux-x86_64.tar.gz && \
    cp -r mujoco210/bin/* /usr/lib/ && \
    mkdir ~/.mujoco && \
    cp -r mujoco210 ~/.mujoco && \
    ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so && \
    apt install -y libosmesa6-dev libgl1-mesa-glx libglfw3 && \
    apt install -y patchelf && \
    apt-get install -y libglew-dev && \
    apt-get install -y cmake libopenmpi-dev python3-dev zlib1g-dev && \
    ln -s /usr/bin/python3 /usr/bin/python
   
COPY requirements.txt requirements.txt
RUN  pip install -r requirements.txt && \
     pip install -r https://raw.githubusercontent.com/Lasagne/Lasagne/v0.1/requirements.txt && \
     pip install --upgrade https://github.com/Theano/Theano/archive/master.zip 
    
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/mujoco210/bin:/root/.mujoco/mujoco210/bin:/rllab"
ENV PYTHONPATH="${PYTHONPATH}:/rllab:/src"

COPY . /src
WORKDIR /src

CMD /bin/bash
