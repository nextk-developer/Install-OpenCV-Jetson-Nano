#!/bin/bash
set -e
echo "Installing OpenCV 4.5.1 on your Jetson Nano"
echo "It will take 2 hours !"

# reveal the CUDA location
cd ~
sh -c "echo '/usr/local/cuda/lib64' >> /etc/ld.so.conf.d/nvidia-tegra.conf"
ldconfig

# install the dependencies
apt-get update
apt-get install -y build-essential cmake git unzip pkg-config
apt-get install -y libjpeg-dev libpng-dev libtiff-dev
apt-get install -y libgtk2.0-dev libcanberra-gtk*
apt-get install -y python3-dev python3-numpy python3-pip
apt-get install -y libxvidcore-dev libx264-dev libgtk-3-dev
apt-get install -y libtbb2 libtbb-dev libdc1394-22-dev
apt-get install -y gstreamer1.0-tools libv4l-dev v4l-utils
apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
apt-get install -y libavresample-dev libvorbis-dev libxine2-dev
apt-get install -y libfaac-dev libmp3lame-dev libtheora-dev
apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev
apt-get install -y libopenblas-dev libatlas-base-dev libblas-dev
apt-get install -y liblapack-dev libeigen3-dev gfortran
apt-get install -y libhdf5-dev protobuf-compiler
apt-get install -y libprotobuf-dev libgoogle-glog-dev libgflags-dev

# remove old versions or previous builds
cd ~ 
rm -rf opencv*
# download the latest version
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.1.zip 
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.1.zip 
# unpack
unzip opencv.zip 
unzip opencv_contrib.zip 
# some administration to make live easier later on
mv opencv-4.5.1 opencv
mv opencv_contrib-4.5.1 opencv_contrib
# clean up the zip files
rm opencv.zip
rm opencv_contrib.zip

# set install dir
cd ~/opencv
mkdir build
cd build

# run cmake
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr \
-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
-D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
-D WITH_OPENCL=OFF \
-D WITH_CUDA=OFF \
-D CUDA_ARCH_BIN=5.3 \
-D CUDA_ARCH_PTX="" \
-D WITH_CUDNN=OFF \
-D WITH_CUBLAS=OFF \
-D ENABLE_FAST_MATH=ON \
-D CUDA_FAST_MATH=ON \
-D OPENCV_DNN_CUDA=OFF \
-D ENABLE_NEON=ON \
-D WITH_QT=OFF \
-D WITH_OPENMP=ON \
-D BUILD_TIFF=ON \
-D WITH_FFMPEG=ON \
-D WITH_GSTREAMER=OFF \
-D WITH_TBB=ON \
-D BUILD_TBB=ON \
-D BUILD_TESTS=OFF \
-D WITH_EIGEN=ON \
-D WITH_V4L=OFF \
-D WITH_LIBV4L=OFF \
-D OPENCV_ENABLE_NONFREE=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D BUILD_NEW_PYTHON_SUPPORT=OFF \
-D BUILD_opencv_python3=FALSE \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D BUILD_EXAMPLES=OFF ..

# run make
make -j $(nproc)

make install
ldconfig

# cleaning (frees 300 MB)
make clean
apt-get update

cd ~ 
rm -rf opencv*

echo "Congratulations!"
echo "You've successfully installed OpenCV 4.5.1 on your Jetson Nano"

