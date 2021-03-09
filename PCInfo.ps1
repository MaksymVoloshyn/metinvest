##MenuBlock#
Function Menu {
cls
Write-Host "##########AD_Helper by MV###########"
Write-Host ""
Write-Host "1. AD Computer Info"
Write-Host ""
Write-Host "2. AD User Info"
Write-Host ""
$MenuSelected = Read-Host "Select "
switch ($MenuSelected)
{
    1 {PCInfo}
    2 {UserInfo}
}
Menu
}

Function PCInfo {
cls
$PCName = Read-Host "Please enter PC Name"
$PropertiesPC = Get-AdComputer $PCName -Properties * | Select-Object CanonicalName, LastLogonDate, PasswordExpired, OperatingSystemVersion
$LastLogonUsr = Get-WmiObject -Query "SELECT * FROM SMS_R_SYSTEM WHERE Name='$PCName'" -ComputerName "DC00-CMSS-01.metinvest.ua" -Namespace "root\sms\Site_S01" | ForEach-Object{$_.LastLogonUserName}
cls
Write-Host ""
Write-Host "OU:                      "$PropertiesPC.CanonicalName
Write-Host ""
Write-Host "LastLogonUserName:       "$LastLogonUsr
Write-Host ""
Write-Host "PasswordExpired:         "$PropertiesPC.PasswordExpired
Write-Host ""
Write-Host "LastLogonDate:           "$PropertiesPC.LastLogonDate
Write-Host ""
Write-Host "OperatingSystemVersion:  "$PropertiesPC.OperatingSystemVersion
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "1. Add PC to group"
Write-Host ""
Write-Host ""
$MenuSel = Read-Host "Choose option or press Enter to exit"
If ($MenuSel -eq 1) {
cls
$grpname = Read-Host "Type group name"
Add-ADGroupMember -Identity $grpname -Member $PCName
cls
Write-Host "Done!"
Start-Sleep -s 3
Menu
}
Else {Menu} 
}

Function UserInfo {
cls
$UserName = Read-Host "Please enter user account name"
$PropertiesUserAcc = Get-AdUser $UserName -Properties * | Select-Object CN, CanonicalName, Company, PasswordExpired, LockedOut, mobile, extensionAttribute9
$Lastloggedusr = Get-WmiObject -Query "SELECT * FROM SMS_CM_RES_COLL_SMS00001 WHERE LastLogonUser like '$UserName'" -ComputerName "DC00-CMSS-01.metinvest.ua" -Namespace "root\sms\Site_S01" | ForEach-Object{$_.Name}
cls
Write-Host ""
Write-Host "Name:             "$PropertiesUserAcc.CN
Write-Host ""
Write-Host "LastPCLoggedOn:   "$Lastloggedusr
Write-Host ""
Write-Host "OU:               "$PropertiesUserAcc.CanonicalName
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

Menu