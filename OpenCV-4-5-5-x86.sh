######################################
# INSTALL OPENCV ON UBUNTU OR DEBIAN #
######################################

# -------------------------------------------------------------------- |
#                       SCRIPT OPTIONS                                 |
# ---------------------------------------------------------------------|
OPENCV_VERSION='4.5.5'       # Version to be installed
OPENCV_CONTRIB='YES'          # Install OpenCV's extra modules (YES/NO)
# -------------------------------------------------------------------- |


# 1. KEEP UBUNTU OR DEBIAN UP TO DATE

apt-get -y update
# sudo apt-get -y upgrade       # Uncomment to install new versions of packages currently installed
# sudo apt-get -y dist-upgrade  # Uncomment to handle changing dependencies with new vers. of pack.
# sudo apt-get -y autoremove    # Uncomment to remove packages that are now no longer needed


# 2. INSTALL THE DEPENDENCIES

# Media I/O:
apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev \
                      libopenexr-dev libgdal-dev

# Video I/O:
apt-get install -y libdc1394-22-dev \
                   libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
                   libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

# Parallelism and linear algebra libraries:
apt-get install -y libtbb-dev libeigen3-dev

# Python:
apt-get install -y python-dev  python-tk  pylint  python-numpy  \
                   python3-dev python3-tk pylint3 python3-numpy flake8

# Documentation and other:
apt-get install -y doxygen


# 3. INSTALL THE LIBRARY
# remove old versions or previous builds
cd ~ 
rm -rf opencv*
# download version 4.5.0
wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip 
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip 
# unpack
unzip opencv.zip 
unzip opencv_contrib.zip 
# some administration to make live easier later on
mv opencv-${OPENCV_VERSION} opencv
mv opencv_contrib-${OPENCV_VERSION} opencv_contrib
# clean up the zip files
rm opencv.zip
rm opencv_contrib.zip

# set install dir
cd ~/opencv
mkdir build
cd build

if [ $OPENCV_CONTRIB = 'NO' ]; then
cmake -DCMAKE_BUILD_TYPE=RELEASE -DWITH_QT=OFF -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON \
      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF \
	  -DBUILD_EXAMPLES=OFF ..
fi

if [ $OPENCV_CONTRIB = 'YES' ]; then
cmake -DCMAKE_BUILD_TYPE=RELEASE -DWITH_QT=OFF -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON \
      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF \
      -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	  -DBUILD_EXAMPLES=OFF ..
fi

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