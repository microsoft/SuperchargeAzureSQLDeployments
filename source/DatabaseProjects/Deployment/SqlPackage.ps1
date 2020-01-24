param (
    $TenantId,
    $ServicePrincipalId,
    $AppKey,
    $SqlSrv,
    $SqlDb,
    $ReportPath,
    $dacpacPath,
    $sqlpackagePath,
    $PackageAction,
    $ResourceGroupName,
    $CreateFirewallRule 
);

#To Test Script Local provide values for the Params and Login to Azure as this script is meant to run in Azure Power Shell
# Login-AzAccount

$TenantId = '72f988bf-86f1-41af-91ab-2d7cd011db47'
$ServicePrincipalId = 'ffed3ad4-ac99-45bc-979f-28dfee40d284'
$AppKey = 'aDV?7jK5:0bX_Y8wGKGFwRk::_gs2EA:'
$SqlSrv = 'dlm-sqlsrv-dev'
$SqlDb = 'trainingDW'
$ReportPath = 'C:\'
$dacpacPath = 'C:\Users\fgarofalo\Documents\Repos\DataAI\Azure Data Platforms\DLM\AzureSQLDB\DatabaseProjects\trainingDW\trainingDW\bin\Debug'
$sqlpackagePath = 'C:\Program Files\Microsoft SQL Server\150\DAC\bin'
$PackageAction = 'DeployReport'
$ResourceGroupName = 'dlm-demo-dev'
$CreateFirewallRule = 'true'



#Create Deployment Firewall Rule
If ($CreateFirewallRule) {
    $RuleName = "DevOpsDeploymentIP"
    #Local IP Address
    # $ipAddress = (Test-Connection -ComputerName (hostname) -Count 1  | Select IPV4Address).IPV4Address.IPAddressToString
    ## Old ##(Invoke-RestMethod -Uri https://ipinfo.io).ip
    $ipAddress = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
    
    #Get Current Firewall Rules
    #Get-AzSqlServerFirewallRule not on Buile Server
    $Firewall = (Get-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlSrv).FirewallRuleName | Select-String -Pattern $RuleName
 
    #Set Params for New Deployment Firewall Rule.
    $params = @{
        ResourceGroupName = $ResourceGroupName
        ServerName        = $SqlSrv
        FirewallRuleName  = $RuleName
        StartIpAddress    = $ipAddress
        EndIpAddress      = $ipAddress 
        Verbose            = $true
    }

    #Check if there is already a firewall rule from past Deploymnets
    if ($Firewall -eq $RuleName) {
        Write-Host "Removeing Old Deployment Firewall Rule."
        #Remove-AzSqlServerFirewallRule
        Remove-AzqlServerFirewallRule -FirewallRuleName $RuleName -ResourceGroupName $ResourceGroupName -ServerName $SqlSrv
        Write-Host "Creating Firewall Rule for IP: $ipAddress"
        #New-AzSqlServerFirewallRule 
        New-AzSqlServerFirewallRule @params
    }
    Else {
        Write-Host "Creating Firewall Rule for IP: $ipAddress"
        #New-AzSqlServerFirewallRule
        New-AzSqlServerFirewallRule @params
    }
}
Else { Write-Host "Rule Not Created. CreateFirewallRule: $CreateFirewallRule" }

#Token Function
Function Get-AADToken {
    [CmdletBinding()]
    [OutputType([string])]
    PARAM (
        [String]$TenantID,
        [string]$ServicePrincipalId,
        [securestring]$ServicePrincipalPwd
    )
    Try {
        # Set Resource URI to Azure Database
        #To Do --- Update to make for MAG and Commerical
        $resourceAppIdURI = 'https://database.windows.net'

        dlm-sqlsrv-dev.database.windows.net

        # Set Authority to Azure AD Tenant
        $authority = 'https://login.windows.net/' + $TenantId
        $ClientCred = [Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential]::new($ServicePrincipalId, $ServicePrincipalPwd)
        $authContext = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext]::new($authority)
        $authResult = $authContext.AcquireTokenAsync($resourceAppIdURI, $ClientCred)
        $Token = $authResult.Result.AccessToken
    }
    Catch {
        Throw $_
        $ErrorMessage = 'Failed to aquire Azure AD token.'
        Write-Error -Message 'Failed to aquire Azure AD token'
    }
    $Token
}

#region Connect to db using SPN Account
$SecureStringPassword = ConvertTo-SecureString -String $AppKey -AsPlainText -Force
$AccessToken = Get-AADToken -TenantID $TenantId -ServicePrincipalId $ServicePrincipalId -ServicePrincipalPwd $SecureStringPassword -OutVariable SPNToken -Verbose

# Set sqlpackage.exe dir: "C:\Program Files\Microsoft SQL Server\150\DAC\bin\sqlpackage.exe"
$sqlpackage = "$sqlpackagePath\sqlpackage.exe"

# set params
$dacpac = "$dacpacPath\$SqlDb.dacpac"
$srv = "$SqlSrv.database.windows.net"
$action = $PackageAction
$targetDB = $SqlDb
$OutputPath = "$ReportPath\DeploymentReports"
$ReportName = "DeployReport.xml"

#Create Deployment Report
#Ref for sqlpackage: https://docs.microsoft.com/en-us/sql/tools/sqlpackage?view=sql-server-2017#script-parameters-and-properties

If ($PackageAction -eq "DeployReport") {
    #Create Deployment Report Directory
    If (Test-Path $OutputPath) {
        Write-Host "$OutputPath Already Exists"
    }
    Else {
        New-Item -Path $OutputPath  -ItemType Directory
    } 

    Write-Host "Creating Deployment Report"
    &$sqlpackage `
        /a:$action `
        /sf:$dacpac `
        /op:"$OutputPath\$ReportName" `
        /tsn:$srv `
        /TargetDatabaseName:$targetDB `
        /AccessToken:$AccessToken

    #Create Schema Compare Script
    Write-Host "Creating Schema Compare Script"  
    $action = "Script"
    $ReportName = "DeployScript.sql"
    &$sqlpackage `
        /a:$action `
        /sf:$dacpac `
        /op:"$OutputPath\$ReportName" `
        /tsn:$srv `
        /TargetDatabaseName:$targetDB `
        /AccessToken:$AccessToken

    #Format XML Function
    function Format-Xml {
        <#
        .SYNOPSIS
        Format the incoming object as the text of an XML document.
        #>
        param(
            ## Text of an XML document.
            [Parameter(ValueFromPipeline = $true)]
            [string[]]$Text
        )
        
        begin {
            $data = New-Object System.Collections.ArrayList
        }
        process {
            [void] $data.Add($Text -join "`n")
        }
        end {
            $doc = New-Object System.Xml.XmlDataDocument
            $doc.LoadXml($data -join "`n")
            $sw = New-Object System.Io.Stringwriter
            $writer = New-Object System.Xml.XmlTextWriter($sw)
            $writer.Formatting = [System.Xml.Formatting]::Indented
            $doc.WriteContentTo($writer)
            $sw.ToString()
        }
    }

    Write-Host "
=================================================================================================
=================================================================================================
=================================================================================================

    Deploymnet Report                                         
    Report Format:      XML
    Report Location:    $OutputPath\DeployReport.xml                                               
    Target Server:      $srv                                
    Target Database:    $SqlDb

=================================================================================================
=================================================================================================
=================================================================================================
"
    Format-Xml (Get-Content "$OutputPath\DeployReport.xml")

    Write-Host "
=================================================================================================
=================================================================================================
=================================================================================================

    Deploymnet Script
    Description:        The following script outputs what changes will deploy via SQL script.
    Scipt Location:     $OutputPath\DeployScript.sql
    Report Format:      SQL                                               
    Target Server:      $srv                                
    Target Database:    $SqlDb

=================================================================================================
=================================================================================================
=================================================================================================
"
    Get-Content "$OutputPath\DeployScript.sql"
}

If ($PackageAction -eq "Publish") {
    Write-host "Publishing DACPAC to Server: $srv Database: $targetDB"
    &$sqlpackage `
        /a:$action `
        /sf:$dacpac `
        /tsn:$srv `
        /TargetDatabaseName:$targetDB `
        /AccessToken:$AccessToken
}
else {
    Write-host "Set action paramater to DeployReport or Publish"
}

#Remove Deployment Firewall Rule
If ($CreateFirewallRule) {
    Write-Host "Removeing Deployment Firewall Rule."
    #Remove-AzSqlServerFirewallRule
    Remove-AzSqlServerFirewallRule -FirewallRuleName $RuleName -ResourceGroupName $ResourceGroupName -ServerName $SqlSrv
}

