CREATE TABLE [dbo].[Profiles] (
    [Id]      INT            IDENTITY (1, 1) NOT NULL,
    [Alias]   NVARCHAR (MAX) NULL,
    [Loyalty] INT            NOT NULL,
    [UserId]  NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Profiles] PRIMARY KEY CLUSTERED ([Id] ASC)
);

