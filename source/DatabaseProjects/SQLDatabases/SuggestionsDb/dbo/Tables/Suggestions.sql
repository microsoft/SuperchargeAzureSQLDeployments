CREATE TABLE [dbo].[Suggestions] (
    [id]          INT                NULL,
    [name]        NVARCHAR (255)     NULL,
    [type]        NVARCHAR (255)     NULL,
    [latitude]    FLOAT (53)         NULL,
    [longitude]   FLOAT (53)         NULL,
    [description] NVARCHAR (MAX)     NULL,
    [rating]      INT                NULL,
    [votes]       INT                NULL,
    [picture]     NVARCHAR (255)     NULL,
    [createdAt]   DATETIMEOFFSET (7) NOT NULL,
    [updatedAt]   DATETIMEOFFSET (7) NOT NULL
);

