CREATE TABLE [dim].[Instructor]
(
	[InstructorId] INT IDENTITY (1, 1) NOT NULL ,
	[FirstName] Varchar(30),
	[LastName] Varchar(30),
	[FullName] AS [FirstName] + ' ' + [LastName],
	[MSFTEmail] Varchar(30), 
    [LastUpdated] DATE NULL
)
GO

CREATE UNIQUE CLUSTERED INDEX [cix_Instructor_InstructorId] ON [dim].[Instructor](InstructorId ASC);

