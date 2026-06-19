// ==============================
// プリディレクティブ
// ==============================
using System;
using System.Diagnostics;
using System.IO;

// ==============================
// メイン
// ==============================
class Launcher {
    static void Main(string[] args) {
        // 起動するスクリプト名
        string exePath = AppDomain.CurrentDomain.BaseDirectory;
        string scriptPath = Path.Combine(exePath, "MainScript.ps1");

        // スクリプトが同一階層に存在しない場合は終了
        if (!File.Exists(scriptPath)) return;

        // プロセスの設定
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.FileName = "powershell.exe";
        startInfo.Arguments = string.Format("-ExecutionPolicy Bypass -File \"{0}\"", scriptPath);
        startInfo.WorkingDirectory = Path.GetDirectoryName(exePath);
        startInfo.CreateNoWindow = true;
        startInfo.WindowStyle = ProcessWindowStyle.Hidden;
        startInfo.UseShellExecute = false;
        
        // プロセスの起動
        Process.Start(startInfo);
    }
}
