#印字位置切替ツール ver.1.3.2

#==============================
#アセンブリ読み込み
#==============================
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#==============================
#カレントフォルダ設定
#==============================
Set-Location (Split-Path $MyInvocation.MyCommand.Path -Parent)

#==============================
#外部ファイル読み込み
#==============================
. .\FormUtility.ps1

#==============================
#定数設定
#==============================
Set-Variable -Name ReceptyPath -Value "D:\hogehoge" -Option Constant
Set-Variable -Name SettingsPath -Value ".\Settings.ini" -Option Constant
Set-Variable -Name DefaultTemplateDir -Value ".\Default" -Option Constant
Set-Variable -Name YakutaiTemplateDir -Value ".\Yakutai" -Option Constant
Set-Variable -Name LabelTemplateDir -Value ".\Label" -Option Constant
Set-Variable -Name IniKey_YakutaiNameAlignment -Value "Yakutai_Name_Alignment=" -Option Constant
Set-Variable -Name IniKey_YakutaiNameSize -Value "Yakutai_Name_Size=" -Option Constant
Set-Variable -Name IniKey_LabelType -Value "Label_Type=" -Option Constant
Set-Variable -Name IniKey_LabelAlignment -Value "Label_Alignment=" -Option Constant

#==============================
#関数定義
#==============================
function ChangeIni
{
    Param($TargetPath, $Before, $After)
    $TargetContents = Get-Content $TargetPath
    $NewTargetContents = $TargetContents -replace $Before, $After
    $NewTargetContents | Out-File $TargetPath
    return
}
function CombineIni
{
    Param($Default, $Yakutai, $Label)
    $DefaultIni = Get-Content ($DefaultTemplateDir + "\" + $Default)
    $YakutaiIni = Get-Content ($YakutaiTemplateDir + "\" + $Yakutai)
    $LabelIni = Get-Content ($LabelTemplateDir + "\" + $Label)
    $CombinedIni = $DefaultIni + $YakutaiIni + $LabelIni
    return $CombinedIni
}
function CheckState
{
    $IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_YakutaiNameAlignment + "(.+)")
    switch($IniResult.Matches[0].Groups[1].Value) {
        "Left" {
            $IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_YakutaiNameSize + "(.+)")
            switch($IniResult.Matches[0].Groups[1].Value) {
                "Regular" {
                    $YakutaiSettings = "Alignment_Left-Size_Regular.ini"
                }
                "Small" {
                    $YakutaiSettings = "Alignment_Left-Size_Small.ini"
                }
            }
        }
        "Center" {
            $IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_YakutaiNameSize + "(.+)")
            switch($IniResult.Matches[0].Groups[1].Value) {
                "Regular" {
                    $YakutaiSettings = "Alignment_Center-Size_Regular.ini"
                }
                "Small" {
                    $YakutaiSettings = "Alignment_Center-Size_Small.ini"
                }
            }
        }
    }
    $IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_LabelType + "(.+)")
    switch($IniResult.Matches[0].Groups[1].Value) {
        "Normal" {
            $LabelSettings = "Normal-Alignment_Right.ini"
        }
        "Ointment" {
            $IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_LabelAlignment + "(.+)")
            switch($IniResult.Matches[0].Groups[1].Value) {
                "Left" {
                    $LabelSettings = "Ointment-Alignment_Left.ini"
                }
                "Right" {
                    $LabelSettings = "Ointment-Alignment_Right.ini"
                }
            }
        }
    }
    return CombineIni "Default.ini" $YakutaiSettings $LabelSettings
}

#==============================
#作業領域サイズの取得
#==============================
$WorkingArea = [System.Windows.Forms.SystemInformation]::WorkingArea

#==============================
#フォームの設定
#==============================
$Form = CreateForm 0 0 460 96 "印字位置切替ツール"
$Form.Location = New-Object System.Drawing.Point(($WorkingArea.Width - $Form.Width + 4), ($WorkingArea.Height - $Form.Height + 2)) 
$Form.ShowInTaskbar = $False
$Form.MinimizeBox = $False
$Form.MaximizeBox = $False
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$Form.BackColor = [System.Drawing.Color]::FromArgb(200, 220, 170)

#==============================
#フォームのイベントハンドラ設定
#==============================
$EventHandler_Shown = {
    $Form.ActiveControl = $null
}
$Form.Add_Shown($EventHandler_Shown)

#==============================
#ラベルの設定
#==============================
$Label1 = CreateLabel 11 31 145 20 ""
$Label1.AutoSize = $False
$Label1.Font = New-Object System.Drawing.Font("游ゴシック",11,[System.Drawing.FontStyle]::Bold)
$Label2 = CreateLabel 230 31 150 20 ""
$Label2.AutoSize = $False
$Label2.Font = New-Object System.Drawing.Font("游ゴシック",11,[System.Drawing.FontStyle]::Bold)

#==============================
#ボタンの設定
#==============================
$Button1 = CreateButton 160 28 55 24 "切替"
$Button1.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Button1.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(160, 160, 160)
$Button1.FlatAppearance.BorderSize = 2
$Button1.BackColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
$Button2 = CreateButton 380 28 55 24 "切替"
$Button2.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Button2.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(160, 160, 160)
$Button2.FlatAppearance.BorderSize = 2
$Button2.BackColor = [System.Drawing.Color]::FromArgb(220, 220, 220)

#==============================
#ボタンのイベントハンドラ設定
#==============================
$EventHandler_Click1 = {
    $IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_YakutaiNameAlignment + "(.+)")
    switch($IniResult.Matches[0].Groups[1].Value) {
        "Left" {
            ChangeIni $SettingsPath ($IniKey_YakutaiNameAlignment + "Left") ($IniKey_YakutaiNameAlignment + "Center")
            $Form.Controls[0].Text = "薬袋名前：中央揃え"
        }
        "Center" {
            ChangeIni $SettingsPath ($IniKey_YakutaiNameAlignment + "Center") ($IniKey_YakutaiNameAlignment + "Left")
            $Form.Controls[0].Text = "薬袋名前：左揃え"
        }
    }
    CheckState | Set-Content ($ReceptyPath + "\YakuTaiPos.ini")
}
$Button1.Add_Click($EventHandler_Click1)
$EventHandler_Click2 = {
    $IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_LabelType + "(.+)")
    switch($IniResult.Matches[0].Groups[1].Value) {
        "Normal" {
            $Form.Controls[5].Enabled = $True
            ChangeIni $SettingsPath ($IniKey_LabelType + "Normal") ($IniKey_LabelType + "Ointment")
            $Form.Controls[1].Text = "ラベル：軟膏用"
        }
        "Ointment" {
            $Form.Controls[1].Text = "ラベル：右揃え"
            ChangeIni $SettingsPath ($IniKey_LabelAlignment + "Left") ($IniKey_LabelAlignment + "Right")
            $Form.Controls[5].Enabled = $False
            ChangeIni $SettingsPath ($IniKey_LabelType + "Ointment") ($IniKey_LabelType + "Normal")
            $Form.Controls[1].Text = "ラベル：シロップ用"
        }
    }
    CheckState | Set-Content ($ReceptyPath + "\YakuTaiPos.ini")
}
$Button2.Add_Click($EventHandler_Click2)

#==============================
#チェックボックスの設定
#==============================
$CheckBox1 = CreateCheckBox 13 1 150 30 "名前を小さく"
$CheckBox2 = CreateCheckBox 232 1 150 30 "左揃え"

#==============================
#チェックボックスのイベントハンドラ設定
#==============================
$EventHandler_CheckedChanged1 = {
    If($Form.Controls[4].Checked) {        
        ChangeIni $SettingsPath ($IniKey_YakutaiNameSize + "Regular") ($IniKey_YakutaiNameSize + "Small")
    }
    else {        
        ChangeIni $SettingsPath ($IniKey_YakutaiNameSize + "Small") ($IniKey_YakutaiNameSize + "Regular")
    }
    CheckState | Set-Content ($ReceptyPath + "\YakuTaiPos.ini")
}
$CheckBox1.Add_CheckedChanged($EventHandler_CheckedChanged1)
$EventHandler_CheckedChanged2 = {
    If($Form.Controls[5].Checked) {        
        ChangeIni $SettingsPath ($IniKey_LabelAlignment + "Right") ($IniKey_LabelAlignment + "Left")
    }
    else {        
        ChangeIni $SettingsPath ($IniKey_LabelAlignment + "Left") ($IniKey_LabelAlignment + "Right")
    }
    CheckState | Set-Content ($ReceptyPath + "\YakuTaiPos.ini")
}
$CheckBox2.Add_CheckedChanged($EventHandler_CheckedChanged2)


#==============================
#現在設定の読み込み
#==============================
$IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_YakutaiNameAlignment + "(.+)")
switch($IniResult.Matches[0].Groups[1].Value)
{
    "Left" { $Label1.Text = "薬袋名前：左揃え" }
    "Center" { $Label1.Text = "薬袋名前：中央揃え" }
}
$IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_YakutaiNameSize + "(.+)")
switch($IniResult.Matches[0].Groups[1].Value)
{
    "Regular" { $CheckBox1.Checked = $False }
    "Small" { $CheckBox1.Checked = $True }
}
$IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_LabelType + "(.+)")
switch($IniResult.Matches[0].Groups[1].Value)
{
    "Normal" {
        $CheckBox2.Enabled = $False
        $Label2.Text = "ラベル：シロップ用"
    }
    "Ointment" { $Label2.Text = "ラベル：軟膏用" }
}
$IniResult = Select-String -Path $SettingsPath -Pattern ($IniKey_LabelAlignment + "(.+)")
switch($IniResult.Matches[0].Groups[1].Value)
{
    "Left" { $CheckBox2.Checked = $True }
    "Right" { $CheckBox2.Checked = $False }
}

#==============================
#コントロールをフォームに追加
#==============================
$Form.Controls.Add($Label1)
$Form.Controls.Add($Label2)
$Form.Controls.Add($Button1)
$Form.Controls.Add($Button2)
$Form.Controls.Add($CheckBox1)
$Form.Controls.Add($CheckBox2)

#==============================
#フォームの表示
#==============================
$Result = $Form.ShowDialog()
exit