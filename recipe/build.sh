#!/bin/bash

URL_ROOT="https://naif.jpl.nasa.gov/pub/naif/utilities/"
PROGS=( \
	archtype bff bingo brief 
	bspidmod chronos ckbrief ckslicer cksmrg ckspanit commnt
	dafcat dafmod dlacat dskbrief dskexp frmdiff inspekt makclk maklabel mkdsk mkspk
	msopck oem2spk optiks orbnum pinpoint prediCkt spacit spk2oem spkdiff
	spkmerge spy starsb tobin toxfr
	)

# Abort if we forgot to set the prefix (shouldn't ever happen when this script
# is actually run by conda-build)
[[ ! -z $PREFIX ]] || { echo "PREFIX not set. aborting."; exit -1; }

case $(uname) in
	Darwin)		ARCH="MacIntel_OSX_64bit"
			;;
	Linux)		ARCH="PC_Linux_64bit"
			;;
	*)		echo "Unknown architecture."; exit -1;
			;;
esac
URL_BASE="$URL_ROOT/$ARCH"

#
# Download
#
mkdir -p bin
for PROG in "${PROGS[@]}"; do
	echo "$PROG:"
	# Hack because NASA's website occasionally refuses connections
	for retry in $(seq 5); do
		curl -L -# -o "bin/$PROG" "$URL_BASE/$PROG" && break
		rm -f "bin/$PROG"
		sleep 1
	done
	chmod +x "bin/$PROG"
done

#
# Install
#
mkdir -p "$PREFIX/bin"
cp -a bin/* "$PREFIX/bin"
