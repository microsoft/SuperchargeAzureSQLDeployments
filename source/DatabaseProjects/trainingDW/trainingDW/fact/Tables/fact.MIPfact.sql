CREATE TABLE [fact].[MIPfact]
(
	[MIPFactId] INT IDENTITY (1, 1) NOT NULL ,
	MIPId INT,
	AttendeeId INT,
	AttendeeNotesId INT,
	InstructorId INT,
	LocationId INT,
	DeliveryDateId INT,
	DeliveryStatus INT,
	Attended bit,
	[Count] int NOT NULL DEFAULT 1

)
GO

CREATE UNIQUE CLUSTERED INDEX [cix_Date_DateId] ON [fact].[MIPfact](MIPfactId ASC);
