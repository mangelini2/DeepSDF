FROM nvcr.io/nvidia/pytorch:22.12-py3
LABEL authors="mangelini2"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
#RUN apt install -y libcli11-dev libnanoflann-dev git build-essential
RUN git clone https://github.com/Microsoft/vcpkg.git
RUN cd vcpkg
RUN apt-get install -y curl zip unzip tar
RUN vcpkg/bootstrap-vcpkg.sh
RUN vcpkg/vcpkg integrate install
#RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
#RUN apt-get install -y sudo
#RUN Pangolin/scripts/install_prerequisites.sh recommended
RUN apt-get install -y pkg-config nasm
RUN apt-get install -y libxmu-dev libxi-dev libgl-dev
RUN apt-get install -y libx11-dev libgles2-mesa-dev
RUN apt-get install -y libc++-dev libepoxy-dev libglew-dev libeigen3-dev cmake g++ ninja-build
RUN vcpkg/vcpkg install glew eigen3 vcpkg-tool-ninja
RUN apt-get install -y libgl1-mesa-dev libwayland-dev libxkbcommon-dev wayland-protocols libegl1-mesa-dev
RUN vcpkg/vcpkg update
RUN vcpkg/vcpkg install cli11 nanoflann
RUN apt install -y vim
WORKDIR /app/workspace
RUN git clone --recursive https://github.com/mangelini2/DeepSDF.git

WORKDIR /app/workspace/DeepSDF
RUN git checkout cli11
RUN git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    git checkout v0.6 &&\
    mkdir build &&\
    cd build &&\
    cmake .. && \
    cmake --build .
RUN mkdir build
WORKDIR /app

RUN pip install -U pip
RUN pip install plyfile
RUN pip install -U scikit-image
RUN pip install trimesh
RUN pip install mesh-to-sdf
RUN python3 -c "import skimage; print(skimage.__version__)"
#RUN ls
#
#WORKDIR /app/workspace/DeepSDF
#RUN cmake -S . -B ./build
#RUN cd build &&\
#    make -j

SHELL ["/bin/bash","-c"]