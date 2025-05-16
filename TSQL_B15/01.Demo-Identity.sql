 --	Module 15 ���ͬy��������k
--		15-1:�z�L�ϥθ�ƪ����ѧO���-IDENTITY�ݩ�
--		15-2:�p����o�ѧO��쪺��:	@@IDENTITY vs. SCOPE_IDENTITY vs. IDENT_CURRENT
--		15-3:�z�L���Ǫ���(Sequences) �Ӳ��ͧǸ�

--		�إ߸�ƪ����ѧO���C �o���ݩʷ|�f�t CREATE TABLE �M ALTER TABLE T-SQL ���z���ϥΡC
--		�y�k : IDENTITY [ (seed , increment) ]
--						seed  �˸�������Ĥ@�Ӧ�ҨϥΪ��ȡC
--						increment  �W�q�ȡA�ӭȳQ�s�W��e�@�Ӥw�˸����檺���ѭȤW�C
--						�����P�ɫ��w�ؤl�M�W�q�A�Ϊ̤G�̳������w�C�p�G�G�̳������w�A�h���w�]�� (1,1)�C

--		�p�G�b�g�`�i��R���ާ@�����s�b�ۼ��ѦC�A����b���ѭȤ����i��|���ͮt�Z�C
--		�p�G�o�c���F���D�A����Ф��n�ϥ� IDENTITY �ݩʡC���O�A���F�T�O�����ͮt�Z�A
--		�Ϊ̬��F���ɲ{�����t�Z�A�b�� SET IDENTITY_INSERT ON �㦡�a��J���ѭȤ��e�A
--		�Х���{�������ѭȶi��p��C
--	01.Demo - IDENTITY.sql

--	Step 0: Open a new query window to the tempdb database
use  LabDB2  ;
go

--	Step 1-1: Create the dbo.Opportunity table
create table Opportunity01 ( 
	  OpportunityID  int identity (1,1) not null ,
	  Requirements  nvarchar(50)  not null  ,
	  ReceivedDate  date  not null  ,
	  LikelyClosingDate  date  null ,
	  SalespersonID  int  null ,
	  Rating  int  not null 
) ;

create table Opportunity02 ( 
	  OpportunityID  int identity (1,1) not null ,
	  Requirements  nvarchar(50)  not null  ,
	  ReceivedDate  date  not null  ,
	  LikelyClosingDate  date  null ,
	  SalespersonID  int  null ,
	  Rating  int  not null 
) ;
--	Step 1-2: Populate the table with 2 rows
insert Opportunity01
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ,
           ('n.d.', sysdatetime(), DateAdd (month,2, sysdatetime()), 37, 2) ;


--	Step 1-3: Check the identity values added
select * from Opportunity01 ;
select  ident_current ('Opportunity01'),  scope_identity (), @@identity  ;


--	 ident_current : �|�Ǧ^�b���N�u�@���q�B���N�d�򤤡A���͵� �u�S�w��ƪ�v���̫�@���ѧO�ȡC
--	scope_identity	: �|�Ǧ^�b �u�ثe�u�@���q�v�H�Ρu�ثe�d��v���A�u���N��ƪ�v ���ͪ��̫�@���ѧO�ȡC
--	@@identity		: �|�Ǧ^�u�ثe�u�@���q�v ���u�Ҧ����d��v�A�u���N��ƪ�v�Ҳ��ͪ��̫�@���ѧO�ȡC


-- Step 1-4: Try to insert a specific value for OpportunityID. This will
--         "fail"  as you cannot insert an explicit identity column value in this way.
insert Opportunity01
	(OpportunityID, Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values (5, 'n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;
select * from Opportunity01 ;					-- error 


--	�y�������令�H����ʵ��Ȥ覡
set identity_insert Opportunity01 on ;			--	identity_insert on
insert Opportunity01
	(OpportunityID, Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values (8, 'n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;

select * from Opportunity01 ;

insert Opportunity 01
	( Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;				-- error 

select * from Opportunity01 ;

--�y��������^�t�Φ۰ʵ��Ȥ覡
set identity_insert Opportunity01 off ;			--	identity_insert off



insert Opportunity01
	( Requirements, ReceivedDate, LikelyClosingDate, SalespersonID, Rating)
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ;
go 5

select * from Opportunity01 ;

select  ident_current ('Opportunity01'),  scope_identity (), @@identity  ;


--	Opportunity 01
insert Opportunity02 
values ('n.d.', sysdatetime(), DateAdd (month,1, sysdatetime()), 34, 9) ,
           ('n.d.', sysdatetime(), DateAdd (month,2, sysdatetime()), 37, 2) ;

select * from Opportunity01
select * from Opportunity02
select  ident_current ('Opportunity01'),   ident_current ('Opportunity02'), scope_identity (), @@identity  ;




--	scope_identity (), @@identity ���t�O
create table t1(id int identity(1, 1));  
create table t2(id int identity(150,10));

insert t1 default values
go 5

select * from t1
select  @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;

insert t2 default values
go 5

select * from t2
select  @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;


--  �إߤ@Ĳ�o �{�� ��t1 insert �N�۰ʦb t2 �]insert default
create trigger tg_t1_insert on t1
for insert
as
begin
	insert t2 default values
end;

--  �bt1�� insert values 
insert t1 default values;
select * from t1;
select * from t2;
select  @@identity, scope_identity (), ident_current ('t1'), ident_current ('t2') ;

drop table if exists t1, t2
