#!/bin/bash

IOS_PROJECT_PATH="Build/iOS"
FRAMEWORK_OUTPUT_PATH="Build/Framework"

# Clean and build the iOS framework
xcodebuild -project "$IOS_PROJECT_PATH/Unity-iPhone.xcodeproj" \
    -scheme UnityFramework \
    -configuration Release \
    -sdk iphoneos \
    BUILD_DIR="$FRAMEWORK_OUTPUT_PATH" \
    clean build

# Copy the framework to a specific location
cp -R "$FRAMEWORK_OUTPUT_PATH/Release-iphoneos/UnityFramework.framework" "$FRAMEWORK_OUTPUT_PATH/UnityFramework.framework"

if [ $? -ne 0 ]; then
    echo "Framework build failed"
    exit 1
fi

echo "iOS Framework built at $FRAMEWORK_OUTPUT_PATH/UnityFramework.framework"
