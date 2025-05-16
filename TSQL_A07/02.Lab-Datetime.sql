--	Module 7 - Lab02 日期表達格式

--	SQL Server 預設的日期類型 datetime 的預設格式是 yyyy-mm-dd hh:mm:ss.mmm
--	在 INSERT 或 UPDATE 的時候，文字或日期的欄位值須用單引號括起來。
--	單引號包起來的日期字串值必須符合 SQL Server 可接受的表達格式。
--	datetime2 比 datetime 更為精確。
--	datetimeoffset 結合了具有時區的日期時間。


use LabDB;
go

drop table if exists DateTimeTable;
go

create table DateTimeTable (
	TestID int identity,
	TestTime time null,
	TestDate date null,
	TestSmallDateTime smalldatetime null,
	TestDateTime datetime null,
	TestDateTime2 datetime2 null,
	TestDateTimeOffset datetimeoffset null
);
select * from DateTimeTable
go

--  新增 time 資料類型
insert DateTimeTable(TestTime) values('15:25:28');
select * from DateTimeTable
go

--  新增 date 資料類型
insert into DateTimeTable(TestDate) values('1998-03-21');
select * from DateTimeTable
go

--  新增 smalldatetime 資料類型
insert into DateTimeTable(TestSmallDateTime) values('1998-3-21 18:23:31');
select * from DateTimeTable
go

--  新增 datetime 資料類型
insert into DateTimeTable(TestDateTime) values('1998-3-21 18:23:36.123');
select * from DateTimeTable
go

--  新增 datetime2 資料類型
insert into DateTimeTable(TestDateTime2) values('1998-3-21 23:59:59.12345678');
select * from DateTimeTable
go

--  使用較高精確度的系統日期和時間函數來新增日期資料類型
--	SYSDATETIME() 比 GETDATE() 有更高的精確度。

insert into DateTimeTable(TestTime, TestDate, TestSmallDateTime, TestDateTime, TestDateTime2, TestDateTimeOffset) 
values(sysdatetime(), sysdatetime(),  sysdatetime(), sysdatetime(),  sysdatetime(), sysdatetime());
select * from DateTimeTable
go


--	取得系統日期和時間的函式
--		專案在規劃時，如果有可能是跨國交易，務必考慮使用 UTC 國際標準時間，
--		避免各國時區的差異造成系統錯亂，例如點數兌換、商品特惠期間…等。

select 
SysDateTime() as 'SysDateTime',
SysDateTimeOffset() as 'SysDateTimeOffset' ,
SysUtcDateTime() as 'SysUtcDateTime',
current_timestamp as 'current_timestamp',
getdate() as 'getdate' ,
GetUtcDate() as 'GetUtcDate'; 


--  傳回字元字串，代表指定之 date 的指定 datepart。
select	datename(year, getdate())			as 'Year',
			datename (month, getdate())		as 'Month',
			datename (day, getdate())			as 'Day',
			datename (week, getdate())		as 'Week',
			datename (weekday, getdate())	as 'WeekDay',
			datename (hour, getdate())			as 'Hour',
			datename (minute, getdate())		as 'Minute',
			datename (second, getdate())		as 'Second';


--  ISDATE 判斷是否為正確日期格式
--  datetime  資料範圍為 1753-01-01 到 9999-12-31
--  datetime2 資料範圍是 0001-01-01 到 9999-12-31。
select isdate ('2019-05-12 10:19:41.177');
select isdate ('2019-05-12');
select isdate ('1752-1-1');
select isdate ('abc');


-- DATEADD 會將指定的 number 值(以帶正負號的整數形式) 
-- 加到輸入 date 值的指定 datepart，然後傳回該修改過的值。
-- 以下都會以 1 為間隔遞增 datepart
declare @datetime2 datetime2 = '2020-04-06 12:49:10.1111111';  
select 
DateAdd (year, 1, @datetime2) as 'year',
DateAdd(quarter, 1, @datetime2) as 'quarter',       -- 季
DateAdd(month, 1, @datetime2) as 'month',
DateAdd(dayofyear, 1, @datetime2) as 'dayofyear',
DateAdd(day, 1, @datetime2) as 'day'


--  此函式會傳回跨越指定 startdate 和 enddate 之指定 datepart 界限的計數 (作為帶正負號的整數值)。
--  startdate 和 enddate 之間的 int 差異，以 datepart 所設定的界限表示。
declare @dt1 datetime2 = '2006-01-01 00:00:00.0000000';  
declare @dt2 datetime2 = getdate();  

select @dt1 as dt1, @dt2 as dt2                                             --@dt2-@dt1
select DateDiff (year,				@dt1, @dt2) as diff_year;
select DateDiff (quarter,			@dt1, @dt2) as diff_quarter;
select DateDiff (month,			@dt1, @dt2) as diff_month;
select DateDiff (dayofyear,		@dt1, @dt2) as diff_dayofyear;
select DateDiff (day,				@dt1, @dt2) as diff_day;


--	FORMAT傳回以指定格式與選擇性文化特性所格式化的值
declare @date1 datetime2 = sysdatetime ();
select 
format ( @date1, 'd') as '簡短日期', 
format ( @date1, 'D') as '完整日期',
format ( @date1, 'f') as '完整日期和簡短時間',
format ( @date1, 'F') as '完整日期和完整時間',
format ( @date1, 't') as '簡短時間',
format ( @date1, 'T') as '完整時間';
go

-- FORMAT 字串函數：使用文化特性與格式化日期
select 
format (getdate(), 'F', 'en-US') as 'en-US_英文 - 美國',
format (getdate(), 'F', 'de-DE') as 'de-DE_德文 - 德國', 
format (getdate(), 'F', 'zh-TW') as 'zh-TW_中文 - 台灣', 
format (getdate(), 'F', 'zh-CN') as 'zh-CN_中文 - 中國',
format (getdate(), 'F', 'ko-KR') as 'ko-KR_韓文 - 韓國';
go


select OrderDate, 
			format(OrderDate, 'd', 'zh-TW') as '簡短日期', 
			format(OrderDate, 'D', 'zh-TW') as '完整日期',
			format(OrderDate, 'f', 'zh-TW') as '完整日期和簡短時間',
			format(OrderDate, 'F', 'zh-TW') as '完整日期和完整時間',
			format(OrderDate, 't', 'zh-TW') as '簡短時間',
			format(OrderDate, 'T', 'zh-TW') as '完整時間'
from Northwind.dbo.orders

-- https://docs.microsoft.com/zh-tw/sql/t-sql/functions/getdate-transact-sql?view=sql-server-ver15

