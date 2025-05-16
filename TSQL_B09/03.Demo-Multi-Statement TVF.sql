--	Module 09.   03.Demo - Multi-Statement TVF.sql

--  �h���y�y��ƪ��Ȩ�� (Multi-Statement TVFs) : ������Ƥ��e�]�t "�h�ӱԭz"�A
--  �|�^�� table ���O����ƶ�

--	�n�ŧi�@�� "��ƪ��ܼƪ����c", �ñN�{������L�{�������~��ƥ���Ȧs�즹�@��ƪ��ܼƤ�,
--  ���{�ǳ�������, �b�Ǧ^��@ Table ��ƫ��A���̲׵��G��

drop function if exists tvf_Book

create function tvf_Book(@ISBN as int)
returns @myBook table(							-- return table variable
	myISBN nvarchar(20),
	myTitle nvarchar(50),
	myRleaseDate date,
	myPublishID int
)
as
begin
    Insert @myBook			-- �N�U�C select �X�Ӫ��� insect �� @ myBook �� (insert table values)
	select ISBN, Title, ReleaseDate, PublisherID
	from Book 

	delete @myBook where myISBN = @ISBN
	return
end;
go

select * from tvf_Book(6)
select * from Book

select * from @myBook

-- example 2 : �h���y�y��ƪ��Ȩ�� �ϥ� JOIN

create function fn_GetOrder(@OrderID as int )
returns @myOrder table(
	myOrderID int,
	myCustomerID nchar(5),
	myShipCity nvarchar(15)
)
as
begin
	insert	@myOrder
	select OrderID, CustomerID, ShipCity from Northwind.dbo.Orders where  OrderID = @OrderID
	return
end

select * from fn_GetOrder(10248)

select o.myOrderID, o.myCustomerID, o.myShipCity, od.ProductID -- Orders.OrderID ����ҸW��i
from  fn_GetOrder(10248) as o
join Northwind.dbo.[Order Details] as od
on o.myOrderID = od.OrderID



-- Demo

-- Step 1 - Open a new query window to the MarketDev database on the Marketing server
use  MarketDev ;

--  check : MarketDev �� �i�{���� �� ��� �� ��ƪ��Ȩ�� �� dbo.StringListToTable(�k��) �� �ק�

-- Step 2 - Select from the dbo.StringListToTable function
declare  @CustomerList  nvarchar(200) ;
set  @CustomerList = '12, 15, 99, 214, 228, 917' ;
select  *  from  dbo.StringListToTable(@CustomerList, ',')   -- MarketDev �w�ئn�� TVF function



-- Step 3 - Try a different delimiter
declare @CustomerList nvarchar(200) ;
set  @CustomerList = '12|15|99|214|228|917' ;
select  *  from  dbo.StringListToTable(@CustomerList , '|')  ;
go

