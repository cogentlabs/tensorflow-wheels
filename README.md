# tensorflow-wheels

Collection of custom Tensorflow builds with extended instruction sets enabled.

## Using startup scripts in GCE

There is a script `bin/create-compute-instances-and-auto-build.sh` which will launch two new compute instances in `algebraic-cycle-111108` ("Sandbox") project each with a generic startup script determined by the specified Tensorflow version. The startup-script will compile a Tensorflow wheel automatically. Check the config in the top of that script for more details of the instance types etc.

This script will **NOT** clean up resources for you or download the wheel file to anywhere. You must monitor the progress of the compilation (~2 hours) and download the wheel file manually when you are done, and of course clean up the compute instances, disks, etc.

There will be instructions printed by the creation script which will tell you how to log into the instance, check job status, copy files, cleanup, etc.

## Adding new versions of Tensorflow

Please add a new startup-script under the `bin/` folder having a name like `tf-x.x.x-startup-script` and manually verify that the entire script is runnable before comitting code to this repo.

## Ubuntu v. Debian

For production, benchmark tests, and CI, we run things in Docker. As things are when this was written, we use the python:3.6-slim image, which is based on Debian.
However, we can't use Docker on our gpusrvs (which are Ubuntu), so when running things outside of Docker, we we supply Ubuntu Images. Note it is possible these may
be usable across OS, but it is not guaranteed.

## Architecture

Haswell/Broadwell is deprecated, use Cascade Lake.
