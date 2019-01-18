# TensorFlow Alpine

This was taken and modified from https://github.com/ml2grow/tensorflow-alpine and modified for Python 3.5

This is intended to build TensorFlow for use inside of a `python:3.*-alpine`-based Docker image. The Dockerfile will create an image which is usable as a base image with Tensorflow pre-installed, or you can simply run the resulting image and `docker cp` the Tensorflow wheel to your local machine.

**CURRENTLY THIS WILL _NOT_ BUILD WITH OPTIMIZED SSE INSTRUCTIONS**

```
docker build -t tf-alpine .
docker run --rm --name tf -it tf-alpine sh

# In a separate local shell (replacing version as needed)
docker cp tf:/tmp/tensorflow_pkg/tensorflow-1.7.0-cp35-cp35m-linux_x86_64.whl .
```