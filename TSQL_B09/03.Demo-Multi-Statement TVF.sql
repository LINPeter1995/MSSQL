-- 模組 09：示範 - 多語句表值函數 (Multi-Statement TVF)

-- 多語句表值函數 (Multi-Statement TVFs)：
-- 一種可以回傳「表格型資料」的函數，適用於需要多步驟處理並回傳表格結果的情況。

-- 舉例：宣告一個回傳 Table 變數的函數，
-- 在函數內部可進行多重操作（例如：Insert、Delete），
-- 最終回傳一個組合完成的 Table 結果。

drop function if exists tvf_Book

create function tvf_Book(@ISBN as int)
returns @myBook table(							-- 宣告回傳的表格變數
	myISBN nvarchar(20),
	myTitle nvarchar(50),
	myRleaseDate date,
	myPublishID int
)
as
begin
    -- 將 Book 表的資料插入到回傳的表格變數 @myBook 中
    Insert @myBook
	select ISBN, Title, ReleaseDate, PublisherID
	from Book 

    -- 從回傳表格中刪除 ISBN 等於輸入參數的資料
	delete @myBook where myISBN = @ISBN

	return  -- 回傳結果
end;
go

-- 查詢函數結果（輸入 ISBN = 6）
select * from tvf_Book(6)

-- 查詢原 Book 表內容
select * from Book

-- 以下會報錯，因為 @myBook 是函數內部變數，外部不可直接使用
select * from @myBook

-- 範例 2：多語句表值函數與 JOIN 使用示範

create function fn_GetOrder(@OrderID as int )
returns @myOrder table(
	myOrderID int,
	myCustomerID nchar(5),
	myShipCity nvarchar(15)
)
as
begin
    -- 將 Orders 表指定 OrderID 的資料插入回傳表格 @myOrder
	insert	@myOrder
	select OrderID, CustomerID, ShipCity from Northwind.dbo.Orders where  OrderID = @OrderID
	return  -- 回傳結果
end

-- 查詢 OrderID=10248 的訂單資料
select * from fn_GetOrder(10248)

-- 用函數結果與 Order Details 表做 JOIN，查詢訂單明細
select o.myOrderID, o.myCustomerID, o.myShipCity, od.ProductID
from  fn_GetOrder(10248) as o
join Northwind.dbo.[Order Details] as od
on o.myOrderID = od.OrderID


-- 示範使用 MarketDev 資料庫與字串拆解函數 dbo.StringListToTable

-- Step 1 - 切換資料庫到 MarketDev
use  MarketDev ;

-- Step 2 - 宣告字串參數，逗號分隔的客戶編號串
declare  @CustomerList  nvarchar(200) ;
set  @CustomerList = '12, 15, 99, 214, 228, 917' ;

-- 呼叫拆字串函數，將字串轉成表格
select  *  from  dbo.StringListToTable(@CustomerList, ',')   

-- Step 3 - 用不同分隔符號（豎線 |）
declare @CustomerList nvarchar(200) ;
set  @CustomerList = '12|15|99|214|228|917' ;

select  *  from  dbo.StringListToTable(@CustomerList , '|')  ;
go
