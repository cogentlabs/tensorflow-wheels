#!/bin/bash

PROJECT=brew-staging
ZONE=asia-northeast1-b
MACHINE_TYPE=n1-standard-2
MIN_CPU_PLATFORM="Intel Broadwell"
BOOT_DISK_SIZE=10GB
BOOT_DISK_TYPE=pd-standard

DEBIAN_INSTANCE_NAME=tf-19-auto-build-broadwell-debian-$(whoami)-$(date +"%Y%m%d-%H%M%S")
DEBIAN_IMAGE=debian-8-jessie-v20180611
DEBIAN_IMAGE_PROJECT=debian-cloud

UBUNTU_INSTANCE_NAME=tf-19-auto-build-broadwell-ubuntu-$(whoami)-$(date +"%Y%m%d-%H%M%S")
UBUNTU_IMAGE=ubuntu-1604-xenial-v20180724
UBUNTU_IMAGE_PROJECT=ubuntu-os-cloud

gcloud beta compute instances create "$DEBIAN_INSTANCE_NAME" \
    --project=$PROJECT \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --min-cpu-platform="$MIN_CPU_PLATFORM" \
    --image=$DEBIAN_IMAGE \
    --image-project=$DEBIAN_IMAGE_PROJECT \
    --boot-disk-size=$BOOT_DISK_SIZE \
    --boot-disk-type=$BOOT_DISK_TYPE \
    --metadata-from-file startup-script='./tf-1.9.0-startup-script.sh'

gcloud beta compute instances create "$UBUNTU_INSTANCE_NAME" \
    --project=$PROJECT \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --min-cpu-platform="$MIN_CPU_PLATFORM" \
    --image=$UBUNTU_IMAGE \
    --image-project=$UBUNTU_IMAGE_PROJECT \
    --boot-disk-size=$BOOT_DISK_SIZE \
    --boot-disk-type=$BOOT_DISK_TYPE \
    --metadata-from-file startup-script='./tf-1.9.0-startup-script.sh'

echo -e "\n\n\n\n\nREMEMBER TO CLEAN UP YOUR GCE RESOURCES WHEN YOU ARE FINISHED!!!\n\n\n\n\n"
