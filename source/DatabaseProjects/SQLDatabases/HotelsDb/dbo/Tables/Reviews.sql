CREATE TABLE [dbo].[Reviews] (
    [Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Date]     DATETIME2 (7)  NOT NULL,
    [HotelId]  INT            NOT NULL,
    [Message]  NVARCHAR (MAX) NULL,
    [Rating]   INT            NOT NULL,
    [RoomType] NVARCHAR (MAX) NULL,
    [UserId]   INT            NOT NULL,
    [UserName] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED ([Id] ASC)
);

