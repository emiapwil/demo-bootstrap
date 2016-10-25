#!/bin/bash

if [ $1 ]; then
	DISTRIBUTION=$1
else
	DISTRIBUTION=distribution-karaf-0.4.3-Beryllium-SR3
fi

PATCH_FILES=$(find patch -name $DISTRIBUTION"*")

echo $PATCH_FILES

rm -rf $DISTRIBUTION
unzip $DISTRIBUTION.zip

if [ "$PATCH_FILES" ]; then
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
