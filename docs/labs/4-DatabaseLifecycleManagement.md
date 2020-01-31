## Lab 4 - Database life cycle management (DLM)
--------------------------------

[Back to all modules](/docs/labs/README.md)

[comment]: <> (Lab header table provide values for lab)

| Lab Description:            | This lab covers all the steps needed to deploy Azure Resource with Azure DevOps pipelines.   |
| :------------               | :--------------              |
| Estimated Time to Complete: | 60                          |
| Key Takeaways:              |By the end of this lab, you should have an understanding of: SSDT DB Projects, How create build and release pipelines to deploy schema changes, Database Unit Testing, and leverage the power of sqlpackage.exe    |
| Author(s):                     | Frank Garofalo             |

[comment]: <> (Write up purpose for this lab, provide some info on the what and why) 
### Purpose

The purpose of this lab is to take the skils you have learned so far and apply them to Database life cycle management (DLM). This lab walks you through the concepts of a database project in Visual Studio, how to setup and use a CI/CD process for rapid development, unit testing and change control.  

 **Summary**
  * [{summary link}]({summerylinke})
  * [{summary link}]({summerylinke})
  * [{summary link}]({summerylinke})

[comment]: <> (Main Exercise format) 
## <div style="color: #107c10">Exercise - Review SSDT database project</div>

In this exercise you are going to review a database project for a simple database.  

### Initial SSDT project setup
 
1. Launch Visual Studio 2019
   1. If this is the first time launching Visual Studio it may ask you to sign in. If you have an MSDN account we recommend signing in. If not feel free to select *Not now, maybe later.* 
   2. You may also be asked pick development Settings and a color theme.  We recommend General and the theme of your choice. 
2. Click on **Open a project or solution**
3. Navigate to: **C:\SuperchargeSQLDeployments\DatabaseProjects\trainingDW**
4. Select the solution file: **trainingDW.sln**
5. Click on **master** in the bottom right corner > **Manage Branches**
   
![](./imgs/ssdt-master.png)

6. Expand **remotes/origin** > select **dev** (you may need to dbl click to select it)
   1. **dev** should now be in your local Git dir
   
![](./imgs/ssdt-dev.png)

:bulb: Just like in VS Code you want to be developing and editing in your **dev** branch.  **Master** only gets updated from pull requests.

### Get to know SSDT database projects
1. In the **Solution Explorer** right click on **trainingDW** > **Properties**
   1. From here you can set and configure settings for your project
   2. Notice your **Target platform:** is set to **Microsoft Azure SQL Database**
   3. Click on the arrow to view other Target platforms available (leave it as Azure SQL DB)
2. Click on the **Database Settings...** button

![](./imgs/ssdt-db-settings.png)
   
3. Click through the **Common**, **Operational**, and **Miscellaneous** tabs
   1. Notice that **Database collation** is the only setting you can change. This is because your target platform is set to **Microsoft Azure SQL Database**
   2. Spend a couple minutes changing the Target Platform and then reviewing the **Database Settings...** that are available to configure
   3. Make sure to set **Target platform:** back to **Microsoft Azure SQL Database**
4. Close the **trainingDW Project Setting**
5. In the **Solution Explorer** expand **trainingDW**
6. Expand folder **dim**
   1. Notice the folder structure: Tables, Views
   2. Database projects are designed to work in a folder structure to organize your schema, similar to what you see via SSMS
   3. Expand **dim** > **Tables**
   4. Notice how each file is named: **schema.tableName.sql** (each database object is stored as a SQL script)
   5. Click on **dim.Attendee.sql** to open it.
   6. Spend a minute to review (you can edit in the designer or T-SQL)

![](./imgs/ssdt-tablescript.png)

7. Close **dim.Attendee.sql**
8. Right click on **dim.Attendee.sql** > Hover over Refactor

![](./imgs/ssdt-refactor1.png)

9. Note the options you can use to refractor your scripts
10. Click on **Fully-qualify Names..**
11. Review how this option can quickly refactor your script to use *Fully Qualified Names*
12. Click **Cancel**

![](./imgs/ssdt-refactor2.png)

13. From the main Visual Studio menu bar click **View** > **SQL Server Object Explorer**

![](./imgs/ssdt-sqlexplorer.png)

14. Expand **Projects - trainingDW** > **Tables** > Right click on: **dim.Attendee**
15. Hover over **Refactor**
16. Notice you have additional refactoring options
    1.  Feel free to click through each to see how they work (**do not apply the changes**)

![](./imgs/ssdt-refactor3.png)

17. Close any open windows
18. Open file: **trainingDW.refactorlog** from **Solution Explorer**
    1.  Note that all refactored changes are logged and can be reviewed. This is a nice option to have if you need to check what changed in your database quickly from the last deployment.
    2.  Close **trainingDW.refactorlog**

### Build your database project

1. From the **Solution Explorer** right click on **trainingDW** > Click on **Build**

![](./imgs/ssdt-build.png)

2. Expected Result

![](./imgs/ssdt-build-result.png)

:exclamation: In order to deploy database projects it has to be able to build.  When the project builds it generates a **dacpac** which is used by sqlpackage.exe to deploy schema.  

3. User the **SQL Server Object Explorer** expand **SQL Server** > (localdb)\ProjectsV13... > **Databasses**
4. After a successfully **build** you will have a local version of your database which you can use for local testing.

![](./imgs/ssdt-localdb.png)

5. Expand **trainingDW** > **Tables**
   1. Notice there are no tables or any schema in this local version.
   2. The build process only creates a blank database
6. From the **Solution Explorer** > Right click on **trainingDW** > **Schema Compare...**
7. Your source should be pre-populated with the DB project
8. Click on the drop down arrow next to ***Select Target*** > **Select Target**

![](./imgs/ssdt-compare-target.png)

9. Select Target Schema > Database: > Select Connection

![](./imgs/ssdt-select-target.png)

10. Click on the **Browse** Tab
11. Expand **Local** > **ProjectsV13**
12. Set Database Name: **trainingDW**
13. Click **Connect**

![](./imgs/ssdt-localdb-connection.png)

13. Click **OK** on **Select Target Schema** window
14. Click on the **Gear** icon from the Compare menu

![](./imgs/ssdt-compare-gear.png)

15. Clink on the **General** and **Object Types** tabs and review the options you can enable/disable for your schema compare.
16. Leave all values default > Click **Cancel**
17. Click **Compare** 
18. Review results
19. Click the **Update** button > **Yes**
20. From **SQL Server Object Explorer** review the **trainingDW**
    1.  Notice that now all of your schema changes from your DB project is updated in your local version of **trainingDW**
    2.  This is a light weight way to test your development before committing changes to Git and pushing to Azure DevOps
21. Close **SQLSchemaCompare** > **Don't Save**

### Load data your local DB

1. From **Solution Explore** 
2. Expand the **Scripts** folder > dbl Click on **LoadDateDim.sql**
3. Notice you are connected to the local copy of **trainingDW**

![](./imgs/ssdt-load-data.png)

4. Execute script
  
![](./imgs/ssdt-execute-script.png)

5. Close **LoadDateDim.sql**
6. From **SQL Server Object Explorer** > right click on **trainingDW** > **New Query**

![](./imgs/ssdt-localdb-query.png)

7. Execute the below T-SQL to test that your script loaded the dim.date
  
  ```T-SQL

  Select count(*) as dimDateCount From dim.Date

  Select top 10 * From dim.Date

  ```

:bulb: This is a easy way to test scripts locally before you deploy changes to your Azure dev environment.

1. Close **SQLQuery1.sql** > **Don't Save**

## <div style="color: #107c10">Exercise - Dev Database Build Pipeline (CI)</div>

1. Using a browser navigate to your Azure DevOps project
2. Navigate to**Pipelines** > **Pipelines**
3. Click the **New pipeline** button
4. Click on **Use the classic editor**
5. Select a source: **Azure Repos Git**
6. Set **Default branch for manual and scheduled builds** to **dev**
7. Click **Continue**
8. Click **Empty job**
9. Name: **Dev - Azure SQL Deployments-CI**

![](./imgs/db-dev-ci.png)

10. Click on the Agent job 1 and update the following setting:
    1. Display name: **Build trainingDW database**
11. Click on the **+** icon to add a new task
    1.  Search for: **Visual Studio build**
    2.  Click the **Add** button on the Visual Studio build

![](./imgs/db-dev-vsbuild.png)

12. Click on the newly added **Visual Studio build** task and update the following settings:
    1. Display name: **Build solution trainingDW/trainingDW.sln**
    2. Solution: **DatabaseProjects/trainingDW/trainingDW.sln**
    3. Platform: **$(BuildPlatform)**
    4. Configuration: **$(BuildConfiguration)**
    5. Check mark **Clean**

13. Click on the **+** icon to add a new task
    1.  Search for: **Publish build artifacts**
    2.  Click **Add**

![](./imgs/db-dev-ci-publisharts.png)

14. Click on the newly added **Publish build artifacts** task and update the following settings:
    1.  Display name: **Publish Artifact: trainingDW-drop**
    2.  Path to publish: **DatabaseProjects**
    3.  Artifact name: **trainingDW**
15. Click on **Variables** > add the following:
    1.  **BuildConfiguration**: **release**
    2.  **BuildPlatform**: **any cpu**

![](./imgs/db-dev-build-vars.png)

16. Click **Triggers** to configure continuos integration
    1.  Enable continuous integration
    2.  Branch filter: **dev**
    3.  Add Path filter: **Include**: **DatabaseProjects**
    4.  Add Path filter: **Exclude**: **Deployments**

![](./igs/../imgs/db-dev-triggers.png)

:bulb: The include and exclude filters set to make sure that continuous integration only kicks off when there has been changes committed for the database project.

17. Click **Options**
18. Update Build number format to:
> \$(date:yyyyMMdd)_\$(BuildDefinitionName)_\$(SourceBranchName)\$(rev:.r)

19. Click **Save & queue** > **Save** (Comment optional) > **Save**
20. Click **Queue** > **Run**
21. Click into **Build trainingDW database** in the jobs section to view the status of your build

**Expected result**

![](./imgs/db-dev-build.png)

**You now have a working CI Pipeline to build your SSDT Database project**

## <div style="color: #107c10">Exercise - Dev Database Release Pipeline (CD)</div>

___     
- [Next Lab](/docs/labs/{enter next labe .md})
- [Back to all modules](/docs/labs/README.md)
___
___
**Azure subscriptions**

<ins>TRIAL SUBSCRIPTIONS ARE NOT SUPPORTED FOR THIS WORKSHOP</ins>