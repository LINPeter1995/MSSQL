-- �нm�߼��g���U���O�A�ϥ� AdventureWorks.Sales.SalesPerson ��Ʈw
-- ����� BusinessEntityID <=286 �M >=280 ���j�����select
-- �[�� row ���ܤ�

-- step1  ���N��Ʈw������ AdventureWorks
use AdventureWorks ;
go


--	step2  �������|�Ǧ^���ƪ��Ҧ����C�]�t"���ƪ��C"
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
union all
select *	 from Sales.SalesPerson
where BusinessEntityID >=280



--	step3  �������|�Ǧ^���ƪ��Ҧ����C"���ƪ��C�n�ߤ@"
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
union
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	step4  �Ǧ^���ƪ��@�����C
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
intersect
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	step5  �Ǧ^�u�ݩ� (<= 286 ��ƪ�) ���C
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
except
select *	 from Sales.SalesPerson
where BusinessEntityID >=280


--	step6 �Ǧ^�u�ݩ� (>= 280 ��ƪ�) ���C
select *	 from Sales.SalesPerson
where BusinessEntityID >=280
except
select *	 from Sales.SalesPerson
where BusinessEntityID <=286
