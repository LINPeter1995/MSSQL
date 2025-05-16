-- 請練習撰寫底下指令，使用 AdventureWorks.Sales.SalesPerson 資料庫
-- 用欄位 BusinessEntityID <=286 和 >=280 分隔成兩個select
-- 觀察 row 的變化

-- step1  先將資料庫切換到 AdventureWorks
use AdventureWorks ;
go


--	step2  垂直堆疊傳回兩資料表中所有的列包含"重複的列"
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
union all
select *	 from Sales.SalesPerson
where BusinessEntityID >=280



--	step3  垂直堆疊傳回兩資料表中所有的列"重複的列要唯一"
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
union
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	step4  傳回兩資料表中共有的列
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
intersect
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	step5  傳回只屬於 (<= 286 資料表) 的列
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
except
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	step6 傳回只屬於 (>= 280 資料表) 的列
select *	 from Sales.SalesPerson
where BusinessEntityID >=280
except
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
