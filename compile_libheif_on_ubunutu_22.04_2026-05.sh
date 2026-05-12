#!/usr/bin/env bash

# Probably best to run line-by-line yourself

sudo apt update
#sudo apt install x265 #not enough, needs dev packages
sudo apt install libx265-dev
sudo apt install libx264-dev
sudo apt install libopenh264-dev
sudo apt install libaom-dev
sudo apt-get install cmake pkg-config libopenjp2-7-dev
#ffmpeg dev
sudo apt install libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavdevice-dev libavfilter-dev libswresample-dev libpostproc-dev

sudo apt install libsharpyuv-dev
# if the previous line fails (older Ubuntu versions):
sudo apt install libwebp-dev



cd ~/tobackup/install/

git clone https://github.com/fraunhoferhhi/vvdec
git clone https://github.com/fraunhoferhhi/vvenc
git clone https://github.com/strukturag/libde265
git clone https://github.com/strukturag/libheif

cd ~/software/
cp -a ~/tobackup/install/vvdec/ .
cp -a ~/tobackup/install/vvenc/ .
cp -a ~/tobackup/install/libde265/ .
cp -a ~/tobackup/install/libheif/ .

cd vvdec
rm -rf build
#emacs README.md:
mkdir build
cd build
cmake ..
make
ls
# from me:
sudo make install
cd ../..


cd vvenc
rm -rf build
#emacs README.md:
mkdir build
cd build
cmake ..
make
ls
# from me:
sudo make install
cd ../..


cd libde265
rm -rf build
#emacs README.md:
mkdir build
cd build
cmake ..
make
ls
# from me:
sudo make install
cd ../..

cd libheif

rm -rf build
#emacs README.md:
mkdir build
cd build
#cmake -D WITH_JPEG_ENCODER=ON -D WITH_JPEG_DECODER=ON ..
cmake -D WITH_JPEG_ENCODER=ON -D WITH_JPEG_DECODER=ON -D WITH_OpenJPEG_ENCODER=ON -D WITH_OpenJPEG_DECODER=ON -D WITH_VVENC=ON -D WITH_VVDEC=ON -D WITH_UNCOMPRESSED_CODEC==ON -D CMAKE_BUILD_TYPE=Release  ..
make

