#!/bin/bash


if [ $1 ]; then
	DISTRIBUTION=$1
else
	DISTRIBUTION=distribution-karaf-0.4.3-Beryllium-SR3
fi

if [ $2 ]; then
	DEBUG="yes"
fi

find_local_file() {
	if [ -f "$DISTRIBUTION.tar.gz" ]; then
		DISTRIBUTION_FILE="$DISTRIBUTION.tar.gz"
	elif [ -f "$DISTRIBUTION.tar" ]; then
		DISTRIBUTION_FILE="$DISTRIBUTION.tar"
	elif [ -f "$DISTRIBUTION.zip" ]; then
		DISTRIBUTION_FILE="$DISTRIBUTION.zip"
	else
		DISTRIBUTION_FILE=""
	fi
}

download() {
	if [ -z "$DISTRIBUTION_FILE" ]; then
		URL="$(cat distributions | grep $DISTRIBUTION)"
		if [ -z "$URL" ]; then
			echo "Error: Cannot download distribution file."
			exit 1
		fi
		wget $URL
		find_local_file
	fi

	if [ -z "$DISTRIBUTION_FILE" ]; then
		echo "Error: Cannot find distribution file! Only tar.gz/tar/zip are supported."
		exit 1
	fi
}

install() {
	rm -rf $DISTRIBUTION
	if [ -f "$DISTRIBUTION.tar.gz" ]; then
		INSTALL="$(which tar) xvfz"
	elif [ -f "$DISTRIBUTION.tar" ]; then
		INSTALL="$(which tar) xvf"
	elif [ -f "$DISTRIBUTION.zip" ]; then
		INSTALL="$(which unzip)"
	fi
	$INSTALL $DISTRIBUTION_FILE
}

patch() {
	PATCH_FILES=$(find patch -name $DISTRIBUTION"*" | sort)
	if [ "$PATCH_FILES" ]; then
		pushd $DISTRIBUTION && git init && popd
		echo "Applying patch for "$DISTRIBUTION
		for patch in $PATCH_FILES; do
			rm -rf $DISTRIBUTION/_tmp

			cp $patch $DISTRIBUTION/_tmp
			pushd $DISTRIBUTION && git apply _tmp \
				&& echo $DISTRIBUTION" is patched with "$patch \
				|| echo "Error patching "$DISTRIBUTION && popd
			rm -rf $DISTRIBUTION/_tmp
		done
	fi
}

debug_l2switch() {
	local L2_PATH="$DISTRIBUTION/system/org/opendaylight/l2switch"
	if [ ! -f "l2switch.zip" ]; then
		wget https://dl.dropboxusercontent.com/u/67746293/l2switch.zip
	fi

	rm -rf "$L2_PATH"
	mkdir -p "$L2_PATH"
	cp l2switch.zip "$L2_PATH"
	pushd "$L2_PATH" && unzip l2switch.zip && popd || popd

}

debug_openflowplugin() {
	local OFP_PATH="$DISTRIBUTION/system/org/opendaylight/openflowplugin"
	if [ ! -f "openflowplugin.zip" ]; then
		echo "Maybe next time"
		return
	fi

	rm -rf "$OFP_PATH"
	mkdir -p "$OFP_PATH"
	cp openflowplugin.zip "$OFP_PATH"
	pushd "$OFP_PATH" && unzip openflowplugin.zip && popd || popd
}

enable_debug() {
	if [ -z "$DEBUG" ] ; then
		return
	fi
	ODL_SYSPATH="$DISTRIBUTION/system/org/opendaylight"

	debug_l2switch
	debug_openflowplugin
}

find_local_file
download
install
patch
enable_debug
