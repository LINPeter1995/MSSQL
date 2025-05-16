--	Module 4   02.Lab - Clustered Table.sql

--  �O������(Clustered): �@��SQL Server��ƪ��u�|���@���O������(�D����)�A�|��������
--					�i�Ѥ@�өΦh�����զ���@�νƦX����, �O�����ޱN��ƪ����˵�������ƦC
--					�̨�"��������ȱƧǻP�x�s"�C 


--	B tree (Balance Tree)
--	https://blog.niclin.tw/2018/06/18/%E4%BB%80%E9%BA%BC%E6%98%AF-b-tree-balance-tree/


--	Step 1: �ϥΡiLabDB2�j��Ʈw
use  LabDB2 ;
go

drop table if exists PhoneLog ;

-- Step 2: Create a table with a primary key specified.  means it is Clustered Table
create table PhoneLog(
	PhoneLogID int identity(1, 1)  primary key,          --  Clustered
	LogRecorded datetime2  not null,
	PhoneNumberCalled  nvarchar(100)  not null,
	CallDurationMs  int not null
);


-- Step 3: Query sys.indexes to view the structure
-- (note also the name chosen by SQL Server for the constraint and index)
select * from sys.indexes
where object_id = object_id('PhoneLog');		-- index_id = 1, type_desc = 'CLUSTERED'
go

select * from sys.partitions
where object_id = object_id ('PhoneLog');		-- index_id = 1,
go        

-- Step 4: Drop the table
