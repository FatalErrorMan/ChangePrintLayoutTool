#関数定義
function CreateForm
{
    Param($PosX, $PosY, $Width, $Height, $Caption)
    $Form = New-Object System.Windows.Forms.Form
    $Form.Size = New-Object System.Drawing.Size($Width,$Height)
    $Form.Text = $Caption
    $Form.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual
    $Form.DesktopLocation = New-Object System.Drawing.Size($PosX, $PosY)
    return $Form
}

function CreateLabel
{
    Param($PosX, $PosY, $Width, $Height, $Caption)
    $Label = New-Object System.Windows.Forms.Label
    $Label.Location = New-Object System.Drawing.Point($PosX,$PosY) 
    $Label.Size = New-Object System.Drawing.Size($Width,$Height) 
    $Label.Text = $Caption
    return $Label
}

function CreateTextBox
{
    Param($PosX, $PosY, $Width, $Height)
    $TextBox = New-Object System.Windows.Forms.TextBox 
    $TextBox.Location = New-Object System.Drawing.Point($PosX,$PosY) 
    $TextBox.Size = New-Object System.Drawing.Size($Width,$Height)
    return $TextBox
}


function CreateButton
{
    Param($PosX, $PosY, $Width, $Height, $Caption)
    $Button = New-Object System.Windows.Forms.Button
    $Button.Location = New-Object System.Drawing.Point($PosX,$PosY)
    $Button.Size = New-Object System.Drawing.Size($Width,$Height)
    $Button.Text = $Caption
    return $Button
}

function CreateTrackBar
{
    Param($PosX, $PosY, $Width, $Height, $TickFrequency, $Minimum, $Maximum, $DefaultValue)
    $TrackBar = New-Object System.Windows.Forms.TrackBar
    $TrackBar.Location = New-Object System.Drawing.Point($PosX,$PosY)
    $TrackBar.Size = New-Object System.Drawing.Size($Width,$Height)
    $TrackBar.TickFrequency = $TickFrequency
    $TrackBar.Minimum = $Minimum
    $TrackBar.Maximum = $Maximum
    $TrackBar.Value = $DefaultValue
    return $TrackBar
}

function CreateCheckBox
{
    Param($PosX, $PosY, $Width, $Height, $Caption)
    $CheckBox = New-Object System.Windows.Forms.CheckBox
    $CheckBox.Location = New-Object System.Drawing.Point($PosX,$PosY)
    $CheckBox.Size = New-Object System.Drawing.Size($Width,$Height)
    $CheckBox.Text = $Caption
    return $CheckBox
}