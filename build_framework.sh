#!/bin/bash

# パス設定
IOS_PROJECT_PATH="./Build/iOS"  # iOSプロジェクトのパス
FRAMEWORK_OUTPUT_PATH="$IOS_PROJECT_PATH/Build"  # フレームワークのビルド出力パス
FINAL_OUTPUT_PATH="./Frameworks"  # 最終的なフレームワーク/xcframeworkの出力先パス

# iOSフレームワークのクリーンビルド
xcodebuild -project "$IOS_PROJECT_PATH/Unity-iPhone.xcodeproj" \
    -scheme UnityFramework \
    -configuration Release \
    -sdk iphoneos \
    BUILD_DIR="$FRAMEWORK_OUTPUT_PATH" \
    clean build

# ビルドが成功したかどうかを確認
if [ $? -ne 0 ]; then
    echo "Framework build failed"
    exit 1
fi

# フレームワークをコピー
cp -R "$FRAMEWORK_OUTPUT_PATH/Framework/Release-iphoneos/UnityFramework.framework" "$FINAL_OUTPUT_PATH/UnityFramework.framework"

# コピーが成功したかどうかを確認
if [ $? -ne 0 ]; then
    echo "Failed to copy framework to $FINAL_OUTPUT_PATH"
    exit 1
fi

echo "iOS Framework built and copied to $FINAL_OUTPUT_PATH/UnityFramework.framework"

# xcframeworkの作成
xcodebuild -create-xcframework \
    -framework "$FINAL_OUTPUT_PATH/UnityFramework.framework" \
    -output "$FINAL_OUTPUT_PATH/UnityFramework.xcframework"

# xcframeworkの作成が成功したかどうかを確認
if [ $? -ne 0 ]; then
    echo "xcframework creation failed"
    exit 1
fi

# 成功メッセージ
echo "xcframework created at $FINAL_OUTPUT_PATH/UnityFramework.xcframework"
