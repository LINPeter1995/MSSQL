-- 模組 15：身份欄位 (IDENTITY) 相關操作與比較
-- 15-1：什麼是身份欄位 (IDENTITY)？如何自動產生流水號？
-- 15-2：身份欄位的三個函數比較：
--       @@IDENTITY vs. SCOPE_IDENTITY() vs. IDENT_CURRENT()
-- 15-3：身份序列 (Sequences) 的介紹與使用

-- 身份欄位可以在 CREATE TABLE 或 ALTER TABLE 時設定，
-- 語法為：IDENTITY [(seed, increment)]
--    seed 是起始值，預設為 1，
--    increment 是每次遞增的數量，預設為 1。
-- 若未指定，預設為 (1,1)。
-- 這樣在插入新資料時，該欄位會自動產生遞增數字。

-- 注意：若想手動插入身份欄位的值，必須使用
-- SET IDENTITY_INSERT ON 來暫時允許手動輸入身份欄位。

-- 01.Demo - IDENTITY.sql

-- Step 0: 切換資料庫到 LabDB2
use  LabDB2  ;
go

-- Step 1-1: 建立 Opportunity01 資料表，OpportunityID 為身份欄位
create table Opportunity01 ( 
	  OpportunityID  int identity (1,1) not null ,
	  Requirements  nvarchar(50)  not null  ,
	  ReceivedDate  date  not null  ,
	  LikelyClosingDate  date  null ,
	  SalespersonID  int  null ,
	  Rating  int  not null 
) ;

-- 建立另一個相同結構的 Opportunity02 資料表
create table Opportunity02 ( 
	  OpportunityID  int identity (1,1) not null ,
	  Requirements  nvarchar(50)  not null  ,
	  ReceivedDate  date  not null  ,
	  LikelyClosingDate  date  null ,
	  SalespersonID  int  null ,
	  Rating  int  not null 
) ;

-- Step 1-2: 插入兩筆資料到 Opportunity01 表
insert Opportunity01
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ,
       ('n.d.', sysdatetime(), DateAdd (month,2, sysdatetime()), 37, 2) ;

-- Step 1-3: 查詢 Opportunity01 表與身份欄位相關函數的結果
select * from Opportunity01 ;
select ident_current ('Opportunity01'), scope_identity (), @@identity  ;

-- ident_current('表名')：取得指定表最新的身份欄位值（不受範圍限制）
-- scope_identity()：取得當前執行範圍內最新的身份欄位值（不含觸發器）
-- @@identity：取得最後一次插入身份欄位的值（包含觸發器內插入）

-- Step 1-4: 嘗試手動指定 OpportunityID 插入資料，會失敗
insert Opportunity01
	(OpportunityID, Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values (5, 'n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;
select * from Opportunity01 ;		-- 將會報錯

-- 若要手動指定身份欄位的值，必須先開啟 identity_insert
set identity_insert Opportunity01 on ;			-- 開啟身份欄位插入權限

insert Opportunity01
	(OpportunityID, Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values (8, 'n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;

select * from Opportunity01 ;

-- 下方插入不含 OpportunityID 的語法，這邊出現錯誤，可能是排版問題：
insert Opportunity01
	( Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;	-- error 

select * from Opportunity01 ;

-- 關閉 identity_insert 設定
set identity_insert Opportunity01 off ;			-- 關閉身份欄位插入權限

-- 正常插入資料，不指定身份欄位值，系統自動產生
insert Opportunity01
	( Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;
go 5	-- 重複執行 5 次

select * from Opportunity01 ;

select ident_current ('Opportunity01'), scope_identity (), @@identity  ;

-- 同樣對 Opportunity02 表插入兩筆資料
insert Opportunity02 
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ,
       ('n.d.', sysdatetime(), DateAdd (month,2, sysdatetime()), 37, 2) ;

select * from Opportunity01;
select * from Opportunity02;

-- 比較 ident_current 與其他身份欄位函數結果
select ident_current ('Opportunity01'), ident_current ('Opportunity02'), scope_identity (), @@identity  ;

-- 比較 scope_identity() 與 @@identity

create table t1(id int identity(1, 1));  
create table t2(id int identity(150,10));

insert t1 default values
go 5

select * from t1
select @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;

insert t2 default values
go 5

select * from t2
select @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;


-- 測試觸發器內插入身份欄位的影響
create trigger tg_t1_insert on t1
for insert
as
begin
	insert t2 default values
end;

-- 插入 t1，觸發器自動插入 t2
insert t1 default values;
select * from t1;
select * from t2;
select @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;

-- 清理測試資料表
drop table if exists t1, t2;
