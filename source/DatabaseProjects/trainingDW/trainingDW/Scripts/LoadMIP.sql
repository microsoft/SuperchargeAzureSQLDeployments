--Insert Values into MIP Dim Table

TRUNCATE TABLE dim.MIP
SELECT * FROM dim.MIP

INSERT INTO [dim].MIP (MipName,ShortDescription, ShortName, MipType, DeliveryDays, BilledHours, Notes, LastUpdated) VALUES ('Visual Studio ALM','Three-day instructor-led training','TFS Essentials - Azure Super Powers','WorkshopPLUS',3,24,'Azure Super Powers Delivery',GETDATE())
INSERT INTO [dim].MIP (MipName,ShortDescription, ShortName, MipType, DeliveryDays, BilledHours, Notes, LastUpdated) VALUES ('Windows PowerShell', 'Introduction to using PowerShell', 'PowerShell Foundation Skils', 'WorkshopPLUS', 4, 32, '', GETDATE())
INSERT INTO [dim].MIP (MipName,ShortDescription, ShortName, MipType, DeliveryDays, BilledHours, Notes, LastUpdated) VALUES ('Office 365', 'Developing Application with PowerApps', 'Developing Business Applications with PowerApps', 'WorkshopPLUS', 1, 8, '', GETDATE())
INSERT INTO [dim].MIP (MipName,ShortDescription, ShortName, MipType, DeliveryDays, BilledHours, Notes, LastUpdated) VALUES ('Office 365 SharePoint Online', 'manage and support Power Apps', 'PowerApps and Flow for Admins', 'WorkshopPLUS', 3, 24, '', GETDATE())
INSERT INTO [dim].MIP (MipName,ShortDescription, ShortName, MipType, DeliveryDays, BilledHours, Notes, LastUpdated) VALUES ('Data Platform Modernization for SQL', 'Data Platform Modernization Assessment for SQL', 'Data Platform Modernization for SQL', 'Assessment', 3, 24, '', GETDATE())
INSERT INTO [dim].MIP (MipName,ShortDescription, ShortName, MipType, DeliveryDays, BilledHours, Notes, LastUpdated) VALUES ('Azure SQL Database Essentials', 'Azure SQL Database Essentials provides you the knowledge and tools necessary to understand the capabilites', 'Azure SQL Database Essentials', 'WorkshopPLUS', 3, 24, '', GETDATE())
INSERT INTO [dim].MIP (MipName,ShortDescription, ShortName, MipType, DeliveryDays, BilledHours, Notes, LastUpdated) VALUES ('DevOps Fundamentals', 'Introduces the business value of DevOps', 'DevOps Fundamentals', 'DevOps Fundamentals', 4, 32, '', GETDATE())


SELECT * FROM dim.MIP

