
-- CRUD

-- C : 增加 / 建立		Create
-- R : 查詢 / 讀取		Read	
-- U : 改正 / 更新		Update	
-- Ｄ: 刪除				Delete


-- 以下是員工資料 :
-- id			first name			last name		salary			birthday
-- 100		小明						王				30000.5		2000-01-01
-- 200		中明						李				40000.8		1998-02-01
-- 300		大明						張				45000.9		1995-03-01
-- 400		小花						陳				35000.1		2002-05-01

--  請練習撰寫以下"指令", 請依題意回答


--  1.  請切換至 LabDB 資料庫下, 同時 drop 掉, 如果已存在的 table  employee 

use LabDB;
go
Drop table If EXISTS Table_employee;
go

--  2.  請先建立一employee 資料表僅包含 下列四個欄位, id 是 primary key  (欄位 birthday 先不要建立)
--       id			first name			last name		salary(條件限制 不可大於200,000)

create table Table_employee(
      ID int PRIMARY KEY IDENTITY,
      firstname nvarchar(max)not null,
      lastname nvarchar(max)not null, 
      salary decimal(30,1)not null check (salary > 200000 )
	  );

select*from Table_employee;
go
-- 3.  請先用語法 insert 新增員工基本資料 id firstname lastname salary

Set Identity_Insert Table_employee ON;
Insert Table_employee
(ID, firstname, lastname, salary)
values 
('100','小明','王','30000.5'),
('200','中明','李','40000.8'),
('300','大明','張','45000.9'),
('400','小花','陳','35000.1');
Set Identity_Insert Table_employee OFF;
select*from Table_employee;
go


-- 3.1 嘗試 insert 一筆薪水 300,000 觀察錯誤訊息, 將顯示的錯誤訊息複製/貼在本文中

Set Identity_Insert Table_employee ON;
Insert Table_employee
(ID, firstname, lastname, salary)
values 
('','','','300000');
Set Identity_Insert Table_employee OFF;
select*from Table_employee;
go


--  4.  查詢一下所有員工資料

select * from table_employee


--  5.  查詢一下薪水大於40000 所有員工資料, 並用薪水欄 由大到小排序

select*from  Table_employee
where salary > 40000
Order by salary DESC


--  6.  將資料表 employee 增加一"生日欄位", 
--  試一試將"生日欄位"設為 not null 和 null 的差別, 結果不同為什麼? 請將錯誤訊息貼上即可

Drop table If EXISTS Table_employee;

create table Table_employee(
      ID int identity(1,1) primary key,
      firstname nvarchar(max)not null,
      lastname nvarchar(max)not null, 
      salary decimal(30,1)not null check (salary > 200000 ),
	  Birthday date)

Set Identity_Insert Table_employee ON;
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('100','小明','王','30000.5','1983-05-15')
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('200','中明','李','40000.8','1990-11-30')
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('300','大明','張','45000.9','2005-02-25')
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('400','小花','陳','35000.1','1999-06-19')
Set Identity_Insert Table_employee OFF;
select*from Table_employee;
go


--  7.  任意選擇三個員工編號 修改  生日資料


Update table Table_employee


-- 8.  計算一下所有員工薪水總和

SELECT SUM(salary)
FROM Table_employee

-- 9.  計算一下員工個別的年紀(年減年即可)




-- 10. 請列印出薪資最少員工的所有資料

SELECT MIN(salary)
FROM Table_employee
print ID, firstname, lastname,salary,birthday;


-- 11.  請刪除 王小明 人事資料

select * from Table_employee
delete Table_employee (ID, firstname, lastname,salary,birthday) 
VALUES ('100','小明','王','30000.5','1983-05-15');
go



-- 繳交作業請寄到一下信箱 :
-- Email : jungan0914@gmail.com