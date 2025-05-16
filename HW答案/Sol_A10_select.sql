-- 請練習撰寫底下指令 : 使用 Northwind.Customer 客戶資料表

-- Step 01 打開 Northwind 資料庫 
use Northwind
go


-- Step 02 從dbo.Customers table 中, 挑選 所有 客戶欄位 資料
select * from Customers;


-- Step 03 挑選 所有 客戶欄位 資料，並用 "城市" 排序
select * from Customers order by City;


-- Step 04 挑選 客戶 資料中指定英文欄位：客戶代號, 公司名稱, 聯絡人姓名, 聯絡電話
select CustomerID, CompanyName, ContactName, Phone from Customers;


-- Step 05 延續上題，請將欄位名稱分別改成以中文別名 客戶編號, 公司名稱, 聯絡人, 連絡電話顯示
select	CustomerID as '客戶編號', 
			CompanyName as 公司名稱, 
			ContactName '聯絡人' ,
			Phone '連絡電話'
from Customers;


-- Step 06  挑選 客戶資料中指定欄位：客戶編號, 公司名稱, 聯絡人, 連絡電話
--					挑選出 國家是 "德國" 資料列
select CustomerID, CompanyName, ContactName, Phone , Country
from Customers 
where Country = 'Germany';


-- Step 07 承上題  
--					在語法查詢中建立一欄位 ( 國家 +' / '+城市) 並欄位名稱給與別名 '國家 +' / '+城市 '
--					同時挑選 國家德國，墨西哥, 英國資料列
select CustomerID, CompanyName, ContactName, Phone, Country +'  /  '+City as 'Country / City'
from Customers 
where Country in ( 'Germany', 'Mexico', 'UK');
--where Country = 'Germany' or Country = 'Mexico' or Country = 'UK'



-- Step 08 承上題  加入包含 客戶編號 中包含 AN 的資料
select CustomerID, CompanyName, ContactName, Phone, City+' /  '+Country as 'City / Country'
from Customers 
where Country in ( 'Germany', 'Mexico', 'UK') and CustomerID like '%an%'



-- Step 09  承 Step 07  並依照 國家(大到小),  城市(小到大) 排序
select CustomerID, CompanyName, ContactName, Phone, Country, City, Country +' , '+City as 'Country , City'
from Customers 
where Country in ( 'Germany', 'Mexico', 'UK')
Order by Country desc, City asc
