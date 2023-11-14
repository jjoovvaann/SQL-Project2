create database SqlProject_JovanLjatkoski
GO

use SqlProject_JovanLjatkoski
GO

-- SENIORITY LEVEL

-- Table

create table dbo.SeniorityLevel
(
	ID [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	CONSTRAINT [PK_SeniorityLevel] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)
)
GO

-- Insert Data 
  
INSERT INTO [dbo].SeniorityLevel([Name])
VALUES
	('Junior'),	('Intermediate'), ('Senor'), ('Lead'), ('Project Manager')
,	('Division Manager'), ('Office Manager'), ('CEO'), ('CTO'),	('CIO')


select * from dbo.SeniorityLevel

-- LOCATION

select * from WideWorldImporters.Application.Countries
select * from dbo.Location 

create table dbo.Location
(
	ID [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](100) NOT NULL,
	[Continent] [nvarchar](100) NOT NULL,
	[Region] [nvarchar](100) NOT NULL,
	CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)
)
GO

-- Insert Data

INSERT INTO dbo.Location(CountryName, Continent, Region)
	SELECT
		ac.CountryName,ac.Continent,ac.Region
	FROM
		WideWorldImporters.Application.Countries as ac


-- Department


create table dbo.Department
(
	ID [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)
)
GO

-- Insert Data

INSERT INTO [dbo].Department([Name])
VALUES
	('Personal Banking & Operations')
,	('Digital Banking Department')
,	('Retail Banking & Marketing Department')
,	('Wealth Management & Third Party Products')
,	('International Banking Division & DFB')
,	('Treasury')
,	('Information Technology')
,	('Corporate Communications')
,	('Support Services & Branch Expansion')
,	('Human Resources')

select * from dbo.Department


-- EMPLOYEE

create table dbo.Employee
(
	ID [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100)  NULL,
	[LocationID] int NULL,
	[SeniorityLevelID] int  NULL,
	[DepartmentID] int  NULL,
	CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)
)
GO

select * from dbo.Employee

-- Insert Data

INSERT INTO dbo.Employee(FirstName, LastName, LocationID, SeniorityLevelID, DepartmentID)
	SELECT 
		   SUBSTRING(FullName, 1, CHARINDEX(' ', FullName) - 1) AS FirstName,     
		   SUBSTRING(fullname,CHARINDEX(' ', FullName) + 1, LEN(FullName) - CHARINDEX(' ', FullName)) AS LastName,
		   NTILE(190) OVER (ORDER BY PersonID) as LocationID,
		   NTILE(111) OVER (ORDER BY PersonID) as SeniorityLevelID,
		   NTILE(111) OVER (ORDER BY PersonID) as DepartmentiID
	FROM 
		WideWorldImporters.Application.People


-- SALARY


create table dbo.Salary
(
	ID [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeID] int NULL,
	[Month] [smallint]  NULL,
	[Year] smallint NULL,
	[GrossAmount] decimal(18,2)  NULL,
	[NetAmount]  decimal(18,2) NULL,
	[RegularWorkAmount] decimal(18,2) NULL,
	[BonusAmount] decimal(18,2)  NULL,
	[OvertimeAmount] decimal(18,2)  NULL,
	[VacationDays] smallint NULL,
	[SickLeaveDays] smallint  NULL
	CONSTRAINT [PK_Salary] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)
)
GO

select * from dbo.Salary


create table [Month]
(
	Month int not null
)

insert into [Month](Month)
values 
	(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)

create table [Year]
(
	Year int not null
)

insert into [Year](Year)
values 
	(2001),(2002),(2003),(2004),(2005),(2006),(2007),(2008),(2009),(2010),
	(2011),(2012),(2013),(2014),(2015),(2016),(2017),(2018),(2019),(2020)

select * from Month
select * from Year

create table ID
(
	EmployeeID int not null
)

insert into ID(EmployeeID)
select ID from dbo.Employee


insert into dbo.Salary(EmployeeID, Month, Year)
select 
	* from ID cross join Month cross join Year

select * from dbo.Salary

update dbo.Salary set GrossAmount =  30000 + ABS(CHECKSUM(NewID())) % 25000 where EmployeeID between 1 and 1111
update dbo.Salary set NetAmount = 0.9*GrossAmount
update dbo.Salary set RegularWorkAmount = 0.8*NetAmount
update dbo.Salary set BonusAmount = NetAmount - RegularWorkAmount where Month % 2 = 1
update dbo.Salary set OvertimeAmount = NetAmount - RegularWorkAmount where Month % 2 = 0
update dbo.salary set vacationDays = vacationDays + (EmployeeId % 2)
where  (employeeId + MONTH+ year)%5 = 1
update dbo.salary set SickLeaveDays = EmployeeId%8, vacationDays = vacationDays + (EmployeeId % 3)
where  (employeeId + MONTH+ year)%5 = 2

select * from dbo.salary 
where NetAmount <> (regularWorkAmount + BonusAmount + OverTimeAmount)