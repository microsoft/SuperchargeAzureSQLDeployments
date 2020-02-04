###OPTIONAL

> Visual Studio 2019 Community does not support the features below. 

1. Navigate to **SQL Server Object Explorer** > **Projects - trainingDW** > **trainingDW** > **Programmability** > **Stored Procedures**
     1. Right-click **Add New Stored Procedure**
     2. Name the SP: **AttendeeSP**
     3. Enter the following:
```
CREATE PROCEDURE [dbo].[AttendeeSP]
@FirstName   AS VARCHAR(30),
@LastName    AS VARCHAR(50),
@LastUpdated AS DATETIME 
  AS
  INSERT INTO dim.Attendee (FirstName ,LastName, LastUpdated)
  VALUES(@FirstName,@LastName, @LastUpdated)

```

    4. Press **F5** to deploy the update
2. Right click the **AttendeeSP** Stored Procedure
3. Create Unit Tests...
4. Fill in the following:
    1. New project name: **SQLSPTest**
    2. Create new class: **SqlServerUnitTestSP.cs**
5. Select the Connection
     1. Click on **Browse** and **Local**
     2. Select **ProjectsV13** and then the **Database Name**
     3. Click Connect
6. The **SQL Server Unit Test Designer** should open
7. Make sure **Test** is selected
8. Insert the following
```
DECLARE @FirstName AS VARCHAR(30),@LastName AS VARCHAR,@LastUpdated AS DATETIME ;
SELECT @FirstName = 'Joe',
@LastName  = 'Smith',
@LastUpdated = GETDATE();

EXECUTE [dbo].[AttendeeSP] @FirstName, @LastName, @LastUpdated;
SELECT * FROM [dim].[Attendee] WHERE FirstName = @FirstName

```

9. Select **Inconclusive** in the **Test Conditions:**
10. Click the red x to delete this test. 
11. Then select **Row Count** and add the test
12. Right click the test and click on **properties**
12. In the properties menu in the bottom right corner, change row count from **0** to **1**

Add the following scripts:

**PRE-Test**
```
DECLARE @FirstName AS VARCHAR(30);
SELECT @FirstName = 'Joe';
IF EXISTS(SELECT * FROM [dim].[Attendee] WHERE FirstName= @FirstName)  
BEGIN  
DELETE FROM [dim].[Attendee] WHERE FirstName = @FirstName;
END  

```
**Post-test**
```
DECLARE     @FirstName AS VARCHAR = 'Joe'

IF EXISTS(SELECT * FROM [dim].[Attendee] WHERE FirstName= @FirstName)  
BEGIN  
DELETE FROM [dim].[Attendee] WHERE [FirstName] = @FirstName;
END  
```

1. Click on **Test** > **Run All**
2. Commit the new project and SP
3. Navigate to the DevOps Build Pipeline
4. Add **Visual Studio Test** task before the Publish Artifact task
> If the tests fail, then the Artifact is not published
5. Save and Queue

The build fails because the connection string is your localdb. This will need to be updated for your Azure database in the app.config. 

>Right-click on the project > **SQL Server Test Configuration** > Select Azure Connection. 

[More to Come] Remember the Firewall settings and re-deploy the database for modifications. 
