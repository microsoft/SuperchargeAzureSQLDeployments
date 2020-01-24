
param (
    [Parameter(Mandatory=$true)][string]$ARMOutput
    )

#region Convert from json
$json = $ARMOutput | convertfrom-json
$sqlAdminLogin = $json.administratorLogin.value
$sqlAdminPass = $json.administratorLoginPassword.value
#endregion

#region Parse ARM Template Output
Write-Host "##vso[task.setvariable variable=sql.Login]$sqlAdminLogin"
Write-Host "##vso[task.setvariable variable=sql.Pass;issecret=true]$sqlAdminPass"
#endregion

