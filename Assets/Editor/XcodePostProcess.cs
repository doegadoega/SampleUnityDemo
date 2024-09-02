using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.IO;
using System.Text.RegularExpressions;

public class XcodePostProcess
{
    [PostProcessBuild]
    public static void OnPostprocessBuild(BuildTarget target, string pathToBuildProject)
    {
        if (target == BuildTarget.iOS)
        {
            // Xcodeプロジェクトのパスを取得
            string projectPath = PBXProject.GetPBXProjectPath(pathToBuildProject);
            PBXProject project = new PBXProject();
            project.ReadFromFile(projectPath);

            // Main TargetのGUIDを取得
            string targetGuid = project.GetUnityMainTargetGuid();

            // UnityFrameworkのターゲットGUIDを取得
            string unityFrameworkTargetGuid = project.GetUnityFrameworkTargetGuid();

            // チームID（Team ID）を設定
            string teamID = "TCB82V84V5"; // ここにApple Developer Team IDを設定します
            project.SetBuildProperty(targetGuid, "DEVELOPMENT_TEAM", teamID);
            project.SetBuildProperty(unityFrameworkTargetGuid, "DEVELOPMENT_TEAM", teamID);

            // ビットコードを無効にする
            project.SetBuildProperty(unityFrameworkTargetGuid, "ENABLE_BITCODE", "NO");

            // リンクフラグの設定
            project.AddBuildProperty(unityFrameworkTargetGuid, "OTHER_LDFLAGS", "-ld64");

            // シミュレーター用か実機用かを判断する
            string sdk = project.GetBuildPropertyForConfig(targetGuid, "SDKROOT");
            bool isSimulator = sdk.Contains("iphonesimulator");

            // NOTE: iOS Simulatorのエラー対策
            if (PlayerSettings.iOS.sdkVersion == iOSSdkVersion.SimulatorSDK)
            {
                var removeLdFlags = new[]
                {
                    "-Wl,-undefined,dynamic_lookup",
                    "-Wl,-exported_symbol,_il2cpp_*"
                };
                project.UpdateBuildProperty(targetGuid, "OTHER_LDFLAGS", new string[] { }, removeLdFlags);
            }

            // NativeCallProxy.hをpublicに変更する
            string projectContent = File.ReadAllText(projectPath);
            string pattern = @"(\/\* NativeCallProxy\.h in Headers \*\/ = \{isa = PBXBuildFile; fileRef = .*?\/\* NativeCallProxy\.h \*\/; )};";
            string replacement = @"$1settings = {ATTRIBUTES = (Public, ); }; };";
            projectContent = Regex.Replace(projectContent, pattern, replacement, RegexOptions.Singleline);
            File.WriteAllText(projectPath, projectContent);

            // Xcodeプロジェクトを保存
            project.WriteToFile(projectPath);
        }
    }
}