## Lab 3 - Deploy Azure Resouces
--------------------------------

[Back to all modules](/docs/labs/README.md)

| Lab Description:            | This lab covers all the steps needed to deploy Azure Resource with Azure DevOps pipelines.   |
| :------------              | :--------------       |
| Estimated Time to Complete: | 30 minutes            |
| Key Takeaways:              | 1. Understand Adanvced ARM templates |
|                            | 2. Create CI/CD pipelines            |
|                            | By the end of this lab, you should have an understanding of: advanced ARM templates, how create build and release pipelines, how to deploy Azure Resources with DevOps         |
| Author(s):                     | Frank Garofalo             |

### Purpose
This lab is to build your foundational knowledge of how to leverage Azure DevOps to deploy Azure Resource with CI/CD pipelines.  This lab walks you through advanced ARM templates showing you how you can have an end state configuration for your Azure resource to limit the need to do post deployment configuration. You will create both a build and release pipeline which covers the CI/CD portions of DevOps.

 **Summary**
  * [Review Adanced ARM templates]({summerylinke})
  * [{summary link}]({summerylinke})
  * [{summary link}]({summerylinke})

## <div style="color: #107c10">Exercise - Review Adanced ARM templates</div>

### Review 

1. Navigate to **Pipelines**
2. Click on **Pipelines**

<img src="./imgs/pipelines.jpg" width="25%" height="25%" />

3. Click on **Create Pipeline**
4. Click on **Use the classic editor to create a pipeline without YAML**

<img src="./imgs/classiceditor.jpg" width="25%" height="25%" />

5. Select a source
     1. Select **Azure Repos Git**
     2. Select the **Team project**
     3. Select **Repository**
     4. Select **master** for Default branch for manual and scheduled builds
     5. Click on **Continue**
     
<img src="./imgs/reposource.jpg" width="50%" height="50%" />

6. Select **Empty Job** at the top of the list
7. Select **Save** from the drop down menu
8. Select the default folder and click **Save**
