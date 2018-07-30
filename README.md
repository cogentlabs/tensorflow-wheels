# tensorflow-wheels

Collection of custom Tensorflow builds with extended instruction sets enabled.

## Using startup scripts in GCE

The addition of Tensorflow 1.9.0 wheels comes with automated scripts for rebuilding the wheels in `${cpu}/${os}/bin/`. One script `tf-${version}-create-instance-auto-build.sh` will launch an instance in GCE with the correct machine settings, etc and provide the corresponding auto-build startup script to the instance. You can ssh into that new instance to check the status (`tail -f /var/log/syslog` on Debian) and download the wheel file when it is complete.

## Build steps

- Clone Tensorflow
- Follow build from source instructions https://www.tensorflow.org/install/install_sources
- Build with `bazel build --config=opt --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" //tensorflow/tools/pip_package:build_pip_package`
- Create the wheel `bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg`

## Haswell

### Ubuntu

* `tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl`: Compiled on Ubuntu 16.04 on GCP with Intel(R) Xeon(R) CPU @ 2.30GHz CPU using `-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma` for `python3.5`.

### Debian

* `tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl`: Compiled on Debian Jessie on GCP with Intel(R) Xeon(R) CPU @ 2.30GHz CPU using `-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma` for `python3.5`.

## Broadwell

### Ubuntu

* `tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl`: Compiled on Ubuntu 16.04 with an i7-6900K CPU using `-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma` for `python3.5`.

