CREATE TABLE [dbo].[Cities] (
    [Id]        INT            NOT NULL,
    [Country]   NVARCHAR (MAX) NULL,
    [Latitude]  FLOAT (53)     NOT NULL,
    [Longitude] FLOAT (53)     NOT NULL,
    [Name]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED ([Id] ASC)
);

