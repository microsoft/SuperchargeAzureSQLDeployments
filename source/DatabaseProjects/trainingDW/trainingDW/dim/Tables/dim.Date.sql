CREATE TABLE [dim].[Date]
(
	[DateId]			INT IDENTITY (1, 1) NOT NULL ,
	[Date]              DATE        NOT NULL,
	[Day]               TINYINT     NOT NULL,
	DaySuffix           CHAR(2)     NOT NULL,
	[Weekday]           TINYINT     NOT NULL,
	WeekDayName         VARCHAR(10) NOT NULL,
	IsWeekend           BIT         NOT NULL,
	IsHoliday           BIT         NOT NULL,
	HolidayText         VARCHAR(64) SPARSE,
	DOWInMonth          TINYINT     NOT NULL,
	[DayOfYear]         SMALLINT    NOT NULL,
	WeekOfMonth         TINYINT     NOT NULL,
	WeekOfYear          TINYINT     NOT NULL,
	ISOWeekOfYear       TINYINT     NOT NULL,
	[Month]             TINYINT     NOT NULL,
	[MonthName]         VARCHAR(10) NOT NULL,
	[Quarter]           TINYINT     NOT NULL,
	QuarterName         VARCHAR(6)  NOT NULL,
	[Year]              INT         NOT NULL,
	MMYYYY              CHAR(6)     NOT NULL,
	MonthYear           CHAR(7)     NOT NULL,
	FirstDayOfMonth     DATE        NOT NULL,
	LastDayOfMonth      DATE        NOT NULL,
	FirstDayOfQuarter   DATE        NOT NULL,
	LastDayOfQuarter    DATE        NOT NULL,
	FirstDayOfYear      DATE        NOT NULL,
	LastDayOfYear       DATE        NOT NULL,
	FirstDayOfNextMonth DATE        NOT NULL,
	FirstDayOfNextYear  DATE        NOT NULL 
)

GO

CREATE UNIQUE CLUSTERED INDEX [cix_Date_DateId] ON [dim].[Date](DateId ASC);

