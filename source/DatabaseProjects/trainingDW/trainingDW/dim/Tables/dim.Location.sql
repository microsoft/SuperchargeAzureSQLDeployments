CREATE TABLE [dim].[Location]
(
	[LocationId] INT IDENTITY (1, 1) NOT NULL , 
    [State] VARCHAR(2) NULL, 
    [City] VARCHAR(30) NULL, 
    [OfficeAddress] VARCHAR(30) NULL, 
    [CustomerSite] BIT NULL, 
    [LocationNotes] VARCHAR(255) NULL, 
    [LastUpdated] DATE NULL 
)

GO
CREATE UNIQUE CLUSTERED INDEX [cix_Location_LocationId] ON [dim].[Location]([LocationId] ASC);

