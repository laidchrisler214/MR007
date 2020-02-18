#!/bin/bash

BUILD="build"
RUN="run"
CLEAN="clean"

DESTINATION=$2
CONFIGURATION="Debug"
DIR="/Users/greatfeatservices/Developer/PROJECT_MR007/product"

if [ "$1" == $BUILD ]; then
      xcodebuild -workspace 'MR007.xcworkspace' \
	       -scheme 'MR007' \
	       -configuration $CONFIGURATION \
	       -destination 'platform=iOS Simulator,OS=10.2,name=iPhone 7' \
	       -derivedDataPath $DIR
	       CODE_SIGNING_REQUIRED=NO \
	       CODE_SIGN_IDENTITY=''\
	       CODE_SIGNING_ALLOWED=NO \
	       ENABLE_BITCODE=NO \
	       ONLY_ACTIVE_ARCH=YES \
	       SWIFT_VERSION=3.0 \
	       DEBUG_INFORMATION_FORMAT=dwarf-with-dsym \
	       build

elif [ "$1" == $RUN ]; then
    xcrun simctl install booted $DIR/Build/Products/$CONFIGURATION-iphonesimulator/MR007.app
    xcrun simctl launch booted com.greatfeatservices.MR007

elif [ "$1" == $CLEAN ]; then
    xcrun simctl uninstall booted com.greatfeatservices.MR007 || true
 
else
    echo "Positional parameter 1 is empty"
fi
