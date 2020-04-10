FROM nvcr.io/nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
ARG TENSORRT_VERSION=7.0.0.11

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        autoconf \
        automake \
        libtool \
        pkg-config \
        ca-certificates \
        wget \
        git \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        vim \
        libprotobuf-dev \
        protobuf-compiler \
        cmake \
        swig && \
    python3 -m pip install -U pip && \
    pip3 install -U \
        protobuf \
        onnx==1.5.0 \
        pytest==5.1.2 \
        torch \
        torchvision && \
        ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /opt/onnx-tensorrt
COPY . .


RUN dpkg -i nv-tensorrt-repo-ubuntu1804-cuda10.2-trt${TENSORRT_VERSION}-ga-20191216_1-1_amd64.deb && \
    apt-key add /var/nv-tensorrt-repo-cuda10.2-trt${TENSORRT_VERSION}-ga-20191216/7fa2af80.pub && \
    apt-get update && apt-get install -y --no-install-recommends \
        libnvinfer7 \
        libnvinfer-plugin7 \
        libnvparsers7 \
        libnvonnxparsers7 \
        libnvinfer-bin \
        libnvinfer-dev \
        libnvinfer-plugin-dev \
        libnvparsers-dev \
        libnvonnxparsers-dev \
        libnvinfer-samples \
        libnvinfer-doc \
        python3-libnvinfer \
        python3-libnvinfer-dev && \
    apt-get install -y \
        tensorrt && \
    rm nv-tensorrt-repo-ubuntu1804-cuda10.2-trt${TENSORRT_VERSION}-ga-20191216_1-1_amd64.deb && \
    pip3 install pycuda

RUN dpkg -l | grep TensorRT

RUN git clone --recurse-submodules https://github.com/onnx/onnx-tensorrt.git && \
    cd onnx-tensorrt && \
    git checkout 8716c9b32dcc947287f2ede9ef7d563601bb2ee0 && \
    mkdir -p build && \
    cd build && \
    cmake -DCUDA_INCLUDE_DIRS=/usr/local/cuda/include/ .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    cd .. && \
    python3 setup.py build && \
    python3 setup.py install && \
    cd .. && \
    rm -rf ./onnx-tensorrt/build/

RUN apt-get install -y protobuf-compiler ninja-build && \
    git clone https://github.com/NVIDIA-AI-IOT/torch2trt && \
    cd torch2trt && \
    python setup.py install --plugins

RUN ["/bin/bash"]
