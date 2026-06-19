@rem ==============================
@rem スクリプト起動用のランチャーをコンパイル
@rem (Windows標準C#コンパイラを利用)
@rem ==============================
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe /target:winexe /r:System.Windows.Forms.dll /win32icon:%~dp0印字位置切替ツール.ico /out:%~dp0印字位置切替ツール.exe %~dp0Launcher.cs