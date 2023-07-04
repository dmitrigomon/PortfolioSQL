select * from lastGM
--DATE FORMAT CHANGE
----------------------------------------------------------------------------
-- Change date format 
----Adding new column
alter table lastGM
add BornConverted nvarchar(100)
----Removing hh:mm:ss
update lastGM
set BornConverted = convert(date,Born,104)

--Split into 3 columns - Year, Month, Day
----Adding new columns
alter table lastGM
add BornYear int, BornMonth int, BornDay int
----Adding data to 3 columns
update lastGM
	set
	BornYear=datepart(year, BornConverted),
	BornMonth=datepart(month, BornConverted),
	BornDay = datepart(day, BornConverted);


--Adding column to replace month number (1,2...) with Text (January, February...)
alter table lastGM
add MonthText nvarchar(100)

update lastGM
set MonthText =
	case 
		 when month(BornConverted) = 1 then 'January'
		 when month(BornConverted) = 2 then 'February'
		 when month(BornConverted) = 3 then 'March'
		 when month(BornConverted) = 4 then 'April'
		 when month(BornConverted) = 5 then 'May'
		 when month(BornConverted) = 6 then 'June'
		 when month(BornConverted) = 7 then 'July'
		 when month(BornConverted) = 8 then 'August'
		 when month(BornConverted) = 9 then 'September'
		 when month(BornConverted) = 10 then 'October'
		 when month(BornConverted) = 11 then 'November'
		 when month(BornConverted) = 12 then 'December'
	end 
		  

----------------------------------------------------------------------------
-- SPLITTING Name into 2 columns
---- Adding new columns NameFirst and NameLast
alter table lastGM
add NameFirst nvarchar(250), NameLast nvarchar(250)

---- Add data to these 2 columns
update lastGM
	set
	NameFirst = parsename(replace(Name,',','.'),1),
	NameLast = parsename(replace(Name,',','.'),2);


----------------------------------------------------------------------------
--Converting Date of Death
--Adding column
alter table lastGM
add DateDeath nvarchar(100)

--Converting date
update lastGM
set DateDeath = convert(date, Died,112)

--Splitting into 3 columns
alter table lastGM
add DeathYear int, DeathMonth int, DeathDay int

update lastGM
	set
	  DeathYear = datepart(year, DateDeath),
	  DeathMonth = datepart(month, DateDeath),
	  DeathDay = datepart(day, DateDeath);

--Adding column to replace month number (1,2...) with Text (January, February...)
alter table lastGM
add DeathMonthString nvarchar(250)

update lastGM
	set DeathMonthString = 
		case 
		 when month(DateDeath) = 1 then 'January'
		 when month(DateDeath) = 2 then 'February'
		 when month(DateDeath) = 3 then 'March'
		 when month(DateDeath) = 4 then 'April'
		 when month(DateDeath) = 5 then 'May'
		 when month(DateDeath) = 6 then 'June'
		 when month(DateDeath) = 7 then 'July'
		 when month(DateDeath) = 8 then 'August'
		 when month(DateDeath) = 9 then 'September'
		 when month(DateDeath) = 10 then 'October'
		 when month(DateDeath) = 11 then 'November'
		 when month(DateDeath) = 12 then 'December'
		 end

-- Adding SPAN of life 
alter table lastGM
add YearsLived int

update lastGM
	set YearsLived = DeathYear - BornYear

-- Age when GM was obtained
alter table lastGM
add TitleAge int

update lastGM
	set TitleAge = [Title Year] - BornYear