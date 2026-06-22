<p align="center">
  <img width="850" height="210" alt="ヘッダー" src="https://github.com/user-attachments/assets/feafbfe2-7066-4359-9ef0-0a4c75637299" />
</p>

<h1 align="center">
  印字位置切替ツール (ChangePrintLayoutTool)
</h1>
<p align="center">
  軟膏/水剤ラベル、および薬袋のよく使う印字レイアウトを瞬時に切り替えるツール。レセコンアプリ側の動作が重くて、複雑なレイアウト設定画面を経由する必要がなくなる。
</p>
<br/>

# :globe_with_meridians:概要

## 使用言語
- PowerShell + .NET Framework
- C# (スクリプト実行用のランチャー部分のみ)

## 開発背景
　弊社で採用しているレセコンアプリケーションでは、軟膏/水剤ラベルや薬袋の印字レイアウトの変更のたびに、処理が重く、複雑なレイアウト設定画面を操作する必要がある。また、設定画面では各印字項目の位置をマウスで地道に調整するか、座標を細かく手打ちするかしかなく、グリッド吸着などのレイアウトサポートがないことも不便であった。

　この状況に加えて、私が勤務していた店舗では以下の理由からレイアウトの変更をしたい状況がよく発生していた。

+ 軟膏ラベル、水剤ラベルはそれぞれ必要な項目が異なるが、両者ともに一日に何度も印刷しなければならない。
+ 外国の方など名前が長く収まらない方のために、薬袋の印字位置を調整する必要がある。

　以上の問題解決のため、弊店舗のスタッフ間では **「多めに項目を印刷して、必要な個所をその都度切り取って整形する」** という煩雑な作業が繰り返されていた。この状況を解消するため、レイアウトの設定変更を瞬時に行う本ツールの開発を行った。

## 開発概要
>[!NOTE]
>本アプリケーションの実行環境である投薬・薬歴記載用PCは、セキュリティが厳しく設定され、外部ツールの導入および外部との通信が著しく制限されていることから、Windows標準の機能であるPowerShellおよび.NET組み込みのC#コンパイラを利用する形とした。

　手作業での非効率な整形作業を **完全になくす** ため、誰でもワンタッチで指定したレイアウトに切り替えられるようなツールにする必要があった。本来は動作の重い設定画面を経由しなければならないが、その設定内容が **レセコンアプリケーション内部のiniファイル** に保存されていることを突き止め、それを直接操作することによって、自由にレイアウト変更ができることを確認した。

　この仕様を利用して、事前に作成したレイアウトが保存されたiniファイルをプリセットとして複数用意し、ワンタッチで差し替えることでレイアウトの瞬時変更が可能となった。また、画面上に常駐する切替ボタンUIを実装し、レイアウト変更操作を誰でも簡単に行えるようにした。

　スクリプト自体はC#で設計したシンプルなランチャーから実行する形にすることで、アイコン設定、タスクバーへの登録ができるようにし、スクリプトであることを意識せずに使えるようにした。

## 実績
　ラベル印刷業務の比重は店舗によって大きく異なるため、自店舗での利用にとどまるが、おおむね以下のような改善が見られた。
 
### 【改善効果】
- 1回のラベル整形作業に20～30秒かかる
- 1日に80回程度の印刷

　本ツールの導入で整形作業は完全になくなるので **単純計算で1日あたり30分前後の削減 / 一か月では約11時間の削減**

　実際には処方箋受付・入力などをしながら一日中発生する作業なので、手間の面では数字以上の改善が見られた。本ツールの導入後は、「細かい整形作業がなくなり、とても楽になった」「ラベル整形の手間がなくなった分、受付待ちの患者さんたちにあせること少なくなった」と好評をいただいている。

<br/><br/>

# :page_with_curl:マニュアル

## 動作イメージ
<img width="640" height="345" alt="動作イメージ" src="https://github.com/user-attachments/assets/47740d46-91c4-4928-9cae-05100c01007a" />

## 確認済み動作環境
- Windows 10/11
- PowerShell ver.5.0 以上
- .NET Framework 4.x 導入済み

## インストール方法
1. 本リポジトリをZIP形式でダウンロード。任意の場所に解凍してください。
2. ランチャー用の実行ファイルは同梱していませんので、初回起動時は **CompileLauncher.bat** を実行して **印字位置切替ツール.exe** が生成されるのを確認してください。
3. 以降は **印字位置切替ツール.exe** より本ツールを起動できます。

## 使用方法
1. 印字位置切替ツール.exeからスクリプトを起動。
2. 画面上に最前面で常駐するウィンドウが表示されるので、変更したいレイアウトを選択。切り替えられるレイアウトは以下の通り。
- ラベルレイアウト 軟膏/水剤
- ラベルレイアウト 右揃え/左揃え
- 薬袋レイアウト 名前サイズ通常/小さい
- 薬袋レイアウト 名前中央揃え/左揃え

<br/><br/>

# :hammer_and_wrench:技術文書

## ファイル構成
MainScript.ps1  
(メインロジック)  
FormUtility.ps1  
(.NET FrameworkによるUI生成用のライブラリ)

Default  
┗━ Default.ini  
   (ラベル/薬袋以外のレイアウト)

Label  
┣━ Normal-Alignment_Right.ini  
┃  (水剤/右揃えレイアウト)  
┣━ Ointment-Alignment_Left.ini  
┃  (軟膏/左揃えレイアウト)  
┗━ Ointment-Alignment_Right.ini  
   (軟膏/右揃えレイアウト)

Yakutai  
┣━ Alignment_Center-Size_Regular.ini  
┃  (名前中央揃え/文字サイズ普通)  
┣━ Alignment_Center-Size_Small.ini  
┃  (名前中央揃え/文字サイズ小)  
┣━ Alignment_Left-Size_Regular.ini  
┃  (名前左揃え/文字サイズ普通)  
┗━ Alignment_Left-Size_Small.ini  
   (名前左揃え/文字サイズ小)  

## 技術的ハイライト
1. レイアウトの切り替えは、iniファイルの読み込み・項目ごとの書き換えで行うのではなく、設定グループごとに切り出したプリセットiniファイルを丸ごと結合して上書きすることで実現。これにより低スペックなPC環境で1行ずつ読み込み・書き換えを行った際の処理待ちを回避することに成功、切り替え処理が一瞬になった。
```PowerShell
  function CombineIni
  {
    Param($Default, $Yakutai, $Label)
    $DefaultIni = Get-Content ($DefaultTemplateDir + "\" + $Default)
    $YakutaiIni = Get-Content ($YakutaiTemplateDir + "\" + $Yakutai)
    $LabelIni = Get-Content ($LabelTemplateDir + "\" + $Label)
    $CombinedIni = $DefaultIni + $YakutaiIni + $LabelIni
    return $CombinedIni
  }
```
<br/>

2. 各コントロールのイベントハンドラに **操作に応じてUI表示を変更する処理** を実装。これにより、内部での設定変更とUI上の表示が常に一致するようになっている。
```PowerShell
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
```

## ライセンス
本ツールは MIT License の元で公開されています。
