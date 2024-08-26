using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.IO;

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

            // チームID（Team ID）を設定
            string teamID = "TCB82V84V5"; // ここにApple Developer Team IDを設定します
            project.SetBuildProperty(targetGuid, "DEVELOPMENT_TEAM", teamID);

            // プロビジョニングプロファイルを設定する場合
            // string provisioningProfile = "YOUR_PROVISIONING_PROFILE_UUID";
            // project.SetBuildProperty(targetGuid, "PROVISIONING_PROFILE_SPECIFIER", provisioningProfile);

            // Xcodeプロジェクトを保存
            project.WriteToFile(projectPath);
        }
    }
}