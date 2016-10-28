#!/bin/bash

if [ $1 ]; then
	DISTRIBUTION=$1
else
	DISTRIBUTION=distribution-karaf-0.4.3-Beryllium-SR3
fi

if [ $2 ]; then
	PATCH_VERSION=$2
else
	PATCH_VERSION="3"
fi

rm "patch/$DISTRIBUTION.$PATCH_VERSION.patch"
./setup-controller.sh $DISTRIBUTION

pushd $DISTRIBUTION && git add LICENSE && git commit -m "Set up default repo" && popd
pushd $DISTRIBUTION && mkdir -p system/org/snlab && popd
pushd $DISTRIBUTION && cp -R ~/.m2/repository/org/snlab/arpproxy system/org/snlab/ && popd
pushd $DISTRIBUTION && cp -R ~/.m2/repository/org/snlab/openflow system/org/snlab/ && popd
pushd $DISTRIBUTION && git add system/org/snlab && git commit -m "Import ARP proxy packages" && popd
pushd $DISTRIBUTION && git format-patch HEAD^1 --stdout > "../patch/$DISTRIBUTION.$PATCH_VERSION.patch" && popd
