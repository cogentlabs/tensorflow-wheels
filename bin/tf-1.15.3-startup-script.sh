#!/bin/bash
# Startng with either Debian 8 Jessie or Ubuntu 16.04 Xenial image without Python3.6
# This script *may* work for other TF versions by tweaking the BAZEL_VERSION and 
# TENSORFLOW_RELEASE variables, but this was only tested on 1.10.0.

set -e

# These will dictate what we download later
export BAZEL_VERSION=0.26.1
export TENSORFLOW_RELEASE=v1.15.3

# Setting these allows us to automate the "configure" step in Tensorflow compilation
export PYTHON_BIN_PATH="/usr/local/bin/python3.6"
export PYTHON_LIB_PATH="/usr/local/lib/python3.6/site-packages"
export TF_NEED_JEMALLOC=1
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_NEED_AWS=0
export TF_NEED_S3=0
export TF_NEED_KAFKA=0
export TF_ENABLE_XLA=0
export TF_NEED_GDR=0
export TF_NEED_VERBS=0
export TF_NEED_OPENCL=0
export TF_NEED_CUDA=0
export TF_NEED_ROCM=0
export TF_DOWNLOAD_CLANG=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_MPI=0
export TF_SET_ANDROID_WORKSPACE=0
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

python3.6 -m pip install -U --user pip
export PATH=$PATH:~/.local/bin/

# Extra pip package dependencies...
# numpy has upper-bound or things break in compile, see:
# https://github.com/tensorflow/tensorflow/issues/41061
pip install -U --user six "numpy<1.19.0" wheel setuptools mock 'future>=0.17.1' 'gast==0.3.3' typing_extensions
pip install -U --user keras_applications==1.0.6 --no-deps
pip install -U --user keras_preprocessing==1.0.5 --no-deps

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