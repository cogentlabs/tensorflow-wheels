# tensorflow-wheels

Collection of custom Tensorflow builds with extended instruction sets enabled.

## Using startup scripts in GCE

There is a script `bin/tf-1.9.0-create-compute-instances-and-auto-build.sh` which will launch two new compute instances in `brew-staging` each with a generic startup script (`tf-1.9.0-startup-script.sh`) which will compile the Tensorflow 1.9.0 wheel automatically. Check the config in the top of that script for more details of the instance types etc.

This script will **NOT** clean up resources for you or download the wheel file to anywhere. You must monitor the progress of the compilation (~2 hours) and download the wheel file manually when you are done, and of course clean up the compute instances, disks, etc.

You can ssh into that new instance to check the status with something like `tail -f /var/log/syslog`, which is where the startup script logs go.


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

