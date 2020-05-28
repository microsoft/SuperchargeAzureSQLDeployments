CREATE TABLE [dbo].[ServicePerHotel] (
    [HotelId]   INT NOT NULL,
    [ServiceId] INT NOT NULL,
    CONSTRAINT [PK_ServicePerHotel] PRIMARY KEY CLUSTERED ([HotelId] ASC, [ServiceId] ASC),
    CONSTRAINT [FK_ServicePerHotel_Hotels_HotelId] FOREIGN KEY ([HotelId]) REFERENCES [dbo].[Hotels] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ServicePerHotel_HotelServices_ServiceId] FOREIGN KEY ([ServiceId]) REFERENCES [dbo].[HotelServices] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_ServicePerHotel_ServiceId]
    ON [dbo].[ServicePerHotel]([ServiceId] ASC);

