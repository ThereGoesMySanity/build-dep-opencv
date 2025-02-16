#!/bin/bash
set -euo pipefail

CONFIG="${1?}"
VERSION="${2?}"

cmake opencv -B build_$1 \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DCMAKE_BUILD_TYPE=$1 \
  -DBUILD_TYPE=$1 \
  -DOPENCV_FORCE_3RDPARTY_BUILD=ON \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=15.0 \
  -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_opencv_apps=OFF \
  -DBUILD_opencv_js=OFF \
  -DBUILD_ANDROID_PROJECTS=OFF \
  -DBUILD_ANDROID_EXAMPLES=OFF \
  -DBUILD_DOCS=OFF \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_PACKAGE=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DBUILD_TESTS=OFF \
  -DBUILD_WITH_DEBUG_INFO=OFF \
  -DBUILD_WITH_STATIC_CRT=OFF \
  -DBUILD_WITH_DYNAMIC_IPP=OFF \
  -DBUILD_FAT_JAVA_LIB=OFF \
  -DBUILD_ANDROID_SERVICE=OFF \
  -DBUILD_CUDA_STUBS=OFF \
  -DBUILD_JAVA=OFF \
  -DBUILD_OBJC=OFF \
  -DBUILD_opencv_python3=OFF \
  -DINSTALL_CREATE_DISTRIB=OFF \
  -DINSTALL_BIN_EXAMPLES=OFF \
  -DINSTALL_C_EXAMPLES=OFF \
  -DINSTALL_PYTHON_EXAMPLES=OFF \
  -DINSTALL_ANDROID_EXAMPLES=OFF \
  -DINSTALL_TO_MANGLED_PATHS=OFF \
  -DINSTALL_TESTS=OFF \
  -DBUILD_opencv_calib3d=OFF \
  -DBUILD_opencv_core=ON \
  -DBUILD_opencv_dnn=OFF \
  -DBUILD_opencv_features2d=OFF \
  -DBUILD_opencv_flann=OFF \
  -DBUILD_opencv_gapi=OFF \
  -DBUILD_opencv_highgui=OFF \
  -DBUILD_opencv_imgcodecs=ON \
  -DBUILD_opencv_imgproc=ON \
  -DBUILD_opencv_ml=OFF \
  -DBUILD_opencv_objdetect=OFF \
  -DBUILD_opencv_photo=ON \
  -DBUILD_opencv_stitching=OFF \
  -DBUILD_opencv_video=OFF \
  -DBUILD_opencv_videoio=OFF \
  -DWITH_PNG=ON \
  -DWITH_AVIF=OFF \
  -DWITH_JPEG=OFF \
  -DWITH_TIFF=OFF \
  -DWITH_WEBP=OFF \
  -DWITH_OPENJPEG=OFF \
  -DWITH_JASPER=OFF \
  -DWITH_OPENEXR=OFF \
  -DWITH_FFMPEG=OFF \
  -DWITH_GSTREAMER=OFF \
  -DWITH_1394=OFF \
  -DWITH_PROTOBUF=OFF \
  -DBUILD_PROTOBUF=OFF \
  -DWITH_CAROTENE=OFF \
  -DWITH_EIGEN=OFF \
  -DWITH_OPENVX=OFF \
  -DWITH_CLP=OFF \
  -DWITH_DIRECTX=OFF \
  -DWITH_VA=OFF \
  -DWITH_LAPACK=OFF \
  -DWITH_QUIRC=OFF \
  -DWITH_ADE=OFF \
  -DWITH_ITT=OFF \
  -DWITH_OPENCL=OFF \
  -DWITH_IPP=OFF

cmake --build "build_$CONFIG"
cmake --install "build_$CONFIG" --prefix "release/$CONFIG"

cmake opencv/3rdparty/libpng -B build_libpng_arm -DCMAKE_OSX_ARCHITECTURES="arm64"
cmake --build build_libpng_arm
lipo -create build_libpng_arm/liblibpng.a release/$CONFIG/lib/opencv4/3rdparty/liblibpng.a -output ./liblibpng.a
mv ./liblibpng.a release/$CONFIG/lib/opencv4/3rdparty/liblibpng.a
lipo -info release/$CONFIG/lib/opencv4/3rdparty/liblibpng.a

tar -C "release/$CONFIG" -cvf "release/opencv-macos-$VERSION-$CONFIG.tar.gz" .

