select * from GM
----------------------------------------------------------------------------
--Split into 3 columns - Year, Month, Day
alter table GM
add BirthYear int, BirthMonth int, BirthDay int

update GM
set
BirthDay = CASE
	when len(Born) = 10 then cast(substring(Born, 1, 2) as int)
	else null
	end,
BirthMonth = CASE
	when len(Born) = 10 then cast(substring(Born, 4, 2) as int)
	else null
	end,
BirthYear = CASE
	when len(Born) = 10 then cast(substring(Born, 7, 4)as int)
	when len(Born) = 4 then cast(Born as int)
	else null
	end;

--Adding column to replace month number (1,2...) with Text (January, February...)
alter table GM
add MonthText nvarchar(100)

update GM
set MonthText =
	case 
		 when BirthMonth = 1 then 'January'
		 when BirthMonth = 2 then 'February'
		 when BirthMonth = 3 then 'March'
		 when BirthMonth = 4 then 'April'
		 when BirthMonth = 5 then 'May'
		 when BirthMonth = 6 then 'June'
		 when BirthMonth = 7 then 'July'
		 when BirthMonth = 8 then 'August'
		 when BirthMonth = 9 then 'September'
		 when BirthMonth = 10 then 'October'
		 when BirthMonth = 11 then 'November'
		 when BirthMonth = 12 then 'December'
	end   

----------------------------------------------------------------------------
-- SPLITTING Name into 2 columns
---- Adding new columns NameFirst and NameLast

select * from GM


---- Finding repeated names
--select NameFirst, count(NameFirst) as distinct_names
--from GM
--group by NameFirst
--order by distinct_names desc


alter table GM
drop column NameFirst, NameLast

alter table GM
add NameFirst nvarchar(250), NameLast nvarchar(250)

---- Add data to these 2 columns
update GM
set 
	NameLast = 
	CASE
	when charindex(',',Name)>0 then ltrim(rtrim(substring(Name,1, charindex(',', Name)-1)))
	when charindex(' ',Name)>0 then ltrim(rtrim(substring(Name,1, charindex(' ', Name)-1)))
	else Name
end,
	NameFirst =
	CASE
	when charindex(',',Name)>0 then ltrim(rtrim(substring(Name, charindex(',', Name)+1, len(Name)-charindex(',', Name))))
	when charindex(' ',Name)>0 then ltrim(rtrim(substring(Name, charindex(' ', Name)+1, len(Name)-charindex(' ', Name))))
	else null
end;
--Explanations...
--In the NameLast and NameFirst assignments, we are using a CASE statement to handle different scenarios for splitting the values in the your_column column.
--CHARINDEX(',', Name) > 0 checks if the comma (,) character exists in the your_column string.
--CHARINDEX(' ', Name) > 0 checks if a space character exists in the your_column string.
--Inside each CASE statement, we use SUBSTRING to extract the relevant portions of the string:
--SUBSTRING(your_column, 1, CHARINDEX(',', Name) - 1) extracts the substring before the comma (,) or space character.
--SUBSTRING(your_column, CHARINDEX(',', Name) + 1, LEN(Name) - CHARINDEX(',', Name)) extracts the substring after the comma (,) or space character.
--LTRIM(RTRIM()) is used to remove any leading or trailing spaces from the extracted substrings.
--The ELSE clause in the CASE statement handles cases where there's no comma or space, so it retains the original value in the column.
--For NameFirst, if the delimiter is not found, we set it to NULL since there's no second part to extract.

----------------------------------------------------------------------------
--Converting Date of Death
--Adding column
alter table GM
drop column DeathYear, DeathMonth, DeathDay

alter table GM
add DeathYear int, DeathMonth int, DeathDay int

update GM
set
DeathDay = CASE
	when len(Died) = 10 then cast(substring(Died, 1, 2) as int)
	else null
	end,
DeathMonth = CASE
	when len(Died) = 10 then cast(substring(Died, 4, 2) as int)
	when len(Died) = 7 then cast(substring(Died, 6, 2) as int)
	else null
	end,
DeathYear = CASE
	when len(Died) = 10 then cast(substring(Died, 7, 4) as int)
	when len(Died) = 4 then cast(Died as int)
	when len(Died)= 7 then cast(substring(Died, 1, 4) as int)
	else null
	end;


--Adding column to replace month number (1,2...) with Text (January, February...)
alter table GM
add DeathMonthString nvarchar(250)

update GM
	set DeathMonthString = 
		case 
		 when DeathMonth = 1 then 'January'
		 when DeathMonth = 2 then 'February'
		 when DeathMonth = 3 then 'March'
		 when DeathMonth = 4 then 'April'
		 when DeathMonth = 5 then 'May'
		 when DeathMonth = 6 then 'June'
		 when DeathMonth = 7 then 'July'
		 when DeathMonth = 8 then 'August'
		 when DeathMonth = 9 then 'September'
		 when DeathMonth = 10 then 'October'
		 when DeathMonth = 11 then 'November'
		 when DeathMonth = 12 then 'December'
		 end

-- Adding SPAN of lifetime 
alter table GM
add YearsLived int

update GM
	set YearsLived = DeathYear - BirthYear

-- Age when GM was obtained
alter table GM
add TitleAge int

update GM
	set TitleAge = Title - BirthYear
	   
------------------------------------------------------
--Counting the length of First Name and Last Name
alter table GM
add NameFirst_length int, NameLast_length int

update GM
	set 
	NameFirst_length = len(NameFirst),
	NameLast_length = len(NameLast)
