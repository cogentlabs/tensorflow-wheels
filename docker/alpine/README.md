# TensorFlow Alpine

This was taken and modified from https://github.com/ml2grow/tensorflow-alpine and modified for Python 3.5... Then modified again later for 3.6...

This is intended to build TensorFlow for use inside of a `python:3.*-alpine`-based Docker image. The Dockerfile will create an image which is usable as a base image with Tensorflow pre-installed, or you can simply run the resulting image and `docker cp` the Tensorflow wheel to your local machine.

**THIS WILL USE THE OPTIMIZED CPU INSTRUCTION SETS** - if you need to disable those, you're gonna have to edit the Dockerfile like this:

```diff
-        CC_OPT_FLAGS="-march=native -msse4.1 -msse4.2 -mavx -mavx2 -mfma" \
+        CC_OPT_FLAGS="-march=native" \
```

## Build and extract

e.g. Python 3.6:
```
docker build -f Dockerfile.py36tf17 -t tf-alpine-wheel-builder:py36tf17 .
docker run --rm --name tf -it tf-alpine-wheel-builder:py36tf17 sh

# In a separate local shell (replacing version as needed)
docker cp tf:/tensorflow_pkg/tensorflow-1.7.0-cp36-cp36m-linux_x86_64.whl .
```