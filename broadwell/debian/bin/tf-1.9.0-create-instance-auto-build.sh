#!/bin/bash

INSTANCE_NAME=tf-1.9.0-auto-build-broadwell-debian-$(whoami)-$(date +"%Y%m%d-%H%M%S")
PROJECT=brew-staging
ZONE=asia-northeast1-b
MACHINE_TYPE=n1-standard-2
MIN_CPU_PLATFORM="Intel Broadwell"
IMAGE=debian-8-jessie-v20180611
IMAGE_PROJECT=debian-cloud
BOOT_DISK_SIZE=10GB
BOOT_DISK_TYPE=pd-standard
BOOT_DISK_DEVICE_NAME=$INSTANCE_NAME


gcloud beta compute --project=$PROJECT instances create "$INSTANCE_NAME" \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --min-cpu-platform="$MIN_CPU_PLATFORM" \
    --image=$IMAGE \
    --image-project=$IMAGE_PROJECT \
    --boot-disk-size=$BOOT_DISK_SIZE \
    --boot-disk-type=$BOOT_DISK_TYPE \
    --boot-disk-device-name="$BOOT_DISK_DEVICE_NAME"\
    --metadata-from-file startup-script='./tf-1.9.0-startup-script-auto-build.sh'
