CREATE TABLE [dbo].[ConferenceRoom] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Capacity]     INT            NOT NULL,
    [HotelId]      INT            NOT NULL,
    [Name]         NVARCHAR (MAX) NULL,
    [NumPhotos]    INT            NOT NULL,
    [PricePerHour] INT            NOT NULL,
    [Rating]       INT            NOT NULL,
    CONSTRAINT [PK_ConferenceRoom] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ConferenceRoom_Hotels_HotelId] FOREIGN KEY ([HotelId]) REFERENCES [dbo].[Hotels] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_ConferenceRoom_HotelId]
    ON [dbo].[ConferenceRoom]([HotelId] ASC);

