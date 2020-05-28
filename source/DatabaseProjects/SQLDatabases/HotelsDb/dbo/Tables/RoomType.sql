CREATE TABLE [dbo].[RoomType] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Capacity]    INT            NOT NULL,
    [Description] NVARCHAR (MAX) NULL,
    [DoubleBeds]  INT            NOT NULL,
    [HotelId]     INT            NOT NULL,
    [Name]        NVARCHAR (MAX) NULL,
    [NumPhotos]   INT            NOT NULL,
    [Price]       INT            NOT NULL,
    [SingleBeds]  INT            NOT NULL,
    [TwinBeds]    INT            NOT NULL,
    CONSTRAINT [PK_RoomType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RoomType_Hotels_HotelId] FOREIGN KEY ([HotelId]) REFERENCES [dbo].[Hotels] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_RoomType_HotelId]
    ON [dbo].[RoomType]([HotelId] ASC);

