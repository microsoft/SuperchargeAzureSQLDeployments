CREATE TABLE [dbo].[ServicePerRoom] (
    [RoomTypeId] INT NOT NULL,
    [ServiceId]  INT NOT NULL,
    CONSTRAINT [PK_ServicePerRoom] PRIMARY KEY CLUSTERED ([RoomTypeId] ASC, [ServiceId] ASC),
    CONSTRAINT [FK_ServicePerRoom_RoomServices_ServiceId] FOREIGN KEY ([ServiceId]) REFERENCES [dbo].[RoomServices] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ServicePerRoom_RoomType_RoomTypeId] FOREIGN KEY ([RoomTypeId]) REFERENCES [dbo].[RoomType] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_ServicePerRoom_ServiceId]
    ON [dbo].[ServicePerRoom]([ServiceId] ASC);

