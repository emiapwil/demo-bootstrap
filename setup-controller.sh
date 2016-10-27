#!/bin/bash


if [ $1 ]; then
	DISTRIBUTION=$1
else
	DISTRIBUTION=distribution-karaf-0.4.3-Beryllium-SR3
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
		URL= $(cat distributions | grep $DISTRIBUTION)
		if [ -z "$URL" ]; then
			echo "Error: Cannot download distribution file."
			exit 1
		fi
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
				&& echo $DISTRIBUTION" is patched" \
				|| echo "Error patching "$DISTRIBUTION && popd
			rm -rf $DISTRIBUTION/_tmp
		done
	fi
}

find_local_file
download
install
patch
