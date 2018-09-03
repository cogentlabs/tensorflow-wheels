#!/bin/bash
# Startng with either Debian 8 Jessie or Ubuntu 16.04 Xenial image without Python3.6
# This script *may* work for other TF versions by tweaking the BAZEL_VERSION and 
# TENSORFLOW_RELEASE variables, but this was only tested on 1.10.0.

set -e

# These will dictate what we download later
export BAZEL_VERSION=0.15.2
export TENSORFLOW_RELEASE=v1.10.1

# Setting these allows us to automate the "configure" step in Tensorflow compilation
export PYTHON_BIN_PATH="/usr/local/bin/python3.6"
export PYTHON_LIB_PATH="/usr/local/lib/python3.6/site-packages"
export TF_NEED_JEMALLOC="yes"
export TF_NEED_GCP="no"
export TF_NEED_HDFS="no"
export TF_NEED_AWS="no"
export TF_NEED_S3="no"
export TF_NEED_KAFKA="no"
export TF_ENABLE_XLA="no"
export TF_NEED_GDR="no"
export TF_NEED_VERBS="no"
export TF_NEED_OPENCL="no"
export TF_NEED_CUDA="no"
export TF_DOWNLOAD_CLANG="no"
export TF_NEED_OPENCL_SYCL="no"
export TF_NEED_MPI="no"
export TF_SET_ANDROID_WORKSPACE="no"
export CC_OPT_FLAGS="-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma"

# Dependencies
sudo apt-get update
sudo apt-get install -y \
    make build-essential libssl-dev zlib1g-dev \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm unzip git

WORKDIR=$(pwd)

## Python3.6
## This could be installed on Ubuntu with alternative repos, but the same approach was not
## working in Debian. Compiling from source allows us to use this same script for both OSs.
cd $WORKDIR
wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz
tar xvzf Python-3.6.3.tgz
cd Python-3.6.3
./configure --enable-optimizations --with-ensurepip=install
sudo make altinstall
sudo pip3.6 install numpy wheel

# Bazel
cd $WORKDIR
wget --quiet https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
chmod +x bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
sudo ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh

## Tensorflow
cd $WORKDIR
git clone -b $TENSORFLOW_RELEASE https://github.com/tensorflow/tensorflow
cd tensorflow
./configure
bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package $WORKDIR/tensorflow_pkg
