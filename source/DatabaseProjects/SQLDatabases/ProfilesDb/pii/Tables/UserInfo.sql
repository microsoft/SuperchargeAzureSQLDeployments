CREATE TABLE [pii].[UserInfo] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [ProfileId] INT           NOT NULL,
    [FirstName] NVARCHAR (50) NOT NULL,
    [LastName]  NVARCHAR (50) NOT NULL,
    [Gender]    BIT           NOT NULL,
    [DoB]       DATE          NOT NULL,
    CONSTRAINT [PK_UserInfo] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserInfo_Profiles] FOREIGN KEY ([ProfileId]) REFERENCES [dbo].[Profiles] ([Id])
);

