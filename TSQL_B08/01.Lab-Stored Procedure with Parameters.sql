-- 模組 08：儲存過程（Stored Procedure）教學示範
-- 08-1：帶輸入參數的儲存過程示範
-- 08-2：帶輸出參數的儲存過程示範
-- 08-3：帶輸入、輸出參數及回傳碼的儲存過程示範

-- 儲存過程三大重點：
--    輸入參數 (Input parameters)
--    輸出參數 (Output parameters)
--    回傳碼 (Return code)

use LabDB2
-- 如果存在 Book 表，先刪除
-- drop table if exists Book

-- 步驟 2：建立資料表 dbo.Book

create table Book(
  ISBN nvarchar(20) primary key,
  Title nvarchar(50) not null,
  ReleaseDate date not null,
  PublisherID int not null
);

select * from Book

-- 建立帶有加密功能的儲存過程 Proc_C
drop proc if exists Proc_C

create proc Proc_C
  @ISBN nvarchar(20), 
  @title nvarchar(50), 
  @ReleaseDate date, 
  @Publisher int
with Encryption   -- 加密儲存過程內容
as
insert Book values (@ISBN, @title, @ReleaseDate, @Publisher)

-- 執行儲存過程，新增兩筆資料
exec Proc_C '6', 'Tommy story', '2000-1-1', 45
exec Proc_C '7', 'John story', '2020-1-1', 65
select * from Book


-- 建立帶輸出參數的儲存過程 Proc_D
drop proc if exists Proc_D

create proc Proc_D  @total int output  -- 宣告輸出參數 total，回傳總價
as
select @total = sum(UnitPrice) from Northwind.dbo.[Order Details]

-- 宣告變數，呼叫儲存過程並取得輸出參數值
declare @sum int
exec Proc_D @sum output
print 'total price : ' + cast(@sum as varchar)

-- 顯示儲存過程的原始碼（加密與非加密差異）
exec sp_helptext 'Proc_C'  -- encrypted，無法查看內容
exec sp_helptext 'Proc_D'  -- non-encrypted，可查看內容

-- 查看系統中儲存過程的模組內容
select * from sys.sql_modules where object_id = object_id('Proc_C')
select * from sys.sql_modules where object_id = object_id('Proc_D')



-- 範例：帶有輸入參數和輸出參數的儲存過程 GetReviews

-- 步驟 1：切換資料庫
use LabDB2

-- 步驟 2：刪除已有的 GetReviews 儲存過程
drop proc if exists GetReviews;

-- 步驟 3：建立帶預設值與輸出參數的儲存過程
create proc GetReviews  
  @ProductID int = 0,                -- 預設參數，若未指定則為 0
  @NumberOfReviews int output        -- 輸出參數，回傳評論數量
as
if (@ProductID) = 0                 -- 若 ProductID = 0，查詢所有產品評論
  select p.Name, pr.ReviewDate, pr.ReviewerName, pr.Rating, pr.Comments, p.ProductID
  from AdventureWorks.Production.ProductReview as pr
  join AdventureWorks.Production.Product as p
  on p.ProductID = pr.ProductID
  order by p.Name, pr.ReviewDate desc
else
  if exists (select 1 from AdventureWorks.Production.Product where ProductID = @ProductID)
    -- 指定 ProductID 存在，查詢該產品評論
    select p.Name, pr.ReviewDate, pr.ReviewerName, pr.Rating, pr.Comments, p.ProductID
    from AdventureWorks.Production.ProductReview as pr
    join AdventureWorks.Production.Product as p
    on p.ProductID = pr.ProductID
    where pr.ProductID = @ProductID
    order by p.Name, pr.ReviewDate desc
  else
    return -1   -- 若產品不存在，回傳 -1

set @NumberOfReviews = @@rowcount  -- 設定輸出參數為查詢筆數
return 0                          -- 成功回傳 0



-- 測試 1-1：使用位置參數，取得評論數及回傳碼
declare @NumReviews int, @ReturnValue int
exec @ReturnValue = GetReviews 937, @NumReviews output
if (@ReturnValue = 0)
  select @NumReviews as NumberOfReviews
else
  select 'ProductID does not exist' as ErrorMessage

-- 測試 1-2：使用關鍵字參數
declare @NumReviews int, @ReturnValue int
exec @ReturnValue = GetReviews @NumberOfReviews = @NumReviews output, @ProductID = 937
if (@ReturnValue = 0)
  select @NumReviews as NumberOfReviews
else
  select 'ProductID does not exist' as ErrorMessage

-- 測試 2：測試另一產品ID
declare @NumReviews int, @ReturnValue int
exec @ReturnValue = GetReviews 600, @NumReviews output
if (@ReturnValue = 0)
  select @NumReviews as NumberOfReviews
else
  select 'ProductID does not exist' as ErrorMessage

-- 測試 3：去除 OUTPUT 關鍵字的錯誤示範
declare @NumReviews int, @ReturnValue int
exec @ReturnValue = GetReviews 937, @NumReviews  -- 缺少 output 關鍵字
if (@ReturnValue = 0)
  select @NumReviews as NumberOfReviews
else
  select 'ProductID does not exist' as ErrorMessage

-- 測試 4：使用預設 ProductID (0)，取得所有評論數
declare @NumReviews int, @ReturnValue int
exec @ReturnValue = GetReviews default, @NumReviews output
if (@ReturnValue = 0)
  select @NumReviews as NumberOfReviews
else
  select 'ProductID does not exist' as ErrorMessage

-- 測試 4-1：省略 ProductID 參數，使用關鍵字參數傳入輸出參數
declare @NumReviews int, @ReturnValue int
exec @ReturnValue = GetReviews @NumberOfReviews = @NumReviews output
if (@ReturnValue = 0)
  select @NumReviews as NumberOfReviews
else
  select 'ProductID does not exist' as ErrorMessage

-- 最後刪除儲存過程
drop proc if exists GetReviews;
go
