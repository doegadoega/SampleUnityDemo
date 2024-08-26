#!/bin/bash

# Unityのインストールパスとプロジェクトパス
UNITY_PATH="/Applications/Unity/Hub/Editor/2022.3.33f1/Unity.app/Contents/MacOS/Unity"
PROJECT_PATH="."

# Unityプロジェクトのビルド実行
$UNITY_PATH -quit -batchmode -projectPath "$PROJECT_PATH" -executeMethod BuildScript.BuildIOS

# 結果のチェックと次の処理
if [ $? -eq 0 ]; then
    echo "Unity iOS build succeeded."
else
    echo "Unity iOS build failed."
    exit 1
fi
