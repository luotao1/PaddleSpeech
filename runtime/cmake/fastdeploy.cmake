cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(ARCH "mserver_x86_64" CACHE STRING "Target Architecture:
android_arm, android_armv7, android_armv8, android_x86, android_x86_64,
mserver_x86_64, ubuntu_x86_64, ios_armv7, ios_armv7s, ios_armv8, ios_x86_64, ios_x86,
windows_x86")

set(CMAKE_VERBOSE_MAKEFILE ON)

set(FASTDEPLOY_DIR ${CMAKE_SOURCE_DIR}/fc_patch/fastdeploy)
if(NOT EXISTS ${FASTDEPLOY_DIR}/fastdeploy-linux-x64-1.0.4.tgz)
    exec_program("mkdir -p ${FASTDEPLOY_DIR} &&
    wget https://bj.bcebos.com/fastdeploy/release/cpp/fastdeploy-linux-x64-1.0.4.tgz -P ${FASTDEPLOY_DIR} &&
    tar xzvf ${FASTDEPLOY_DIR}/fastdeploy-linux-x64-1.0.4.tgz -C ${FASTDEPLOY_DIR} &&
    mv ${FASTDEPLOY_DIR}/fastdeploy-linux-x64-1.0.4 ${FASTDEPLOY_DIR}/linux-x64")
endif()

if(NOT EXISTS ${FASTDEPLOY_DIR}/fastdeploy-android-1.0.0-shared.tgz)
    exec_program("mkdir -p ${FASTDEPLOY_DIR} &&
    wget https://bj.bcebos.com/fastdeploy/release/android/fastdeploy-android-1.0.0-shared.tgz -P ${FASTDEPLOY_DIR} &&
    tar xzvf ${FASTDEPLOY_DIR}/fastdeploy-android-1.0.0-shared.tgz -C ${FASTDEPLOY_DIR} &&
    mv ${FASTDEPLOY_DIR}/fastdeploy-android-1.0.0-shared ${FASTDEPLOY_DIR}/android-armv7v8")
endif()

if (ARCH STREQUAL "mserver_x86_64")
    set(FASTDEPLOY_INSTALL_DIR ${FASTDEPLOY_DIR}/linux-x64)
    add_definitions("-DUSE_PADDLE_INFERENCE_BACKEND")
    # add_definitions("-DUSE_ORT_BACKEND")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -msse -msse2")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -msse -msse2 -mavx -O3")
elseif (ARCH STREQUAL "android_armv7")
    set(FASTDEPLOY_INSTALL_DIR ${FASTDEPLOY_DIR}/android-armv7v8)
    add_definitions("-DUSE_PADDLE_LITE_BAKEND")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -mfloat-abi=softfp -mfpu=vfpv3 -mfpu=neon -fPIC -pie -fPIE")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g0 -O3 -mfloat-abi=softfp -mfpu=vfpv3 -mfpu=neon -fPIC -pie -fPIE")
endif()

include(${FASTDEPLOY_INSTALL_DIR}/FastDeploy.cmake)

# fix compiler flags conflict, since fastdeploy using c++11 for project
set(CMAKE_CXX_STANDARD 14)

include_directories(${FASTDEPLOY_INCS})
message(STATUS "FASTDEPLOY_INCS=${FASTDEPLOY_INCS}")