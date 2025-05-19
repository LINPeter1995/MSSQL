-- Module 3 - Lab02 欄位別名（Column Alias）練習

-- 觀察 Products 表格的欄位
use Northwind;
go

select * from Products;


--	❶ 基本欄位別名練習（使用 AS）

-- 使用別名 (Alias)，將欄位重新命名成較友善的中文顯示
select  
    ProductName as '產品名稱',
    QuantityPerUnit as '包裝單位',
    UnitPrice as '單價',
    UnitPrice * 30 as '預估月營收',
    UnitsInStock as '庫存數量',
    UnitsOnOrder as '訂單數量',
    UnitsInStock + UnitsOnOrder as '總數量'
from Products;


--	❷ 表格別名 + 欄位別名

-- 為 Products 表格取別名 p，用表格別名存取欄位
select  
    p.ProductName as '產品名稱',
    p.QuantityPerUnit as '包裝單位',
    p.UnitPrice as '單價',
    p.UnitPrice * 32 as '估算營收',
    p.UnitsInStock as '庫存數量',
    p.UnitsOnOrder as '訂單數量',
    p.UnitsInStock + p.UnitsOnOrder as '總數量'
from Products as p;



--	❸ 字串合併欄位 + 單價查詢
select ProductName + ' /  ' + QuantityPerUnit as 'Name', UnitPrice 
from Products;


-- 使用 ROW_NUMBER 搭配 ORDER BY ProductName，加上流水號排序顯示產品資訊
select 
    row_number() over (order by ProductName) as rowid,
    *
from Products;




-- ❺ 額外練習：客戶表格地址合併 + 當前時間查詢

-- 顯示地址與城市組合
select Address + ', ' + City as ship_to 
from Customers;

-- 顯示目前時間
select getdate() as '目前時間';

-- ❻ 欄位指定查詢 Products 表中資訊
-- 使用表格別名，查詢特定欄位
select 
    pd.ProductID, 
    pd.ProductName, 
    pd.QuantityPerUnit 
from Products as pd;
