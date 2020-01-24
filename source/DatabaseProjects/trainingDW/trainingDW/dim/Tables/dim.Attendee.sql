CREATE TABLE [dim].[Attendee] (
    [AttendeeId]  INT          IDENTITY (1, 1) NOT NULL,
    [FirstName]   VARCHAR (30) NOT NULL,
    [LastName]    VARCHAR (50) NOT NULL,
	[FullName]	  AS [FirstName] + ' ' + [LastName],
    [Area]        VARCHAR (15) NULL,
    [StateEmail]  VARCHAR (50) NULL,
	[DoSDevEmail] VARCHAR (50) NULL,
    [MSLiveEmail] VARCHAR (50) NULL, 
    [LastUpdated] DATETIME NULL 
);

GO
CREATE UNIQUE CLUSTERED INDEX [cix_Attendee_AttendeeID] ON [dim].[Attendee]([AttendeeId] ASC);

