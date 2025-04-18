#!/bin/bash
# shellcheck disable=SC2317

# Repository root
ROOTDIR=$( cd -- "$( dirname -- "$0" )/.." &> /dev/null && pwd )

# Vendor functions
predocpack() { return 0; }
docpack() { return 0; }
postdocpack() { return 0; }

# Convenience functions
checkerror() {
    if [ "$1" != 0 ]
    then
        printf "%s - Error %s\n" "$2" "$1" >&2
        exit "$1"
    fi
}

# Sourcing the vendor script
export VENDOR_ERRORCODE=0
source "$ROOTDIR/vnd/vendor.sh"
checkerror $? "Failed to source the vendor script"

# Vendor error function
checkvendorerror() {
    if [ $VENDOR_ERRORCODE == 0 ]
    then
        export VENDOR_ERRORCODE=$1
    fi
}

# Run any vendor actions before pack
predocpack "$@"
checkerror $VENDOR_ERRORCODE "Failed to run pre-docpack function from the vendor"

# Pack using vendor action
docpack "$@"
checkerror $VENDOR_ERRORCODE "Failed to run documentation pack function from the vendor"

# Run any vendor actions after pack
postdocpack "$@"
checkerror $VENDOR_ERRORCODE "Failed to run post-docpack function from the vendor"

# Inform success
echo Pack successful.
