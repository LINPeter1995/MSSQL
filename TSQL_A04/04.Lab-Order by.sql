--	Module 4 - Lab04 �ϥ� ORDER BY �l�y�N�d�ߵ��G�Ƨ�
--		ORDER BY ����r (SQL ORDER BY Keyword)
--		�N SELECT ���o����ƶ��̬Y���ӧ@�ƧǡA�ӱƧǤ��O�i�H
--					�Ѥp�ܤj (ascending; �w�] / asc)�A	�ΥѤj�ܤp (descending / desc)�C

--  �̾ګ��w����Ʀ�M��ƧǬd�ߪ����G���A�ÿ�ܩʦa�N�Ǧ^����ƦC����b���w�d�򤺡C 
--  ���D���w ORDER BY �l�y�A�_�h���O�ҵ��G�����Ǧ^��ƦC�����ǡC

--  ���w�n�ƧǬd�ߵ��G������Ʀ�ιB�⦡�C �ƧǸ�Ʀ�i�H���w���W�٩θ�Ʀ�O�W�A
--			�ΥN�����M�椤��Ʀ��m���D�t��ơC

--  �z�i�H���w�h�ӱƧǸ�Ʀ�C ��Ʀ�W�٥����O�ߤ@�W�١C ORDER BY �l�y�����ƧǸ�Ʀ涶��
--			�Ψөw�q�Ƨǵ��G������´�C �]�N�O���A���G���̾ڲĤ@�Ӹ�Ʀ�ӱƧǡA�M��ӱƧǪ��M��
--			�̾ڲĤG�Ӹ�Ʀ�ӱƧǡA�̦������C

--  ORDER BY �l�y���ҰѦҸ�Ʀ�W�٥������������M�椤����Ʀ�A�λy�N���T�� 
--			FROM �l�y���ҫ��w��ƪ��w�w�q��Ʀ�C �p�G ORDER BY �l�y�Ѧҿ���M�椤��
--			��Ʀ�O�W�A��Ʀ�O�W������W�ϥΡA�Ӥ��O�b ORDER BY �l�y���@���Y�ӹB�⦡���@����

use Northwind;
go

-- ��X CustomerID �� V�r���}�Y��orders
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like 'V%'


--�H CustomerID �� V�r���}�Y, ShipCity �ƧǡA�]�����w�ƧǤ覡�A�|�ϥιw�](ASC)
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like 'V%'
order by ShipCity


--�ƧǨ̾ڪ�������å��]�t�bSELECT���M�椤
select OrderID, CustomerID, Freight, ShipName, ShipPostalCode
from Orders 
order by ShipCity           -- ShipCity ���]�t


--�̧O�W�Ƨ�
select OrderID, CustomerID, Freight, ShipCity as  'C_NAME', ShipName, ShipPostalCode
from Orders 
order by C_NAME  desc                         -- C_NAME


--�ϥιB�⦡�����ƧǸ�Ʀ�
select * from dbo.Orders 

select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
order by datepart(month, OrderDate)  -- try month, day


--���w�����
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
order by OrderDate desc;


--���w���W����
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
order by OrderDate  asc; 


select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
--order by Freight
order by 3                          --  3 is column index location


--���w���W�M�����
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
where Freight >10
order by OrderDate desc, Freight asc;


--top 5 �H���üƱƧ�
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
where Freight >10
order by newid(); 


--�f�t ROW_NUMBER ���,��ܸ�ƦC���X, �å� * ���Ǧ^��ƪ�Ҧ������
--select row_number () over (order by OrderID) as ROWID,
select row_number () over (order by CustomerID) as ROWID,
OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
--order by OrderDate
order by CustomerID, OrderDate


