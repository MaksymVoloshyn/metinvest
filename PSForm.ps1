#FormBuild
Add-Type -assembly System.Windows.Forms
$window_form = New-Object System.Windows.Forms.Form
$window_form.Text ='AD helper by MV'
$window_form.Width = 340
$window_form.Height = 500
$window_form.AutoSize = $true

#Funckblock

Function PCInfo {
$PCName = $UserLoginBox.Text
$PropertiesPC = Get-AdComputer $PCName -Properties * | Select-Object CanonicalName, LastLogonDate, PasswordExpired, OperatingSystemVersion
$LastLogonUsr = Get-WmiObject -Query "SELECT * FROM SMS_R_SYSTEM WHERE Name='$PCName'" -ComputerName "DC00-CMSS-01.metinvest.ua" -Namespace "root\sms\Site_S01" | ForEach-Object{$_.LastLogonUserName}
$listBox.Items.Add( 'PC $PropertiesPC.CanonicalName')
#$listBox.Items.Add( LastLogonUserName: $LastLogonUsr)
#$listBox.Items.Add( PasswordExpired: $PropertiesPC.PasswordExpired)
#$listBox.Items.Add( LastLogonDate: $PropertiesPC.LastLogonDate)
#$listBox.Items.Add( OperatingSystemVersion: $PropertiesPC.OperatingSystemVersion)
}

Function UserInfo {
cls
$UserName = Read-Host "Please enter user account name"
$PropertiesUserAcc = Get-AdUser $UserName -Properties * | Select-Object CN, CanonicalName, Company, PasswordExpired, LockedOut, mobile, extensionAttribute9
$Lastloggedusr = Get-WmiObject -Query "SELECT * FROM SMS_CM_RES_COLL_SMS00001 WHERE LastLogonUser like '$UserName'" -ComputerName "DC00-CMSS-01.metinvest.ua" -Namespace "root\sms\Site_S01" | ForEach-Object{$_.Name}
$PropertiesPC = Get-AdComputer $Lastloggedusr -Properties * | Select-Object CanonicalName, LastLogonDate, PasswordExpired, OperatingSystemVersion
cls
Write-Host ""
Write-Host "Name:             "$PropertiesUserAcc.CN
Write-Host ""
Write-Host "LastPCLoggedOn:   "$Lastloggedusr
Write-Host ""
Write-Host "PC_OU:            "$PropertiesPC.CanonicalName
Write-Host ""
Write-Host "User_OU:          "$PropertiesUserAcc.CanonicalName
Write-Host ""
Write-Host "PasswordExpired:  "$PropertiesUserAcc.PasswordExpired
Write-Host ""
Write-Host "Company:          "$PropertiesUserAcc.Company
Write-Host ""
Write-Host "Locked:           "$PropertiesUserAcc.LockedOut
Write-Host ""
Write-Host "MobileNo:         "$PropertiesUserAcc.mobile
Write-Host ""
Write-Host "CompanyPosition:  "$PropertiesUserAcc.extensionAttribute9
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "1. Add User to group"
Write-Host ""
Write-Host ""
$MenuSel = Read-Host "Choose option or press Enter to exit"
If ($MenuSel -eq 1) {
cls
$grpname = Read-Host "type group name"
Add-ADGroupMember -Identity $grpname -Member $UserName
cls
Write-Host "Done!"
Start-Sleep -s 3
Menu
}
Else {Menu} 
}



#UI
$radioButton1 = New-Object system.windows.Forms.RadioButton 
$radioButton1.Text = "AD User Info"
$radioButton1.AutoSize = $true
$radioButton1.location = new-object system.drawing.point(10,10)
$window_form.controls.Add($radioButton1)

$radioButton2 = New-Object system.windows.Forms.RadioButton 
$radioButton2.Text = "AD PC Info"
$radioButton2.AutoSize = $true
$radioButton2.location = new-object system.drawing.point(10,30)
$window_form.controls.Add($radioButton2)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,60)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Введите логин пользователя или имя ПК:'
$window_form.Controls.Add($label)

$UserLoginBox = New-Object System.Windows.Forms.TextBox
$UserLoginBox.Location = New-Object System.Drawing.Point(10,80)
$UserLoginBox.Size = New-Object System.Drawing.Size(300,20)
$window_form.Controls.Add($UserLoginBox)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,120)
$listBox.Size = New-Object System.Drawing.Size(300,20)
$listBox.Height = 300
$window_form.Controls.Add($listBox)

$button_click = {PCInfo}
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(10,450)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'Start'
$window_form.Controls.Add($okButton)
$okButton.Add_Click($Button_Click)

$window_form.ShowDialog()