1--	Module 3 ���g²���� SELECT �d�߻y�y
--		3-1 : SELECT �d�߻y�y
--		3-2 : �ϥ����?(Column) ���O�W
--		3-3 : �ϥ� DISTINCT

--	SELECT �O�̱`�Ψ쪺 SQL �y�y�A���O�Ψӱq��?�w���o��?�A�o�Ӱʧ@�ڭ̳q�`�٬��d��(query)
--	SELECT �i�H�q SQL Server �����@�өΦh�Ӹ�?�����A����@�өΦh�Ӹ�?�� column�C
--	�t�X�ϥΪ��l�y�y�j�h�O�Ω�z���ƪ�����A�|�b�᭱���`�J�Ӫ����U�ؤl�y�y����C
--	SELECT �᭱�� * ���N���Ǧ^��?�����Ҧ����C
--	FROM ��ұ�����ƪ��W�٬��ݬd��?�w��"��?���W��" table name�C
--	SELECT �]�i�H�Ω�p��A�p : SELECT (1+1);

--  TSQL Select ����y�k : 
--			SELECT select_list [ INTO new_table ]
--			[ FROM table_source ]
--			[ WHERE search_condition ]
--			[ GROUP BY group_by_expression ]
--			[ HAVING search_condition ] 
--			[ ORDER BY order_expression [ ASC | DESC ]]
--	https://docs.microsoft.com/zh-tw/sql/t-sql/queries/select-transact-sql?view=sql-server-ver15


--	�b�t�ζ}�o�ɡA�Y�D���n�ɶq�קK�ϥ� SELECT *�A�|�ӶO���h���t�θ귽�A
--			�C���d�߮ɨ��o�ݭn�����Y�i�C

--	�i�H�Ǧ^ *,  column_name ��?�������w�����C
--	COUNT(*) �i�H�Ǧ^��?�����ҥ]�t����?���ơC
--	TOP(n) �i�H���w�Ǧ^��?���ƶq�C


--	Lab01 SELECT �d�߻y�y
use Northwind;
go

--	1.  SELECT �]�i�H�Ω�p��A�p : SELECT (1+1);
select 1+1
print(1+1)

select sin(3.14)


--  2.  SELECT �d�߻y�y
-- �Ǧ^�Ҧ���?�C
select * from Employees;

-- �Ǧ^�S�w���?
select * from Employees

select LastName+' / '+FirstName as name, Title, BirthDate
from Employees;

--	�f�t ROW_NUMBER ���?,��ܸ�ƦC���X, �å� * ���Ǧ^��?���Ҧ������?
select row_number() over (order by EmployeeID desc) as rowid, * 
from Employees;

--	�Ǧ^�S�w���ƪ���?�C, �S��tail �� bottom 
select top 4 * from Employees
--where TitleOfCourtesy='Ms.';

--	�Ǧ^ 50% ����?�C
select top(50) percent * from Employees 
--where TitleOfCourtesy='Ms.';

--	�Ǧ^�@���X����?��
select * from Employees where TitleOfCourtesy='Ms.';

--	SELECT ���z�����޿�B�z����
--  https://docs.microsoft.com/zh-tw/sql/t-sql/queries/select-transact-sql?view=sql-server-ver15


-- select 1 �Ǧ^���ȥi�����L�Ȩӥ�, �g�`�f�t exist �ϥ�
select  2 from Employees where TitleOfCourtesy='Ms.';					-- �s�b
select  1 from Employees where TitleOfCourtesy='MD.';				-- ���s�b


-- 3.  �ϥ� SELECT INTO �إ߸�?��
use labDB

select * into LabDB.dbo.LabDB_Orders from Northwind.dbo.Orders

select * from LabDB_Orders
