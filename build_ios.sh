#!/bin/bash

# Unityのインストールパスとプロジェクトパス
UNITY_PATH="/Applications/2022.3.33f1/Unity.app/Contents/MacOS/Unity"
PROJECT_PATH="./"
OUTPUT_PATH="${PROJECT_PATH}/Builds"

${UNITY_PATH} -batchmode \
    -nographics \
    -silent-crashes \
    -quit \
    -buildTarget iOS \
    -projectPath ${PROJECT_PATH} \
    -executeMethod SampleUnityDemo.Editor.BuildMenu.BuildIOSForDeviceOnly \
    -logFile "${PROJECT_PATH}/Logs/SetSpecificSDK.log"

osascript -e 'display notification "Success Build UnityProject" sound name "Bip"'
    
# ビルドに成功して両方の`Unity-iPhone.xcodeproj`が生成されているかチェック
DEVICE_BUILD_PATH="${OUTPUT_PATH}/DeviceSDK/Unity-iPhone.xcodeproj"

if [ ! -d $DEVICE_BUILD_PATH ]; then
    echo "iOS実機向けのビルドが存在しない"
    return 1
fi
