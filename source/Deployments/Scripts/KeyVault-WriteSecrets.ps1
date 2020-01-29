Param(
	$kVaultName,
	$ResourceGroup,	
	$adminLogin,
	$adminPass
)

Function ToSecret {
	Param($val)
	$secret = ConvertTo-SecureString -String $val -AsPlainText -Force
	$secret 
	}

$kvSecrets = @{
	'SQLadminLogin' = ToSecret -val $adminLogin
	'SQLadminPass' = ToSecret -val $adminPass
}

ForEach($Key in $kvSecrets.Keys){
	$response = Set-AzKeyVaultSecret -VaultName $kVaultName -Name $Key -SecretValue $kvSecrets[$Key]
	Write-Host $response
	}

