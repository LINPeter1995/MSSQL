-- 請練習撰寫下列指令，使用 Northwind 資料庫
use Northwind
 
-- 在資料庫 LabDB2 下, 依題目指定用 store procedues 或函數的方式 改寫 HW Q_A30
--  並呼叫該 store procedues 或 函數 來使用
use LabDB2
go

-- Step2 列出 Products 產品資料表中欄位 產品代號, 產品名稱, 供應商代號
--  運用 store procedues 的方式

create procedure Proc_B20
as
select ProductID, ProductName, SupplierID
from northwind.dbo.Products

exec Proc_B20


-- Step3 承上題
--     請帶出該產品的供應商名稱(CompanyName)、聯絡電話(Phone)、聯絡人(ContactName)
--     相同供應商的資料請列在一起 --  運用 store procedues 的方式

drop proc if exists Proc_0 3

as
select ProductID, ProductName, SupplierID from northwind.dbo.Products

exec Proc_02





-- Step4 承上題，請加入條件："庫存量低於訂購量" 的產品資料 --  運用 store procedues 的方式
drop proc if exists Proc_04

create procedure Proc_04
as
select ProductID, ProductName, p.SupplierID 
s.CompanyName, s.Phone, s.ContactName,
p.UnitsInStock, p.UnitsOnOrder
from northwind.dbo.Products as p
join northwind.dbo. Suppliers as s on p.SupplierID = s.SupplierID
where p.UnitsInStock <p.UnitsOnOrder

exec Proc_04





-- Step 05 定義一函數, 給予一文字, 呼叫該函數後會回傳 該文字的 長度 len
-- 並將此函數套用到 Northwind.dbo.orders 中的 船運名稱中
drop proc if exists Proc_05

create function dbo.func_05 (@txt varchar(50))
returns int
as
begin
return len (@txt)
end
select dbo.func_05('abc')

select shipname, dbo.func_05(shipname)
from Northwind.dbo.Orders





-- step 6 承上題, 將已建好的函數, 修改成給予一文字, 呼叫該函數後會回傳 該文字的 長度 datalength
-- 並將此函數套用到 Northwind.dbo.orders 中的 船運名稱中
select*from Northwind.dbo.orders
alter function dbo.func_05 (@txt carchar(50))
returns int 
as begin 
return datalength(@txt)
end
select shipname, dbo.func





-- step 07 建一 函數 傳入 一整數 '運費 freight'，在　Northwind.dbo.orders 中查詢
-- 運費大於 '運費 freight' 的所有欄位,  並由大到小排序找出前 10 列
drop function if exists func_07

create function dbo.func_07(@freight int)
returns table
as 
return select top (10)*
from Northwind.dbo.Ordres
where Freight >=@freight
order by Freight desc

select*from dbo.func_07(500)







