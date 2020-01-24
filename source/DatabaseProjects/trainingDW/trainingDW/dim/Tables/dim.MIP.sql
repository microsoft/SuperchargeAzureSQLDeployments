CREATE TABLE [dim].[MIP] (
    [MipId]            INT           IDENTITY (1, 1) NOT NULL,
    [MipName]          VARCHAR (100) NULL,
    [ShortDescription] VARCHAR (255)  NULL,
    [ShortName]      VARCHAR (75)  NULL,
    [MipType]          VARCHAR (30)  NULL,
    [DeliveryDays]     INT           NULL,
    [BilledHours]      INT           NULL, 
    [Notes] VARCHAR(255) NULL, 
    [LastUpdated] DATE NULL
);

GO
CREATE UNIQUE CLUSTERED INDEX [cix_MIP_MipId] ON [dim].[MIP]([MipId] ASC);

