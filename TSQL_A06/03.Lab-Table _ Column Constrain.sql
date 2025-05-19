-- Module 6 - Lab03：表格層級與欄位層級的約束條件（Constraint）

-- CONSTRAINT（約束）主要有以下幾種類型：
--			NOT NULL（不可為 NULL）
--			PRIMARY KEY（主鍵）
--			FOREIGN KEY（外鍵）
--			UNIQUE（唯一值）
--			DEFAULT（預設值）
--			CHECK（邏輯條件）

-- CONSTRAINT（約束）可以在建立資料表（CREATE TABLE）時加入，也可以透過後續修改（ALTER TABLE）加上。
--		定義方式有兩種：
--		Column-level constraint（欄位層級）：
--			直接寫在欄位定義後方，針對單一欄位設定條件。
--		Table-level constraint（資料表層級）：
--			寫在欄位定義區塊之外，通常用來設定多欄位的條件（例如複合鍵）。

-- 建立資料表時，可以視情況選擇使用哪一種定義方式，效果相同，語法略有差異。
-- 兩種方式皆可實作相同的限制條件。

-- 使用 CONSTRAINT 的時機說明如下：
-- 強制性條件（硬性限制）：用來確保資料完整性，例如：不能為 NULL、資料唯一等，
--		通常使用：NOT NULL、PRIMARY KEY、UNIQUE。
-- 非強制性條件（可選限制）：可用來提供預設值或限制某些邏輯條件，
--		例如：CHECK、FOREIGN KEY、DEFAULT、NOT NULL 等。

-- FOREIGN KEY 約束可用來設定資料間的關聯，例如限制會員的地址必須出現在地址表中。


use LabDB;
go

-- 建立練習用資料表
-- 本 Lab 將練習 Table-level constraint 與 Column-level constraint 的差異
drop table if exists Member0, Member1;
go


-- Column-level constraint：每個欄位後面直接加上約束條件（例如 UNIQUE）
create table Member0 (
	ID int not null,                      -- 不可為 NULL
	Name varchar(50) not null,           -- 不可為 NULL
	Birthday date,
	Gender char(1) default 'M',          -- 預設值為 'M'
	Email varchar(20) unique             -- Email 欄位設為唯一（欄位層級）
);
go


-- Table-level constraint：在欄位定義後面額外寫 constraint（這裡是 UNIQUE）
create table Member1 (
	ID int not null,
	Name varchar(50) not null,
	Birthday date,
	Gender char(1) default 'M',
	Email varchar(20),
	constraint UQ_Email unique (Email)   -- 對 Email 設定唯一（表格層級）
);
go

-- Table-level constraint：定義 PRIMARY KEY 與 UNIQUE 複合鍵
create table Member2 (
	ID int not null,
	Name varchar(50) not null,
	Birthday date,
	Gender char(1) default 'M',
	Email varchar(20),

	constraint PK_ID primary key clustered (ID asc), -- 聚簇主鍵
	constraint UQ_codes unique nonclustered (Name, Birthday) -- 非聚簇唯一（複合欄位）
); 
go


-- Column-level constraint：定義主鍵與其他限制條件
create table Member3 (
	ID int primary key,                  -- 主鍵（欄位層級）
	Name varchar (50) not null,
	Gender char (1) not null default 'M'
);
go


-- Table-level constraint：將 PRIMARY KEY 放在欄位區塊之後
create table Member4 (
	ID int,
	Name varchar (50) not null,
	Gender char (1) not null default 'M',

	constraint PK_ID4 primary key(ID)   -- 主鍵（表格層級）
);
go
