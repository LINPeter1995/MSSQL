--	Module 7 - Lab02 �����F�榡

--	SQL Server �w�]��������� datetime ���w�]�榡�O yyyy-mm-dd hh:mm:ss.mmm
--	�b INSERT �� UPDATE ���ɭԡA��r�Τ�������ȶ��γ�޸��A�_�ӡC
--	��޸��]�_�Ӫ�����r��ȥ����ŦX SQL Server �i��������F�榡�C
--	datetime2 �� datetime �󬰺�T�C
--	datetimeoffset ���X�F�㦳�ɰϪ�����ɶ��C


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

--  �s�W time �������
insert DateTimeTable(TestTime) values('15:25:28');
select * from DateTimeTable
go

--  �s�W date �������
insert into DateTimeTable(TestDate) values('1998-03-21');
select * from DateTimeTable
go

--  �s�W smalldatetime �������
insert into DateTimeTable(TestSmallDateTime) values('1998-3-21 18:23:31');
select * from DateTimeTable
go

--  �s�W datetime �������
insert into DateTimeTable(TestDateTime) values('1998-3-21 18:23:36.123');
select * from DateTimeTable
go

--  �s�W datetime2 �������
insert into DateTimeTable(TestDateTime2) values('1998-3-21 23:59:59.12345678');
select * from DateTimeTable
go

--  �ϥθ�����T�ת��t�Τ���M�ɶ���ƨӷs�W����������
--	SYSDATETIME() �� GETDATE() ���󰪪���T�סC

insert into DateTimeTable(TestTime, TestDate, TestSmallDateTime, TestDateTime, TestDateTime2, TestDateTimeOffset) 
values(sysdatetime(), sysdatetime(),  sysdatetime(), sysdatetime(),  sysdatetime(), sysdatetime());
select * from DateTimeTable
go


--	���o�t�Τ���M�ɶ����禡
--		�M�צb�W���ɡA�p�G���i��O������A�ȥ��Ҽ{�ϥ� UTC ��ڼзǮɶ��A
--		�קK�U��ɰϪ��t���y���t�ο��áA�Ҧp�I�ƧI���B�ӫ~�S�f�����K���C

select 
SysDateTime() as 'SysDateTime',
SysDateTimeOffset() as 'SysDateTimeOffset' ,
SysUtcDateTime() as 'SysUtcDateTime',
current_timestamp as 'current_timestamp',
getdate() as 'getdate' ,
GetUtcDate() as 'GetUtcDate'; 


--  �Ǧ^�r���r��A�N����w�� date �����w datepart�C
select	datename(year, getdate())			as 'Year',
			datename (month, getdate())		as 'Month',
			datename (day, getdate())			as 'Day',
			datename (week, getdate())		as 'Week',
			datename (weekday, getdate())	as 'WeekDay',
			datename (hour, getdate())			as 'Hour',
			datename (minute, getdate())		as 'Minute',
			datename (second, getdate())		as 'Second';


--  ISDATE �P�_�O�_�����T����榡
--  datetime  ��ƽd�� 1753-01-01 �� 9999-12-31
--  datetime2 ��ƽd��O 0001-01-01 �� 9999-12-31�C
select isdate ('2019-05-12 10:19:41.177');
select isdate ('2019-05-12');
select isdate ('1752-1-1');
select isdate ('abc');


-- DATEADD �|�N���w�� number ��(�H�a���t������ƧΦ�) 
-- �[���J date �Ȫ����w datepart�A�M��Ǧ^�ӭק�L���ȡC
-- �H�U���|�H 1 �����j���W datepart
declare @datetime2 datetime2 = '2020-04-06 12:49:10.1111111';  
select 
DateAdd (year, 1, @datetime2) as 'year',
DateAdd(quarter, 1, @datetime2) as 'quarter',       -- �u
DateAdd(month, 1, @datetime2) as 'month',
DateAdd(dayofyear, 1, @datetime2) as 'dayofyear',
DateAdd(day, 1, @datetime2) as 'day'


--  ���禡�|�Ǧ^��V���w startdate �M enddate �����w datepart �ɭ����p�� (�@���a���t������ƭ�)�C
--  startdate �M enddate ������ int �t���A�H datepart �ҳ]�w���ɭ���ܡC
declare @dt1 datetime2 = '2006-01-01 00:00:00.0000000';  
declare @dt2 datetime2 = getdate();  

select @dt1 as dt1, @dt2 as dt2                                             --@dt2-@dt1
select DateDiff (year,				@dt1, @dt2) as diff_year;
select DateDiff (quarter,			@dt1, @dt2) as diff_quarter;
select DateDiff (month,			@dt1, @dt2) as diff_month;
select DateDiff (dayofyear,		@dt1, @dt2) as diff_dayofyear;
select DateDiff (day,				@dt1, @dt2) as diff_day;


--	FORMAT�Ǧ^�H���w�榡�P��ܩʤ�ƯS�ʩҮ榡�ƪ���
declare @date1 datetime2 = sysdatetime ();
select 
format ( @date1, 'd') as '²�u���', 
format ( @date1, 'D') as '������',
format ( @date1, 'f') as '�������M²�u�ɶ�',
format ( @date1, 'F') as '�������M����ɶ�',
format ( @date1, 't') as '²�u�ɶ�',
format ( @date1, 'T') as '����ɶ�';
go

-- FORMAT �r���ơG�ϥΤ�ƯS�ʻP�榡�Ƥ��
select 
format (getdate(), 'F', 'en-US') as 'en-US_�^�� - ����',
format (getdate(), 'F', 'de-DE') as 'de-DE_�w�� - �w��', 
format (getdate(), 'F', 'zh-TW') as 'zh-TW_���� - �x�W', 
format (getdate(), 'F', 'zh-CN') as 'zh-CN_���� - ����',
format (getdate(), 'F', 'ko-KR') as 'ko-KR_���� - ����';
go


select OrderDate, 
			format(OrderDate, 'd', 'zh-TW') as '²�u���', 
			format(OrderDate, 'D', 'zh-TW') as '������',
			format(OrderDate, 'f', 'zh-TW') as '�������M²�u�ɶ�',
			format(OrderDate, 'F', 'zh-TW') as '�������M����ɶ�',
			format(OrderDate, 't', 'zh-TW') as '²�u�ɶ�',
			format(OrderDate, 'T', 'zh-TW') as '����ɶ�'
from Northwind.dbo.orders

-- https://docs.microsoft.com/zh-tw/sql/t-sql/functions/getdate-transact-sql?view=sql-server-ver15

