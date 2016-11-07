#!/bin/bash

ROOT_DIR="$(dirname $(which $0))"
SCRIPT_DIR="$ROOT_DIR/scripts"
PATCH_DIR="$ROOT_DIR/patch"

source "$SCRIPT_DIR/util"

setup_distribution $1
shift

if [ "$1" == "prompt" ]; then
	PROMPT="Y"
	shift
fi

if [ "$1" == "debug" ]; then
	DEBUG="Y"
	shift
fi

enable_debug() {
	if [ -z "$DEBUG" ] ; then
		return
	fi

	debug_l2switch
	debug_openflowplugin
}

patch_l2switch() {
	debug_l2switch
}

prompt() {
	CMD="$1"

	if [ ! -z "$PROMPT" ]; then
		echo "Accept $CMD?"
		select choice in 'Yes' 'No';
		do
			case $choice in
				'No'  ) return;;
				'Yes' ) break;;
			esac
		done
	fi

	$CMD
}

setup_git
prompt configure_l2switch
prompt enable_ofstabilizer
prompt install_snlab_ofessentials
prompt patch_distribution
prompt patch_l2switch

enable_debug
