--  Module 11 ��쬰�ŭȮɪ��d���H�αN�d�ߪ����G���H�Ƨ�
--		11-1 : Null Value (�ŭ�)���N�q, �ϥ� IS NULL �B��l
--		11-2 : IIF()�BCHOOSE()�BCASE �B�⦡ 
--		11-3 : �ϥ� ORDER BY �l�y�N�d�ߵ��G�Ƨ�
--		11-4 : �t�Τ��ب���ƾ�

--	NULL �O��Ʈw���ϥΪ��S��аO�A�N���O�������ݩʭ� (unknown property value)�C
--	NULL �O�@�ت��A�A���O�Ŧr��(�w��r���Τ������)�A�]���O�s��(�w��ƭ�����)�C
--	�N Null �����Ω��޿�B��O�S���N�q���C����ƭȻP Null �i��B��䵲�G���� Null �C
--  �b WHERE ������P�_�O�_�� NULL �ɡA�Ҧp  WHERE [address]=NULL �O�L�k���T���檺�A
--				�����g�� WHERE [address] IS NULL �άO WHERE [address] IS NOT NULL 


--	Lab01 �d�� NULL , IS NULL �� IS NOT NULL
use Northwind;
go

select 'Won'+null+'derful'				-- NULL is weired

select * from Orders						

--	show Null ���
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName
from Orders 
--where Freight = null           -- ���M����W���|���Ϳ��~�A���O�O�L�k�o�X���T�����G�C
where Freight is null


--	Null �B�� NULL * NULL = NULL            EmployeeID*Freight
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName, EmployeeID*Freight
from Orders 


--	Null �r��ۥ[ NULL + NULL = NULL   CustomerID+ShipName
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName, CustomerID+ShipName
from Orders


--	ISNULL �禡�O�P�_��쪺�ȡA�Y�� Null ���ɡA�i�H�N Null ���N���ۤv�ҭn���ȡC
--	�b���Ʀr�B��ɡA�i�H���P�_���p�G�� Null�A�N�������w�]�� 0�A�A���p��
--	�Ϋ��w���w�]�ȨӥN��NULL
select OrderID, EmployeeID, isnull(EmployeeID, 0) as EmpID, CustomerID, Freight, 
			ShipCity, ShipName, isnull(CustomerID+ShipName, 'info missing')
from Orders


--	COALESCE �|�Ǧ^�B�⦡���Ĥ@�ӫD Null ���ȡA�U�C�|�Ǧ^�ĤT�ӭȡC
--	COALESCE ���޼Ʀܤ֭n���@�ӬO�D Null �`�ƪ��B�⦡�C

--	ISNULL ��ƩM COALESCE �B�⦡�㦳�ۦ����ت��A���B�@�覡���P�C
--	ISNULL �u�|�����@���C COALESCE �|�����h���B�⦡����J�ȡC
--	ISNULL �u������ӰѼơACOALESCE �����ƥؤ��w���ѼơC

select coalesce (null, null, 'third_value', 'fourth_value');

--	Error : COALESCE ���޼Ʀܤ֭n���@�ӬO�D NULL �`�ƪ��B�⦡�C 
select coalesce (null, null, null, null, null);

--	�Ǧ^�B�⦡���Ҧ���줤,�Ĥ@�ӫD Null ����
select OrderID, EmployeeID, Freight, CustomerID, ShipName, ShipCity, 
	coalesce (CustomerID, ShipName,  ShipCity) as FirstNotNull_coalesce,  
	isnull (CustomerID, isnull(ShipName, ShipCity)) as FirstNotNull_isnull 
from Orders


--	��Xorders ��ƪ��AEmployeeID is not null �BFreight�p��10�����
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName
from Orders
where EmployeeID is not null and Freight < 10


--	��X�� shipname ���Ҧ� orders
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName
from Orders
where ShipName is not null			-- try ShipName != NULL
order by CustomerID                  -- �Ƨ�


select  * from Orders

--	�U�C�d�ҷ|�M��q���ƪ��Ҧ�Freight , ShipVia �ƭȪ��[�v������
--	�|�N Weight �������줤�� 10 �Ө��NNULL
select  avg(isnull(Freight, 10)),  avg(Freight), avg(ShipVia),  avg(ShipVia*1.0), avg(convert(decimal, ShipVia))
from Orders;  

select sum(isnull(Freight, 10)),  sum(Freight), sum(ShipVia), sum(ShipVia*1.0), sum(convert(decimal(10, 2), ShipVia))
from Orders;  

--	IS NULL �� IS NOT NULL �P�_�B�⦡�O�_�� NULL�A�öǦ^���L�ȵ��G�C
--	IS NULL : �p�G�P�_�����ȬO Null�A�N�|�Ǧ^ true�F�_�h�|�Ǧ^ false
--	IS NOT NULL : �p�G�P�_�����ȬO Null�A�N�|�Ǧ^ false�F�_�h�|�Ǧ^ true
--	WHERE ���󦡥h�P�_ id ���O�_�� Null �ɡA�����g�� where id is null �F�Ϥ��Y�n�P�_�� id ���O�_���D Null �ɡA�h�� where id is not null
--	where id = null ���M����W���|���Ϳ��~�A���O�O�L�k�o�X���T�����G�C
