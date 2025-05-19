-- Module 6 - Lab02：CHECK 約束條件練習

-- UNIQUE 和 CHECK 都是用來限制欄位資料的完整性，
-- 不過 CHECK 可以用來設定更具彈性的條件限制，例如在 SQL Server 中，
-- 我們可以利用 CHECK 來限制某個欄位的數值範圍或邏輯條件。

-- CHECK 條件可以防止使用者輸入不合理的資料，確保資料品質，
-- 例如：年齡欄位只能輸入合理的年齡（如 Age > 0 且 Age < 120）。

-- 相較於 FOREIGN KEY，CHECK 約束的限制對象不同，
-- FOREIGN KEY 是限制欄位的值**必須存在於另一個資料表的對應欄位中**；
-- 而 CHECK 則是用來限制本資料表中欄位的值或是資料列之間的邏輯條件。

-- 舉例來說：
-- FOREIGN KEY 約束：限制「某欄位」的值**參照另一個資料表的主鍵**
-- CHECK 約束：限制「某欄位或多欄位」的值**需符合特定邏輯條件**

-- 補充說明：
-- 若欄位上設有 CHECK 條件，但允許欄位為 NULL，
-- 則當輸入的值為 NULL 時，SQL Server 不會直接當成違反條件。
-- 因為在邏輯上 NULL 表示未知，CHECK 條件會回傳 UNKNOWN，
-- 而 SQL Server 對於 CHECK 條件結果為 UNKNOWN 的情況會**接受該筆資料**（並不視為違反 CHECK 條件）。



use LabDB;
go

-- 建立 Member 資料表並加上 Age 的限制條件
-- 若 LabDB 中已有 Member 資料表，先刪除它
drop table if exists Member;
go

-- 建立 Member 資料表，限制 Age 必須介於 0 和 150 之間
create table Member (
	ID int identity(1, 1) not null,     -- (1,1) 表示從 1 開始、每次遞增 1
	Name varchar (50) null,
	Age int null check (Age > 0 and Age < 150)  
);
go

-- 新增五筆 Age 為 49 的資料
insert into Member (Age) values (49);  
go  5
-- 檢查目前資料內容
select * from Member

-- Error : 	Adding values that will be fail under the check constraint  
-- 測試：新增一筆不合法的年齡（Age = 200），將觸發 CHECK 錯誤
insert into Member (Age) values (200);  
go

-- 修改 Member 表格，加上 Seniority 欄位，並設定 Age 必須大於 Seniority
alter table Member
	add Seniority int null default 1,                     -- 預設為 1，假設所有人最少都有一年資歷
	check(Age > Seniority);
go
-- 檢查資料表內容
select * from Member

-- 測試插入資料
insert into Member (Age, Seniority) values (49, 25);  
go  

insert into Member (Age, Seniority) values (25, 30);  
go
