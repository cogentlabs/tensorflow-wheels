#!/bin/bash

TF_VERSION=$1
if ! [[ $TF_VERSION ]] || ! [[ $TF_VERSION =~ [0-9]+\.[0-9+\.[0-9]+ ]]; then
    echo -e "\nusage: $0 TF_VERSION"
    echo -e "\nTF_VERSION should be like x.x.x (eg 1.10.1)\n"
    exit 1
fi

STARTUP_SCRIPT_PATH=tf-${TF_VERSION}-startup-script.sh
if ! [ -e $STARTUP_SCRIPT_PATH ]; then
    if [ -e "bin/$STARTUP_SCRIPT_PATH" ]; then
        STARTUP_SCRIPT_PATH="bin/$STARTUP_SCRIPT_PATH"
    else
        echo -e "\nCould not find startup script for version ${TF_VERSION}"
        echo -e "\nChecked $STARTUP_SCRIPT_PATH and ./bin/$STARTUP_SCRIPT_PATH\n"
        exit 1
    fi
fi

TF_VERSION_DASH=$(echo $TF_VERSION | sed -e 's/\./-/g')
TF_VERSION_DOT=$(echo $TF_VERSION | sed -e 's/-/./g')

PROJECT=algebraic-cycle-111108
ZONE=asia-northeast1-b
MACHINE_TYPE=n1-standard-2
MIN_CPU_PLATFORM="Intel Broadwell"
BOOT_DISK_SIZE=10GB
BOOT_DISK_TYPE=pd-standard

GCLOUD_USER=$(gcloud config get-value account | sed -e 's/@.*//g')

DEBIAN_INSTANCE_NAME=tf-${TF_VERSION_DASH}-auto-build-broadwell-debian-$GCLOUD_USER-$(date +"%Y%m%d-%H%M%S")
DEBIAN_IMAGE=debian-9-stretch-v20180814
DEBIAN_IMAGE_PROJECT=debian-cloud

UBUNTU_INSTANCE_NAME=tf-${TF_VERSION_DASH}-auto-build-broadwell-ubuntu-$GCLOUD_USER-$(date +"%Y%m%d-%H%M%S")
UBUNTU_IMAGE=ubuntu-1604-xenial-v20190430
UBUNTU_IMAGE_PROJECT=ubuntu-os-cloud

EXPECTED_WHEEL_NAME=tensorflow-${TF_VERSION_DOT}-cp36-cp36m-linux_x86_64.whl

gcloud beta compute instances create "$DEBIAN_INSTANCE_NAME" \
    --project=$PROJECT \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --min-cpu-platform="$MIN_CPU_PLATFORM" \
    --image=$DEBIAN_IMAGE \
    --image-project=$DEBIAN_IMAGE_PROJECT \
    --boot-disk-size=$BOOT_DISK_SIZE \
    --boot-disk-type=$BOOT_DISK_TYPE \
    --metadata-from-file startup-script="$STARTUP_SCRIPT_PATH"

gcloud beta compute instances create "$UBUNTU_INSTANCE_NAME" \
    --project=$PROJECT \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --min-cpu-platform="$MIN_CPU_PLATFORM" \
    --image=$UBUNTU_IMAGE \
    --image-project=$UBUNTU_IMAGE_PROJECT \
    --boot-disk-size=$BOOT_DISK_SIZE \
    --boot-disk-type=$BOOT_DISK_TYPE \
    --metadata-from-file startup-script="$STARTUP_SCRIPT_PATH"

cat <<EOF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                                                             !
!         REMEMBER TO CLEAN UP YOUR GCE RESOURCES WHEN YOU ARE FINISHED       !
!                                                                             !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Your have 2 running instances in "${PROJECT}" project:

    $DEBIAN_INSTANCE_NAME
    $UBUNTU_INSTANCE_NAME

To list instances in a project:

    gcloud compute instances list --project ${PROJECT}

To ssh into an instance (e.g. the Debian instance):

    gcloud compute ssh \\
        ${DEBIAN_INSTANCE_NAME} \\
        --project ${PROJECT} \\
        --zone ${ZONE}

To view logs from the Tensorflow build script (from inside the instance):

    tail -f /var/log/syslog

When the build is complete, your Tensorflow wheel file will be located in

    /home/${GCLOUD_USER}/tensorflow_pkg/tensorflow-1.10.0-cp36-cp36m-linux_x86_64.whl

To copy the file to your local machine (e.g. the Debian instance):

    gcloud compute scp --recurse \\
        ${DEBIAN_INSTANCE_NAME}:/tensorflow_pkg/${EXPECTED_WHEEL_NAME} \\
        ./tensorflow_1.10.0_pkg \\
        --project ${PROJECT} \\
        --zone ${ZONE}

When finished please DELETE your instances:

    gcloud compute instances delete \\
        ${DEBIAN_INSTANCE_NAME} \\
        ${UBUNTU_INSTANCE_NAME} \\
        --delete-disks=all \\
        --project ${PROJECT} \\
        --zone ${ZONE}

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                                                             !
!                    PLEASE READ INSTRUCTIONS PRINTED ABOVE                   !
!                                                                             !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

EOF
