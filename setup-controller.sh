#!/bin/bash

ROOT_DIR="$(dirname $(which $0))"
SCRIPT_DIR="$ROOT_DIR/scripts"

source "$SCRIPT_DIR/util"

setup_distribution $1

if [ $2 ]; then
	DEBUG="yes"
fi

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

enable_debug() {
	if [ -z "$DEBUG" ] ; then
		return
	fi

	debug_l2switch
	debug_openflowplugin
}

patch
enable_debug
