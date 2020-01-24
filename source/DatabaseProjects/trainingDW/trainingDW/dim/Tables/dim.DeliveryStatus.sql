CREATE TABLE [dim].[DeliveryStatus]
(
	[DeliveryStatusId] INT IDENTITY (1, 1) NOT NULL,
	[Status] varchar(15), 
    [LastUpdated] DATE NULL	
)
Go

CREATE UNIQUE CLUSTERED INDEX [cix_DeliveryStatus_DeliveryStatusId] ON [dim].[DeliveryStatus](DeliveryStatusId ASC);