CREATE TABLE [pii].[UserAddress] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [ProfileId]   INT           NOT NULL,
    [AddressType] NVARCHAR (50) NOT NULL,
    [Country]     NVARCHAR (50) NOT NULL,
    [State]       NVARCHAR (50) NOT NULL,
    [City]        NVARCHAR (50) NOT NULL,
    [ZipCode]     NVARCHAR (20) NOT NULL,
    [AddressLine] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_UserAddress] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserAddress_Profiles] FOREIGN KEY ([ProfileId]) REFERENCES [dbo].[Profiles] ([Id])
);

