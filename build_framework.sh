#!/bin/bash

# パス設定
FRAMEWORK_OUTPUT_PATH="./Build/Frameworks"  # フレームワークのビルド出力パス
FINAL_OUTPUT_PATH="./Frameworks/UnityFramework.xcframework"  # 最終的なフレームワーク/xcframeworkの出力先パス

PROJECT_PATH="."
OUTPUT_PATH="${PROJECT_PATH}/Builds"

DEVICE_BUILD_PATH="${OUTPUT_PATH}/DeviceSDK/Unity-iPhone.xcodeproj"
DEVICE_BUILD_ARCHIVE_PATH="${OUTPUT_PATH}/UnityFramework-Device.xcarchive"

# 前回のビルド結果が残っている場合には先に削除
rm -rfv ${DEVICE_BUILD_ARCHIVE_PATH}

# device向けのframeworkをarchive
xcodebuild archive \
   -project "$DEVICE_BUILD_PATH" \
   -scheme UnityFramework \
   -destination 'generic/platform=iOS' \
   -archivePath "$DEVICE_BUILD_ARCHIVE_PATH" \
   SKIP_INSTALL=NO \
   BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# ビルドが成功したかどうかを確認
if [ $? -ne 0 ]; then
   echo "Device framework archive failed"
   exit 1
fi

# 削除
rm -rfv ${FINAL_OUTPUT_PATH}

# device向け / simulator向けのframeworkからxcframeworkを生成
xcodebuild -create-xcframework \
  -framework "$DEVICE_BUILD_ARCHIVE_PATH/Products/Library/Frameworks/UnityFramework.framework" \
  -output "${FINAL_OUTPUT_PATH}"

# xcframeworkの作成が成功したかどうかを確認
if [ $? -ne 0 ]; then
    echo "xcframework creation failed"
    exit 1
fi

return 0