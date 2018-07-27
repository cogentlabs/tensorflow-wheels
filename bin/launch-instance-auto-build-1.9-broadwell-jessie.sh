#!/bin/bash

NAME=joe-compile-tf-19-startup-$(date +"%Y%m%d-%H%M%S")

gcloud beta compute --project=brew-staging instances create \
	${NAME} \
	--zone=asia-northeast1-b \
	--machine-type=n1-standard-2 \
    --min-cpu-platform=Intel\ Broadwell \
    --image=debian-8-jessie-v20180611 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=${NAME} \
    --metadata-from-file startup-script=./startup.sh