CREATE TABLE [dbo].[Booking] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CheckInDate]      DATE           NOT NULL,
    [CheckOutDate]     DATE           NOT NULL,
    [ClientEmail]      NVARCHAR (50)  NOT NULL,
    [IdHotel]          INT            NOT NULL,
    [IdRoomType]       INT            NOT NULL,
    [NumberOfAdults]   TINYINT        NOT NULL,
    [NumberOfBabies]   TINYINT        NOT NULL,
    [NumberOfChildren] TINYINT        NOT NULL,
    [TotalCost]        DECIMAL (7, 2) NOT NULL,
    CONSTRAINT [PK_Booking] PRIMARY KEY CLUSTERED ([Id] ASC)
);

