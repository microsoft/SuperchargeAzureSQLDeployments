## Lab 2 - Configure your DevOps Environment
--------------------------------

[Back to all modules](/docs/labs/README.md)

| Lab Description | This lab covers the configurations and environment creation for DevOps deployments. |
| :------------ | :-------------- |
| Estimated Time to Complete | 20 minutes |
| Key Takeaways | 1. Create resource group in Azure  for deployment automation |
|  | 2. Establish RBAC permissions for resource creation |
|  | 3. Set up permissions and service principals for continuous deployments in Azure DevOps environment |
|  | By the end of this lab, you should have: Resource Groups, Service Principal, ARM Templates, Azure DevOps Environment
| Author | Shirley MacKay </br> Frank Garofalo|

### Purpose

This lab will create the environment for the CI/CD process. Service Principals are leveraged to allow permission to deploy or update resources in a certain environment for a specific purpose. The Service Connections are based off the Service Principals permissions that is limited to what is required for updates and deployments of the resources. It gives Administrators better control over their environment while allowing the engineers to have concern with only their code.
 
 **Summary**
  * [Setup Up Azure Environment](#exercise---setup-azure-environment)
  * [Azure AD Service Principal](#exercise---setup-permissions)
  * [Set up Azure DevOps Environment](#exercise---set-up-azure-devops-environment)


## <div style="color: #107c10">Exercise - Setup Azure Environment</div>

### Create Azure Resource groups

```diff 
# Perform the tasks below either via the Portal or PowerShell.
# Create two Resource groups one for Dev and one for Prod
# Example naming convention: <name>-prod, <name>-dev
```

> #### **Portal**
1. Login to **https://portal.azure.com**
2. Select **Resource Groups** from the main menu

<img src="./imgs/resourcegoup.jpg" width="50%" height="50%" />

**create two resource groups:** </br>
         \<name>-prod</br>
         \<name>-dev</br>
         *Replace \<name> with the name you would like to use*
1. Click **+ Add**
   1. Select the **Subscription**
   2. Enter the **Resource Group** name *(example: sqldb-dev)*
   3. Select the **Region**
   4. Click **Review + create**
   5. Click **Create**

> #### **PowerShell**
**create two resource groups:** </br>
         \<name>-prod</br>
         \<name>-dev</br>
         *Replace \<name> with the name you would like to use*

```powershell  
$rg = "<Your Resource Group Name>" #Example: sqldb-dev & sqldb-prod
$location = "<Location>"

Login-AzAccount
#For Azure Government use:  
#Login-AzAccount -Environment AzureUSGovernment

Select-AzSubscription –Subscription '<Id>'
New-AzResourceGroup -Name $rg -Location $location
Get-AzResourceGroup -Name $rg
``` 

:bulb: Use the following cmdlets to obtain the subscription id and region
```powershell  
Get-AzSubscription
Get-AzLocation
``` 


### Create Service Principal

```diff 
# Perform the tasks below either via the Portal or PowerShell.
```

> #### **Portal**

1. Login to **https://portal.azure.com**
2. Select **Azure Active Directory** from the main menu </br>
<img src="./imgs/ad.jpg" width="50%" height="50%" />

3. Select the **App Registrations** blade
4. Select **+ New registration**
   1. Enter the **Name**
   1. Leave the defaults
   1. Click **Register**

On the **App Registrations > <Your App Name>** blade
 
 1. Select the **Certificates & secrets** blade
	   1. Select the **+ New client secret** 
	   1. Enter the **Description**
	   1. Click **Add**
	   1. Copy the **Value**



> #### **PowerShell**
```powershell  
Login-AzAccount
#For Azure Government use:  
#Login-AzAccount -Environment AzureUSGovernment

Select-AzSubscription –Subscription '<Id>'

$spName  = '<Service Principal Name>'
$id = (New-Guid).Guid
$pass = (New-Guid).Guid

$cred = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential
$cred.StartDate = Get-Date
$cred.EndDate = (Get-Date).AddYears(1)
$cred.KeyId = $id
$cred.Password = $pass
New-AzADServicePrincipal -DisplayName $spName -PasswordCredential $cred

$pass
``` 

:exclamation: Copy and save the Service Principal Name, ApplicationId and the Key which is the value from the $pass variable. It will be used later. 


## <div style="color: #107c10">Exercise - Setup Permissions</div>

### Access Control (IAM) for the Resource Group
```diff 
# Perform the tasks below either via the Portal or PowerShell.
```
> #### **Portal**

Go to the resource group that was created earlier
1. Click on the **Access control (IAM)** blade
2. Click on **+ Add**
3. Click on **Add role assignment**
     1. Select the **Owner** role
     2. Enter your Service Principal name in the **Select** box to search
     3. Click **Save**
4. Click on **Role Assignments** to verify

> #### **PowerShell**
```powershell  
Login-AzAccount
#For Azure Government use:  
#Login-AzAccount -Environment AzureUSGovernment

Select-AzSubscription –Subscription '<Id>'

$spName  = '<Service Principal Name>'
$rg = "<Your Resource Group Name>"

$app = (Get-AzADServicePrincipal -DisplayName $spName).ApplicationID
New-AzRoleAssignment -ApplicationID $app -ResourceGroupName $rg -RoleDefinitionName 'Owner'
``` 

## <div style="color: #107c10">Exercise - Set up Azure DevOps Environment</div>


#### Azure DevOps Organizations

1. Sign in **https://dev.azure.com/**
2. Navigate to Azure DevOps after signing in
3. Click on **New Organization**
     1. Confirm and Enter an **organization** name
         *  The organization name is a DNS name therefor it must be globally unique.  
     2. Choose a **Location**
4. After creation, navigate to your organization **https://dev.azure.com/{yourorganization}**


#### Azure DevOps Project - ![](docs/../imgs/Git-Icon.png)Clone Project Repo
1. Enter your **Project name**
2. Enter Description (optional)
3. Select **Private**
4. Expand the Advanced options
5. Select **Git** and **Basic** for version control and work item process, respectively. 
6. Click on **+ Create project**

<img src="./imgs/newproject.jpg" width="50%" height="50%" />

5. Click on **Repo**

<img src="./imgs/repo.jpg" width="25%" height="25%" />

6. Click on **Initialize**</br>
*Defult settings to include Add a README*
<img src="./imgs/RepoInitialize.png" width="75%" height="75%" />

## Branching
There are many options for a branching strategy and Git gives you the flexibility in how you use versions control to share and mange code.  It is an imporant part of DevOps and your strategy is somthing that your team should come up with.  For more information about branching strategies please review [Adopt a Git branching stategy](https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops) docs page. For this workshop we are going to work with just a *dev* and *master* branch.

1. Click on Repos to expand the **Repos** sub menu
2. Click on sub menu **Branches**</br>
     *Notice that your Repo only has a **master** branch, by defualt new Git Repos only have a **master** branch*</br>

<img src="./imgs/ReposBranchs.png">

3. Click **New branch** 
4. Enter Name: **dev**
5. Click **Create**
6. Click on the elipse on the **master** branch to expose more options
7. Click **Branch plicies**
   
<img src="./imgs/RepoBranchPolicies.png" width="75%" height="75%" />

8. You are now going to set a policy to Protect your **master** branch</br>
*This is to keep people from accidentally checking dev code into master/prod branch*
1. Select **Require a minimum number of reviewers**
2.  Change the minimum nuymber of reviewers to **1**
3.  Select **Requestors can approve their own changes**
4.  Save changes

<img src="./imgs/RepoMasterBranchPolicies.png" width="50%" height="50%"  />

5. Click on **Branches**
6. Notice that your master branch, now has a Branch Policy icon on it. 

<img src="./imgs/RepoMasterBranchPoliciesIcon.png" width="50%" height="50%" />

## DevOps Service Connection with Azure Resource Manager

1. Select the **Project Settings**

<img src="./imgs/projectsettings.jpg" width="25%" height="25%" />

2. Select **Service Connections** under **Pipelines**
3. Click on **Create service connection**
4. Select **Azure Resource Manager**

<img src="./imgs/serviceconnection.jpg" width="50%" height="50%" />

5. Click on **Next**
6. Select **Service principal (manual)**

<img src="./imgs/ServiceConnection.png" width="50%" height="50%"></br>
>  If you do not use manual, Azure DevOps will attempt to use your currently logged in Azure DevOps credentials to create a new Service Principal and give it rights to the subscription, instead of using the one we just created.

Enter the following:
1. Select Environment
2. Select Scope level **Subscription**
3. Enter **Subscription Id**</br>
     ```PowerShell
     Get-AzSubscription
     #Returns Subscription Name, Id, TenantId and State
    ```
4. Enter **Subscription Name**
5. Enter **Service Principal ID** (Created earlier)
6. Select Credential **Service principal key**
8. Enter **Service principal key** (Value noted earlier)
9. Tenat ID should be prepopulated
10. Click on **Verify**
11. Enter **Service connection name**
12. Enter **Description** (optional)
13. Click on **Verify and save**
___     
- [Next Lab](/docs/labs/3-AzureResourceDeployment.md)
- [Back to all modules](/docs/labs/README.md)
___
___
**Azure subscriptions**

<ins>TRIAL SUBSCRIPTIONS ARE NOT SUPPORTED FOR THIS WORKSHOP</ins>