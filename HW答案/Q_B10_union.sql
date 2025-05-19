-- 請練習撰寫以下指令，使用 AdventureWorks.Sales.SalesPerson 資料表
-- 用欄位 BusinessEntityID <= 286 和 >= 280 分別作為兩個 select 條件
-- 觀察每個步驟查詢回傳的 row 資料差異


--  Step 1 — 切換到 AdventureWorks 資料庫

use AdventureWorks;
go

--	Step 2 — 使用 UNION ALL 合併兩個查詢（包含重複資料）

select * from Sales.SalesPerson
where BusinessEntityID <=286
union all
select * from  Sales.SalesPerson 
where BusinessEntityID <=280

--	Step 3 — 使用 UNION 合併兩查詢（重複資料會自動去除）

select * from Sales.SalesPerson
where BusinessEntityID <=286
union
select * from  Sales.SalesPerson 
where BusinessEntityID <=280

--	Step 4 — 查詢兩邊都有的交集資料 (INTERSECT)

select * from Sales.SalesPerson
where BusinessEntityID <=286
intersect	
select * from  Sales.SalesPerson 
where BusinessEntityID <=280

--	Step 5 — 查詢只屬於 <=286 的資料（排除 <=280 有的）

select * from Sales.SalesPerson
where BusinessEntityID <=286
except
select * from  Sales.SalesPerson 
where BusinessEntityID <=280

--	Step 6 — 查詢只屬於 >=280 的資料（排除 <=286 的）

select * from Sales.SalesPerson
where BusinessEntityID >= 280
except
select * from  Sales.SalesPerson 
where BusinessEntityID <=286
