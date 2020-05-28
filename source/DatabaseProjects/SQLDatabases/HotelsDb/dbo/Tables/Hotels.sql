CREATE TABLE [dbo].[Hotels] (
    [Id]                 INT            NOT NULL,
    [CheckinTime]        TIME (7)       NOT NULL,
    [CheckoutTime]       TIME (7)       NOT NULL,
    [CityId]             INT            NULL,
    [Description]        NVARCHAR (MAX) NULL,
    [Name]               NVARCHAR (MAX) NULL,
    [NumPhotos]          INT            NOT NULL,
    [Rating]             INT            NOT NULL,
    [Visits]             INT            NOT NULL,
    [Address_Latitude]   FLOAT (53)     NOT NULL,
    [Address_Longitude]  FLOAT (53)     NOT NULL,
    [Address_PostCode]   NVARCHAR (MAX) NULL,
    [Address_Street]     NVARCHAR (MAX) NULL,
    [Location_Latitude]  FLOAT (53)     NOT NULL,
    [Location_Longitude] FLOAT (53)     NOT NULL,
    CONSTRAINT [PK_Hotels] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hotels_Cities_CityId] FOREIGN KEY ([CityId]) REFERENCES [dbo].[Cities] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Hotels_CityId]
    ON [dbo].[Hotels]([CityId] ASC);

