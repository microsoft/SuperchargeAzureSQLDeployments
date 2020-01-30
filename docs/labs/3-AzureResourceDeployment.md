## Lab 3 - Deploy Azure Resources
--------------------------------

[Back to all modules](/docs/labs/README.md)

| Lab Description:            | This lab covers all the steps needed to deploy Azure Resource with Azure DevOps pipelines.   |
| :------------                 | :--------------       |
| Estimated Time to Complete:   | 30 minutes            |
| Key Takeaways:                | By the end of this lab, you should have an understanding of: advanced ARM templates, how create build and release pipelines, how to deploy Azure Resources with DevOps, how to use PowerShell tasks and variables to make your pipelines more dynamic.         |
| Author(s):                    | Frank Garofalo             |

### Purpose
This lab is to build your foundational knowledge of how to leverage Azure DevOps to deploy Azure Resource with CI/CD pipelines.  This lab walks you through advanced ARM templates showing you how you can have an end state configuration for your Azure resource to limit the need to do post deployment configuration. You will create both a build and release pipeline which covers the CI/CD portions of DevOps.

 **Summary**
  * [Advanced ARM template](/docs/labs/3-AzureResourceDeployment.md#exercise---advanced-arm-template)
  * [Build pipeline (CI)](/docs/labs/3-AzureResourceDeployment.md#exercise---build-pipeline-ci)
    * [Configure the continuos integration](/docs/labs/3-AzureResourceDeployment.md#configure-the-continuos-integration-on-the-build-pipeline)
    * [Testing Azure resource CI pipeline](/docs/labs/3-AzureResourceDeployment.md#testing-azure-resource-ci-pipeline)
  * [Build release pipeline (CD)](/docs/labs/3-AzureResourceDeployment.md#exercise---release-pipeline-cd)
    * [Configure Key Vault deployment task](/docs/labs/3-AzureResourceDeployment.md#configure-key-vault-deployment-task)
    * [Configure SQL DB deployment task](/docs/labs/3-AzureResourceDeployment.md#configure-sql-db-deployment-task)
    * [Configure PowerShell task](/docs/labs/3-AzureResourceDeployment.md#configure-powershell-task)
    * [Configure Azure PowerShell task](/docs/labs/3-AzureResourceDeployment.md#configure-azure-powershell-task)
  * [Configure prod CI/CD pipelines](/docs/labs/3-AzureResourceDeployment.md#exercise---configure-prod-cicd-pipelines)
    * [Create & configure Prod build pipeline (CI)](/docs/labs/3-AzureResourceDeployment.md#create--configure-prod-build-pipeline-ci)
    * [Create & configure Prod release pipeline (CD)](/docs/labs/3-AzureResourceDeployment.md#create--configure-prod-release-pipeline-cd)
  * [Pull request](/docs/labs/3-AzureResourceDeployment.md#exercise---pull-request)
    * [Review Prod CI/CD](/docs/labs/3-AzureResourceDeployment.md#review-prod-cicd)

## <div style="color: #107c10">Exercise - Advanced ARM template</div>

### Launch VS Code

1. Open **sql_db.json** file
   1. Located in: **Deployments** > **ARM** > **templates**</br>

![](./imgs/sql_db.png)

1. Review lines **180 - 196** there are multiple example of how you can use functions in ARM templates to control behavior and maybe your deployments dynamic.
2. Review lines **376** - **410**, these resources are examples of how you can create multiple Firewall Range rules and/or vNet Firewall rules using copy index and a parameter array
3. Review lines **411** & **486** this is an example of how to use copy index to deploy multiple databases with the option of different SKUs for each DB  

   1. Also note that this resource uses a nested resource to perform some other configurations on each database like: ensure TDE is enabled, auditing is configured, and Security Alert Policies are set
   
4. This ARM template can be used to be deploy: Storage account, Log Analytics, SQL Logical Server, and multiple SQL DB(s). </br>

:bulb: You may see older schema versions this is because the template is designed to work in both Azure Commercial and Azure Government

5. Close **sql_db.json** without saving anything

#### Edit parameter file

1. Open **sql_db.parameter.dev.json** file
    1. Located in: **Deploymnets** > **ARM** > **parameter** </br>

![](./imgs/parameters.png)

1. Before making any changes to the parameter file spend some time reviewing it and reading through all of the comments.
   1. Each parameter has comments to help provide you with context of the value needed
   2. For this workshop you will only need to updated the values we call out, but are free to test other values outside of the workshop.

2. Enter name for **serverName**, line **27**
   1. The server name needs to be globally unique
   2. Recommend using: **\<alias>-sqlsrv-dev** (ie jdoe-sqlsrv-dev) </br>

![](./imgs/srvName.png)

4. Enter **serverADAdminGroup** at line **29** and **serverADAdminSID** at line **39**
   1. You can look up these values in Azure AD </br>

![](./imgs/serverAdmin.png) </br>

![](./imgs/parmAdmin.png)</br>

1. Enter **emailAddress** at line **162**

:exclamation: Email address for where you want Security Alerts and Vulnerability Assessment scans sent.

![](./imgs/email.png)

1. Save and close **sql_db.parameter.dev.json** file

#### Test deployment with PowerShell

1. Click **File** > **New File** or keyboard shortcut: *Ctrl + N*
2. Set File format to PowerShell

![](./imgs/PS1filetype2.png)

![](./imgs/PS1filetype.png)

![](./imgs/PS1filetype3.png)

3. Run the following to test your ARM deployment with PowerShell

```PowerShell
Login-AzAccount
#For Azure Government use:  
#Login-AzAccount -Environment AzureUSGovernment

#Select the correct Subscription
Select-AzSubscription –Subscription '<Id>'

$params = @{
    ResourceGroupName = '<enter your RG name>' #Dev Resource Group from lab 2
    TemplateFile = 'C:\SuperchargeSQLDeployments\Deployments\ARM\templates\sql_db.json'
    TemplateParameterFile = 'C:\SuperchargeSQLDeployments\Deployments\ARM\parameters\sql_db.parameters.dev.json'
    Verbose = $true
}
#Test ARM deployment
Test-AzResourceGroupDeployment @params 
```
Expended Result
> VERBOSE: time ran - Template is valid.

4. Run the following to deploy your ARM template with PowerShell
   
```PowerShell
$params = @{
    ResourceGroupName = '<enter your RG name>' #Dev Resource Group from lab 2
    TemplateFile = 'C:\SuperchargeSQLDeployments\Deployments\ARM\templates\sql_db.json'
    TemplateParameterFile = 'C:\SuperchargeSQLDeployments\Deployments\ARM\parameters\sql_db.parameters.dev.json'
    Verbose = $true
}

#Deploy ARM template
New-AzResourceGroupDeployment @params

#To Check Resources Deployed Run:
Get-AzResource -ResourceGroupName "<enter your RG name>" | Format-Table

```

5. You can check the status of your deployment from the portal
   1. Log into: [portal.azure.com](https:/portal.azure.com)
   2. Navigate to the Resource Group you deployed to
   3. Click on **Deployments** blade
   4. Click on **Related events** to view details about the deployment

![](./imgs/rgDeployment1.png)

![](./imgs/rgDeployment2.png)

6. Once deployment completes check that all resource deployed

![](./imgs/rgResources.png)

1. Close **Untitled-1** PowerShell file, no need to save
2. **Stage** & **Commit** any changes to your repo
3. **Sync** or **Push** your changes to your remote branch (Azure DevOps Repo)

## <div style="color: #107c10">Exercise - Build Pipeline (CI)</div>

In this exercise you will walk through all of the steps needed to create the Continuous integration (CI) portion of your Azure Resource deployment. This step is called the build process.  You will test that your ARM template build correctly.

1. In a browser window navigate to your DevOps project
2. Navigate to **Pipelines**
3. Click on **Pipelines**

![](./imgs/pipelines.jpg)

3. Click on **Create Pipeline**
4. Click on **Use the classic editor to create a pipeline without YAML**

![](./imgs/classiceditor.jpg)

5. Select a source
     1. Select **Azure Repos Git**
     2. Select the **Team project**
     3. Select **Repository**
     4. Select **dev** for Default branch for manual and scheduled builds
     5. Click on **Continue**
     
![](./imgs/sourcecode.png)

1. Select **Empty Job** at the top of the list

![](./imgs/emptyjob.png)

2. Update **Name** to: **Dev - Azure Resources-CI**
3. Leave defaults for **Agent Pool** & **Agent Specification**

![](./imgs/ci-agent.png)

4. Click on Agent job 1
5. Update **Display Name** to: **Publish Deployment Artifacts**
6. Keep all other defaults

![](./imgs/CI-AgentStepRename.png)

7. Click the + next to **Publish Deployment Artifacts**
8. Search for **Azure resource group** 
9. Click **Add** on the **Azure resource group deployment** task

![](./imgs/ci-ARM-task.png)

10. Click on the newly added **Azure resource group deployment** task and perform the following:
    1.  Update **Display name**: Validate Deployment ARM Templates for SQL DB
    2.  Select **Azure subscription** - You should see your Azure Service Connection that you setup earlier when configuring your DevOps environment.
    3.  **Action**: **Create or update resource group**
    4.  **Resource group**: Select your dev resource group that was setup in the pervious lab
    5.  **Location**: Select the location you used for your resource group
    6.  **Template location**: Linked artifact
    7.  **Template**: click on the ellipses and navigate to the **sql_db.json** template file to select it.
        1.  Your path should look similar to:
        
        >***Deployments/ARM/templates/sql_db.json***

    8.  **Template parameters**: click on the ellipses and navigate to the **sql_db.parameters.dev.json** template file to select it.
        1.  Your path should look similar to: 
        
        >***Deployments/ARM/parameters/sql_db.parameters.dev.json***

    9.  **Override template parameter**: leave blank for this step as we are only validating the ARM template, not deploying
    10. **Deployment mode**: Select **Validation only**
        1.  :exclamation: This is a key setting, as you only want to validate (test) your ARM template.
    11. Keep the rest of the settings as default.

![](./imgs/ci-sqldb-validate.png)

11.  Click the drop down arrow next to **Save & queue** 
12.  Select **Save**

![](./imgs/ci-save-build.png)

13.  Accept defaults for **Save build pipeline**

![](./imgs/ci-save-build2.png)

14.  Click **Save**
16.  Right click on **Validate Deployment ARM Templates for SQL DB** task, and select **Clone task**

![](./imgs/ci-clone-task.png)

17. Update the following setting for your newly cloned task
    1.  **Display name**: set it to **Validate Deployment ARM Templates for KeyVault**
    2.  **Tempate**: click on the ellipses and navigate to the **KeyVault.json** template file to select it.
        1.  Your path should look similar to: 
        
        >***Deployments/ARM/templates/KeyVault.json***

    3.  **Template parameters**: click on the ellipses and navigate to the **KeyVault.parameters.json** template file to select it.
        1.  Your path should look similar to: 
        
        >***Deployments/ARM/parameters/KeyVault.parameters.json***

18. Click the drop down arrow next to **Save & queue** 
19. Select **Save**
20. Click **Save** on the comment window (entering a comment here is optional)
21. Click the + next to **Publish Deployment Artifacts**
22. Search for **Publish build artifacts** 
23. Click **Add** on the **Publish build artifacts** task

![](./imgs/ci-publish-build-artfacts.png)

24. Edit the following setting on the **Publish Artifact** task
    1.  Set **Path to publish**: click on the ellipses and navigate to the **Deployments** directory in your repo.
![](./imgs/ci-publish-path.png)

    2. **Artifact name** change drop to: **Azure Resources**
    3. Keep all other settings to default
25. Click the drop down arrow next to **Save & queue**
26. Select **Save**
27. Click **Save** on the comment window (entering a comment here is optional)

### Configure the continuos integration on the build pipeline

1. Click on **Triggers** on the top menu of your build pipeline.
2. Check mark **Enable continuous integration** to automate your build
   1. This means when you check in your code the build will happen automatically
3. **Branch filters**
   1. **Type**: Include
   2. **Branch specification**: dev
4. **Path filters**
   1. Click **+Add**
   2. **Type**: Include
   3. **Path specification**: *Deployments*
   4.  Click **+Add**
   5.  **Type**: Exclude
   6.  **Path specification**: *DatabaseProjects*
   
:bulb: You are setting path filters for this pipeline, so it will only execute when code is checked in on your deployment directory.  This is where your ARM templates are located

5. Click the drop down arrow next to **Save & queue**
6. Select **Save**
7. Click **Save** on the comment window (entering a comment here is optional)

![](./imgs/ci-filter-build.png)

8. Click on **Options** at the top of your pipeline menu to edit some meta data for your build
9. Update the following **Build properties**
   1. **Description**: Build Pipeline for Azure Resource(s) Deployment
   2. **Build number format**:

    >\$(date:yyyyMMdd)_\$(BuildDefinitionName)_\$(SourceBranchName)\$(rev:.r)

10. Click the drop down arrow next to **Save & queue**
11. Select **Save**
12. Click **Save** on the comment window (entering a comment here is optional)

:bulb: You now have built and setup a working Continuos integrations pipeline for your Azure Resources in your dev branch.  This will be a CI pipeline used when developing and updating your ARM templates.  

### Testing Azure Resource CI pipeline

1. Click on Pipelines
2. Hover over your pipeline to expose and click on the ellipses
3. Click on **Run pipeline** (you are manually testing your build)

![](./imgs/ci-run-pipeline.png)

4. Keep default setting for **Run pipeline**
5. Click **Run**

![](./imgs/ci-run-pipeline2.png)

6. Click on Publish Deployment Artifacts under Jobs

![](./imgs/ci-run-pipeline3.png)

7. This is where you can view the status of your build and the logs generated durning run time. 
8. Once job finishes running you should see green check marks at each phase
9. Click on **View raw log** to view the full log of the build. Note this can be helpful when troubleshooting issues with failed builds.

![](./imgs/ci-view-logs.png)

10. You now have published artifacts that can be used in your dev continuous deployment (CD) (dev Release pipeline)

## <div style="color: #107c10">Exercise - Release Pipeline (CD)</div>
In this exercise you will walk through all of the steps needed to create the Continuous Deployment (CD) portion of your Azure Resource deployment.  This step is called the **Release**.  The release will be triggered from a successful build pipeline.

1. Inside of your Azure DevOps Project click on **Pipelines** > **Release** > **New Pipeline** button.

![](./imgs/cd-new-pipeline.png)

2. Select **Empty job**

![](./imgs/cd-emptyjob.png)

3. Set **Stage name**: ***Dev: Az Resource Deployment***
4. Click on the **X** to close Stage settings
5. Click on **New Release pipeline** to rename it to: **dev-AzureResouces-CD**
6. Click on **+ Add** on Artifacts
   1. Source type:  **Build**
   2. Project: **SuperchargeSQLDeployments** *(the name of your DevOps Project)*
   3. Source (build pipeline): **Dev - Azure Resources-CI** *(your build from last exercise)*
   4. Leave Source alias as the default value
   5. Click the **Add** button

![](./imgs/cd-artifacts.png)

5. Click on the **Lighting bolt** icon of Artifacts
6. **Continuous deployment trigger** flip the switch to **Enabled** </br>

:bulb: Note that this setting is what is used to enable the automation for Continuous deployment.  Which is triggered from a successful build.

7. **Build branch filters** click **+ Add**
8. Set build branch to **dev**

![](./imgs/cd-trigger.png)

9.  Click on **1 job, 0 task** in the Stages section of your release
10. Click on the **+** button on Agent job
11. Add the **Azure resource group deploymnet** task
12. Once added click on the task to configure with these settings:
    1.  Display name: **Clear Resource Group**
    2. Select **Azure subscription** - You should see your Azure Service Connection that you setup earlier when configuring your DevOps environment.
    3.  **Action**: **Create or update resource group**
    4.  **Resource group**: Select your dev resource group that was setup in the pervious lab
    5.  **Location**: Select the location you used for your resource group
    6.  **Template location**: Linked artifact
    7.  **Template**: click on the ellipses and navigate to the **empty-template.json** template file to select it.
        1.  Your path should look similar to:
        
        > ***$(System.DefaultWorkingDirectory)/_Dev - Azure Resources-CI/Azure Resources/ARM/templates/empty-template.json***

    8.  **Template parameters**: leave blank
    9.  **Override template parameter**: leave blank
    10. Deployment mode: **Complete** you will deploy this empty template in Complete mode to clear out your resource group.
    11. Expand **Control Option**
    12. Set **Run this task** to: **Custom conditions**
    13. Set **Custom condition** to: eq(variables['clearResources'], 'yes')
        * Using a variable to set when/if to clear Resource Group
    14. Click **Save** (Comment is optional) > **OK**

### Configure Key Vault deployment task

1. Add a New Azure resource group deployment task configured with the following:
  
    1. Display name: **Azure Deployment: Key Vault**
    2. Update:  **Azure subscription, Action, Resource group, Location, Template location** to match the same as the pervious Azure RG Deployment task
    3. Template: 
    
    >**$(System.DefaultWorkingDirectory)/_Dev - Azure Resources-CI/Azure Resources/ARM/templates/KeyVault.json** 

    4. Template parameters: 
    
    >**$(System.DefaultWorkingDirectory)/_Dev - Azure Resources-CI/Azure Resources/ARM/parameters/KeyVault.parameters.json** 
    
    5. Override template parameters:
   
```PowerShell
-keyVaultName "$(keyvault.VaultName)-$(rEnv)" 
-accessPolicies [
    {
        "objectId": "$(sp.ObjectId)",
        "tenantId": "$(sp.tenantId)",
        "metadata": {
            "description": "Service Principal - DevOps-DLM"
        },
        "permissions": {
            "keys": [
                "Get",
                "List",
                "Update",
                "Create",
                "Import",
                "Delete",
                "Recover",
                "Backup",
                "Restore"
            ],
            "secrets": [
                "Get",
                "List",
                "Set",
                "Delete",
                "Recover",
                "Backup",
                "Restore"
            ],
            "certificates": [
                "Get",
                "List",
                "Update",
                "Create",
                "Import",
                "Delete",
                "Recover",
                "ManageContacts",
                "ManageIssuers",
                "GetIssuers",
                "ListIssuers",
                "SetIssuers",
                "DeleteIssuers"
            ],
            "storage": [
                "Get",
                "List",
                "Update",
                "Set",
                "Delete",
                "Regeneratekey",
                "Recover",
                "Backup",
                "Restore"
            ]
        }
    }
] 
-tenant "$(sp.tenantId)" 
-location "$(location)" 
-enabledForDeployment false 
-enabledForTemplateDeployment true 
-enabledForDiskEncryption false

```
:exclamation: This overrides the values in your parameters file. It's best practice not to save protected credentials / settings in your Git repo. You will setup the variables and values once you have completed configuring your release tasks. </br>

   6. Deployment mode: **Incremental**
   7. Click **Save** (comment optional) > **OK**

### Configure SQL DB deployment task

1. Add a New Azure resource group deployment task configured with the following:
   1. Display name: **Azure Deployment: SQL Database**
   2. Update: **Azure subscription, Action, Resource group, Location, Template location** to match the same as the pervious Azure RG Deployment tasks
   3. Template:
   
    >**$(System.DefaultWorkingDirectory)/_Dev - Azure Resources-CI/Azure Resources/ARM/templates/sql_db.json** 

  
   4. Template parameters: 
   
    >**$(System.DefaultWorkingDirectory)/_Dev - Azure Resources-CI/Azure Resources/ARM/parameters/sql_db.parameters.dev.json**
            
   5. Override template parameters:

   > -serverName "\$(sql.serverName)-$(rEnv)"

   6. Deployment mode: **Incremental**
   7. Deployment outputs: **sql.Output**
   8. Click **Save** (Comment is optional) > **OK**

### Configure PowerShell task

1.  Click **+** on Agent job
2.  Search for **PowerShell**
3.  Click **Add** on the PowerShell tasks

![](./imgs/cd-powershell.png)

4. Click on the newly added PowerShell task and set the following:
   1. Task version: **2.\***
   2. Display name: **Parse SQL Database Outputs**
   3. Type: **File Path**
   4. Script Path:

   > $(System.DefaultWorkingDirectory)/_Dev - Azure Resources-CI/Azure Resources/Scripts/Parse-ARMOutputs.ps1

:bulb: This script is used to parse the output values of admin username and password from your SQL DB deployment.  It writes the output values to variables which will later be written back to Key Vault. This is often a technique used to move values around in a pipeline. The script is:

```PowerShell
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

```
   4. Arguments:

> -ARMOutput '$(sql.Output)'

   5. Click **Save** (Comment is optional) > **OK**

### Configure Azure PowerShell task

1.  Click **+** on Agent job
2.  Search for **Azure PowerShell**
3.  Click **Add** on the Azure PowerShell tasks

![](./imgs/cd-azpowershell.png)


4. Click on the newly added Azure PowerShell task and set the following:
   1. Task version: **4.\***
   2. Display name: **Key Vault write Resource Keys**
   3. Azure Connection Type: **Azure Resource Manager**
   4. Azure Subscription: **Set this to your Service Connection** (perviously setup in Configuring your DevOps Environment lab)
   5. Script Type: **Script File Path**
   6. Script Path:

   > $(System.DefaultWorkingDirectory)/_Dev - Azure Resources-CI/Azure Resources/Scripts/KeyVault-WriteSecrets.ps1

   :bulb: This script is used to write the SQL admin account info to your Key Vault. Take a minute to review the script so you understand what is is doing:

```PowerShell

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
    
```
   7. Script Arguments:

> -kVaultName "\$(keyvault.VaultName)-\$(rEnv)"</br>
> -ResourceGroup \$(ResourceGroup)$(rEnv)</br>
> -adminLogin $(sql.Login)</br>
> -adminPass $(sql.Pass)</br>

   8. Azure PowerShell Version: **Latest installed version**
   9. Click **Save** (Comment is optional) > **OK** </br>

:exclamation: At this point your Release pipeline's **Tasks** should look like this:

![](./imgs/cd-tasks.png)

### Configure Variables

You need to configure and set the values of your variables that will be used in this release pipeline.  Variables are used to make your pipelines more flexible and dynamic.

1. Click on the **Variables** section of your pipeline
2. Create the following **Pipeline variables**

    |Name           |Value  |
    |:---           |:---   |
    |clearResources | no   |
    |rEnv           | dev   |

3. Click **Save** (Comment is optional) > **OK**
4. Click on **Variable groups** (these are variables that can be shared throughout any pipeline in your project)
5. Click on **Manage variable groups** (this will open a new browser tab)
6. Click **+ Variable group**

![](./imgs/cd-variablegroup.png)

7. Variable group name: **SuperchargeSQL-Vars**
8. Description: **Variables used for Supercharge SQL deployments**
9. Allow access to all pipelines: **turn on switch**
10. Click **+ Add** > Add the following Variables:

    |Name                   |Value                | ![](./imgs/icon-lock.png) |
    | :---                  |:---                 | :---   |
    | keyvault.VaultName    | {your alias}-vault | ![](./imgs/icon-unlock.png) |
    | ResourceGroup         | SuperchargeSQL-       | ![](./imgs/icon-unlock.png) |
    | sp.DisplayName        | {your Service Princple Name} | ![](./imgs/icon-unlock.png) |
    | sp.ObjectId           | {same location as RG} | ![](./imgs/icon-unlock.png)   |
    | sp.tenantId           | {your tenantID} | ![](./imgs/icon-unlock.png)   |
    | sql.databaseName      | ["trainingDW"] | ![](./imgs/icon-unlock.png)   |
    | sql.Login             | leave blank | ![](./imgs/icon-unlock.png)   |
    | sql.Pass              | leave blank | ![](./imgs/icon-lock.png)   |
    | sql.serverName        | {your alias}-sqlsrv | ![](./imgs/icon-unlock.png) |
    | sql.Output            | leave blank | ![](./imgs/icon-unlock.png) |
    | location           | eastus2  | ![](./imgs/icon-unlock.png) |

:exclamation: **To get the correct sp.ObjectID use the below PowerShell**

```PowerShell
Login-AzAccount
#For Azure Government use:  
#Login-AzAccount -Environment AzureUSGovernment

$sp = Get-AzADServicePrincipal -DisplayName '<use your Service Principle Name>'

$sp.Id
```


11. Click **Save**
12. Your **Variable group** should look similar to this:

![](./imgs/variable-group.png)

13. Close the Library tab and navigate back to the open browser tab with your **Release**
14. Click on **Variables** > **Variable groups** > **Link variable group**
15. Select your Variable group created in the pervious steps: **SuperchargeSQL-Vars**
16. Click the **Link** button
17. Click **Save** (Comment is optional) > **OK**
18. Click **Create release** to manually trigger 
19. Select Stages for a trigger... : **Dev: Az Resource Deployment**
20. Click **Create** button
21. CLick on Release **Release-\<num>** has been created

![](./imgs/cd-release.png)

22. If you get a popup window about the new improvement to the release summary page feel free to close or review for more information
23. Notice that in **Stages** it says **Not deployed** this is because it was manually triggered 
24. Hover over **Dev: Az Resource Dep** to expose the **Deploy** button > Click it

![](./imgs/cd-deploy.png)

25. Comment is optional > Click **Deploy**
26. Click on **In progress** to view status of deployment
    1.  You can also navigate to your resource group in Azure and view status of the deployment on the Deployments blade

:exclamation:  If you want to clear your Resource Group durning this **dev** stage set the **clearResources** variable to **yes**. Since this would meet the custom condition you will be  deploying an "empty" template in Complete mode. Which will clear out your resource group (delete all resource not in your template).  This can take a bit of time and even timeout to complete.  While you are waiting for your Release to complete, review the logs as it deploys, or feel free to move on with the next steps in this lab. Don't forget to check status and address any errors.

**Expected Results**:

![](./imgs/cd-result1.png)

![](./imgs/cd-result2.png)

:bulb: At this point in the workshop you have successfully created a full CI/CD dev pipeline which can be used develope and deploy Azure Resources. If you make changes to your ARM templates or parameter files located in the *Deployment* directory and push the changes to your remote Azure DevOps repository your build and release will happen automatically.  This keeps you and your development team from having to make changes via the portal.  You now have the ability to collaborate and perform rapid development with change logged via Git, and the ability to roll back / roll forward as needed.

## <div style="color: #107c10">Exercise - Configure Prod CI/CD pipelines</div>

:bulb: In this exercise you will walk through the steps to configure your production release pipelines.  Your prod pipeline will use the code from your master branch, require approval to deploy, and can only be run via changes to your **master** branch via **pull request**.

### Create & configure Prod build pipeline (CI)

1. In your Azure DevOps project navigate to **Pipelines** > **Pipelines**
2. Click on your pipeline **Dev - Azure Resources-CI**
3. Click on the ellipses in the top right corner next to the Run pipeline button
4. Select **clone**
5. Rename **Dev - Azure Resource-CI-clone** to **Prod - Azure Resource-CI** by click on the name
6. Click on **Get sources** under the Tasks section of the pipeline
7. Change your **Default branch for manual and scheduled builds** to: master

![](./imgs/ci-sources-prod.png)

8. Update both of the **Azure resource group deployment** task to:
   1. Resource group: {select your prod resource group} **SuperhcargeSQL-prod**
9.  Click on **Triggers**
10. Update Branch filters: set to **master**
11. Click the down arrow next to **Save & queue** (Comment is optional) > **Save**
12. You now have a **Prod** CI pipeline for your Azure Resources that will be tirggered when changes are committed to your **master branch**

### Create & configure prod release pipeline (CD)

1. In your Azure DevOps project navigate to **Pipelines** > **Releases**
2. Click on your **Dev** CD pipeline:  **dev-AzureResources-CD**
3. Click on the ellipses in the top right corner next to the Create release button
4. Select **clone**
5. Rename **dev-AzureResouces-CD - Copy** to **prod-AzureResouces-CD** by click on the name
6. Click on **_Dev - Azure Resources-CI** in the **Artifacts** section of Pipeline
7. Click **Delete** > **Confirm**
8. Click **Add an artifact**
9. Set **Source (build pipeline)** to: **Prod - Azure Resources-CI**
10. Click **Add**
11. Turn on **Continuous deployment trigger** and added a **Build branch filter** for **master**
    1. Hint: you did this step when you setup your dev release pipeline
12. Click into the tasks of **Dev:Az Resource ...**
13. Update each **Azure resource group deployment task** settings to:
    * **Clear Resource Group Task** > **Template**: 
    > $(System.DefaultWorkingDirectory)/_Prod - Azure Resources-CI/Azure Resources/ARM/templates/empty-template.json

    * **Azure Deployment: Key Vault** > **Template**: 
    > $(System.DefaultWorkingDirectory)/_Prod - Azure Resources-CI/Azure Resources/ARM/templates/KeyVault.json

    * **Azure Deployment: Key Vault** > **Template parameters**: 
    > $(System.DefaultWorkingDirectory)/_Prod - Azure Resources-CI/Azure Resources/ARM/parameters/KeyVault.parameters.json

    * **Azure Deployment: SQL Database** > **Template**: 
    > $(System.DefaultWorkingDirectory)/_Prod - Azure Resources-CI/Azure Resources/ARM/templates/sql_db.json

    * **Azure Deployment: SQL Database** > **Template parameters**: 
    > $(System.DefaultWorkingDirectory)/_Prod - Azure Resources-CI/Azure Resources/ARM/parameters/sql_db.parameters.dev.json

14. Update the **PowerShell** task settings to:

    * **Script Path**: 
    > $(System.DefaultWorkingDirectory)/_Prod - Azure Resources-CI/Azure Resources/Scripts/Parse-ARMOutputs.ps1

15. Update the **Azure PowerShell** task settings to:

    * **Script Path**: 
    > $(System.DefaultWorkingDirectory)/_Prod - Azure Resources-CI/Azure Resources/Scripts/KeyVault-WriteSecrets.ps1

16. Click **Save** (Comment is optional) > **OK**
17. Click on the **Pipeline** section
18. Hover over **Dev:Az Resource ...**
19. Click **Clone**
20. Click into **Copy of Dev: Az R...** stage to edit the tasks
21. Rename the stage from **Copy of Dev: Az Resource Deployment** to: **Prod: Az Resource Deployment**
22. Update each Azure resource group deployment task's settings to:
    * Set **Resource group** to: {your prod resource group} **SuperchargeSQL-prod**
23. Click on the **Variables** section of the pipeline
24. Update the variable **rEnv**: Set Scope to **Dev: Az Resource Deployment**
25. Add a new variable **rEnv**
    * Value: **prod**
    * Set Scope to **Prod: Az Resource Deployment**

Your Pipeline variables should look like this:
![](./imgs/cd-release-vars.png)

26. Click **Save** (Comment is optional) > **OK**

**Add deploymnet approval to the prod deployment**
1. Navigate back to the Pipeline section of **prod-AzureResouces-CD**
2. Click on lighting bolt icon on the **Prod: Az Resource...** stage
3. Leave **Triggers** with default settings
4. Enable **Pre-deployment approvals**
    * Approvers: **Add yourself as Approver**
    * This setting means you have to approve this stage of the deployment. This is why you deploy to dev again. It give you a chance to check your deployment from your master code against an environment that does not effect prod. Once you verify deployment is as expect you can approve the prod deployment. 
5. Click **Save** (Comment is optional) > **OK**
6. You now have successfully configured a prod release pipeline for your Azure Resources

## <div style="color: #107c10">Exercise - Pull request</div>

In this exercise you will walk through creating a pull request. This is the process to merge your dev code into your master branch.  At which point it will trigger your Prod CI/CD process. This is an example of how you can release changes into your production environment.

1. Navigate to your Azure DevOps project > **Repos** > **Pull requests**
2. Click on the **New pull request** button
3. Fill out the Pull Request form setting the values to:
   1. Provide a Title for the pull Request: **Supercharge Azure SQL initial prod release**
   2. Description: **Dev to master code merge, release azure resources into prod environment**
   3. Reviewers: {locate yourself to approve request}
   4. Click the **Create** button
4. Review the pull request
   1. Notice that you have an **Active** Pull Request
   2. Note that the changes dev to master merge will not complete until all **Polices** have be satisfied

![](./imgs/pr-active.png)

   3. Take a minute to review the **Files** tab where you can see a side-by-side diff of dev to master

![](./imgs/pr-compare.png)

   4. Click the **Approve** button
   5. Click the **Complete** button
   6. Enter a Merge commit comment: **Merged PR 1: Supercharge Azure SQL initial prod release**
   7. Click Merge type drop down to review and read the different types
      1. For this lab pick:**Merge (no fast-forward)**
   8. Un-check **Delete dev after merging**
      1. We do not want to lose our dev branch for this workshop we are working with a persistent dev branch
    
![](./imgs/pr-complete.png)

   9. Click the **Complete merge** button

5. At this point you have completed the steps to perform a **Pull Request**

### Review Prod CI/CD

1. Navigate to **Pipelines** > **Pipelines**
2. You will now see both you Prod and Dev Pipelines
   1. Click into Prod to review the status of your build and the logs
3. Navigate to **Pipelines** > **Releases**
   1. You should see both your dev and prod Release pipelines
      1. If you do not see your prod it could be because your build as not completed and triggered your release. 
   2. Click into your Prod release pipeline to review status and logs
   3. Notice that once your Dev Stage completes you will need to approve the deployment into prod.

![](./imgs/prod-release1.png)

4. Navigate to Azure via the portal and check that all your resources in Resource Group: **SuperchargeSQL-dev** deployed correctly 
5. You should also receive an email to approve the Prod stage of your release that looks similar to this:

![](./imgs/prod-email.png)

6. Navigate to your Azure DevOps project > **Pipelines** > **Releases**
7. Click on release: **prod-AzureResource-CD**
8. Click on the **Prod** stage
9. Enter a Comment for approval
10. Click **Approve**
11. Click the **X** to close the Approval comment window

![](./imgs/prod-approve.png)

12. Click into the prod stage to review status and logs for your prod deployment
    1.  Note this could take a little bit of time to deploy all of the new Azure Resource in your prod Resource Group
13. Navigate to Azure via the portal and check that all your resources in Resource Group: **SuperchargeSQL-prod** deployed correctly
    1.  Remember you can also check the status of your deployment from the **Deployments** blade of your Resource Group

:exclamation: You have not completed lab three.  You should have a full working CI/CD pipelines for dev and prod, and have a good understand of how to create your own CI/CD pipelines to deploy Azure Resources with ARM templates. Please move on to the next lab in this workshop.

- [Next Lab](/docs/labs/4-DatabaseLifecycleManagement)
- [Back to all modules](/docs/labs/README.md)
___
___
**Azure subscriptions**

<ins>TRIAL SUBSCRIPTIONS ARE NOT SUPPORTED FOR THIS WORKSHOP</ins>