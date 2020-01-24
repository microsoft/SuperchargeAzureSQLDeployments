CREATE TABLE [dim].[AttendeeNotes]
(
	[AttendeeNotesId] INT IDENTITY (1, 1) NOT NULL,
	[AttendeeId] Int NOT NULL,
	[Notes] VARCHAR(255), 
    [LastUpdated] DATE NULL 
)

GO

CREATE UNIQUE CLUSTERED INDEX [cix_AttendeeNotes_AttendeeNotesId] ON [dim].[AttendeeNotes] ([AttendeeNotesId])
