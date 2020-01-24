CREATE PROCEDURE [stg].[LoadDims]

AS

--Load Attendee Dim
Print 'Loading Attendee Dim'
insert into dim.Attendee with (tablock)
(FirstName, LastName, Area, StateEmail, DoSDevEmail, MSLiveEmail, LastUpdated)
Select 
	case when CHARINDEX(' ', w.Attendee) = 0
		then w.Attendee
	else Left(w.Attendee, CHARINDEX(' ', w.Attendee)-1)
		end as FirstName,
	case when CHARINDEX(' ', w.Attendee) = 0
		then ''
	else substring(
		Attendee, CHARINDEX(' ', w.Attendee)+1, len(w.Attendee))
		end as LastName,
	w.AttendeeArea as Area, 
	w.AttendeeStateEmail as StateEmail, 
	w.AttendeeDosDevAccnt as DoSDevEmail,
	w.AttendeeMSLiveEmail as MSLiveEmail,
	getdate() as UpdateDate

From stg.workshop w
Left Join dim.Attendee a on a.FirstName + ' ' + a.LastName = trim(w.Attendee)
Where a.AttendeeId is null

