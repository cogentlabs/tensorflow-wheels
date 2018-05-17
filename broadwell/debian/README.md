# TensorFlow Wheels

Collection of custom Tensorflow builds with extended instruction sets enabled.

## TensorFlow 1.2.1

### Build steps

- Clone Tensorflow
- Follow build from source instructions https://www.tensorflow.org/install/install_sources
- Build with `bazel build --config=opt --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" //tensorflow/tools/pip_package:build_pip_package`
- Create the wheel `bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg`

### Haswell

#### Ubuntu

* `tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl`: Compiled on Ubuntu 16.04 on GCP with Intel(R) Xeon(R) CPU @ 2.30GHz CPU using `-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma` for `python3.5`.

#### Debian

* `tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl`: Compiled on Debian Jessie on GCP with Intel(R) Xeon(R) CPU @ 2.30GHz CPU using `-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma` for `python3.5`.

### Broadwell

#### Ubuntu

* `tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl`: Compiled on Ubuntu 16.04 with an i7-6900K CPU using `-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma` for `python3.5`.

## TensorFlow 1.7.1 with Python 3.6

### Arch

- CPU: Broadwell
- OS: Debian, jessie
- Python: 3.6

### Commands from a fresh installation (for example on Google Cloud).

```
apt-get update
apt-get -y install git pkg-config zip g++ zlib1g-dev unzip

git clone https://github.com/tensorflow/tensorflow
cd tensorflow
git checkout r1.7


cd /tmp/
wget https://github.com/bazelbuild/bazel/releases/download/0.13.0/bazel-0.13.0-installer-linux-x86_64.sh
chmod +x bazel-0.13.0-installer-linux-x86_64.sh
./bazel-0.13.0-installer-linux-x86_64.sh --user

export PATH="$PATH:$HOME/bin"

# bazel should now be available

# https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-debian-8
# https://xmoexdev.com/wordpress/installing-openjdk-8-debian-jessie/
echo "deb http://http.debian.net/debian jessie-backports main" | sudo tee --append /etc/apt/sources.list.d/jessie-backports.list > /dev/null

apt-get install -t jessie-backports openjdk-8-jdk


# this step is kinda optional. It's if we want to install bazel.
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
apt-get update && apt-get -y install bazel

apt-get install python3-numpy python3-dev python3-pip python3-wheel

cd tensorflow
./configure

# https://stackoverflow.com/questions/41293077/how-to-compile-tensorflow-with-sse4-2-and-avx-instructions

bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 -k //tensorflow/tools/pip_package:build_pip_package

# could also use: -mavx -mavx2 -mfma -msse4.2

# http://www.andrewclegg.org/tech/TensorFlowLaptopCPU.html
```
