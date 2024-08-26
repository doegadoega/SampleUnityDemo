using UnityEditor;
using UnityEditor.Build.Reporting;

public class BuildScript
{
    public static void BuildIOS()
    {
        // 出力先のパス
        string buildPath = "Build/iOS";

        // ビルドオプションの設定
        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = new[] { "Assets/Scenes/SampleScene.unity" }, // ビルドするシーンを指定
            locationPathName = buildPath,
            target = BuildTarget.iOS,
            options = buildPlayerOptions. // ビルドオプションを指定
        };

        // ビルド実行
        BuildReport report = BuildPipeline.BuildPlayer(buildPlayerOptions);
        BuildSummary summary = report.summary;

        // ビルド結果の確認
        if (summary.result == BuildResult.Succeeded)
        {
            UnityEngine.Debug.Log("iOS build succeeded: " + summary.totalSize + " bytes");
        }

        if (summary.result == BuildResult.Failed)
        {
            UnityEngine.Debug.LogError("iOS build failed");
        }
    }
}