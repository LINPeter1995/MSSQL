-- 請練習撰寫下列指令，使用 AdventureWorks 資料庫

-- step0  先將資料庫切換到 LabDB2
use LabDB2

-- step1 : 先觀察 AdventureWorks.Purchasing.PurchaseOrderDetail 所有欄位

select * from AdventureWorks.Purchasing.PurchaseOrderDetail



-- step2 : 請算出 step1 資料表中DueDate年度月份下 LineTotal 欄位總和, 並將該資料表以區域性
-- 暫存檔放在 tempdb 下

drop table if exists #temp, #temp01


-- solution 01
select year(DueDate) as yy, month(DueDate) as mm, sum(LineTotal) as subtotal into #temp01
from AdventureWorks.Purchasing.PurchaseOrderDetail
group by year(DueDate), month(DueDate)
order by yy,mm

select * from #temp01
order by yy, mm

-- solution 02
select convert(varchar(7), DueDate, 126) as yymm, sum(LineTotal) as subtotal into #temp
from AdventureWorks.Purchasing.PurchaseOrderDetail
group by convert(varchar(7), DueDate, 126)
order by yymm

select * from #temp
order by yymm


-- step3 : 觀察剛建立在 tempdb下的檔案所有欄位

select * from #temp


-- step4 : 將 tempdb 下的檔案利用 lag offset 一位, 查詢後資料再以全域性暫存檔寫入tempdb
drop table if exists ##temp
select *, lag(subtotal,1,0) over (order by yymm) as 'post_yy'  into ##temp
from #temp

select *, lag(subtotal,1,0) over (order by yy, mm) as 'post_yy' into ##temp01 from #temp01
order by yy, mm

select * from ##temp


-- step5 : 觀察剛建立在 tempdb下的檔案所有欄位
select * from ##temp



-- step6 : 利用剛建立的tempdb檔計算出 成長率(不含%)
select *, iif(post_yy!=0,(subtotal-post_yy)/post_yy*100, 0) as growth
from ##temp


-- step7 : 利用剛建立的tempdb檔計算出 成長率(不含%), 成長率(含%)
select *, 
		 iif(post_yy!=0,(subtotal-post_yy)/post_yy*100, 0) as growth,
		str(iif(post_yy!=0,(subtotal-post_yy)/post_yy*100, 0))+'%' as [growth%]
from ##temp
