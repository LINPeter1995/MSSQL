
-- CRUD

-- C : �W�[ / �إ�		Create
-- R : �d�� / Ū��		Read	
-- U : �勵 / ��s		Update	
-- ��: �R��				Delete


-- �H�U�O���u��� :
-- id			first name			last name		salary			birthday
-- 100		�p��						��				30000.5		2000-01-01
-- 200		����						��				40000.8		1998-02-01
-- 300		�j��						�i				45000.9		1995-03-01
-- 400		�p��						��				35000.1		2002-05-01

--  �нm�߼��g�H�U"���O", �Ш��D�N�^��


--  1.  �Ф����� LabDB ��Ʈw�U, �P�� drop ��, �p�G�w�s�b�� table  employee 

use LabDB;
go
Drop table If EXISTS Table_employee;
go

--  2.  �Х��إߤ@employee ��ƪ�ȥ]�t �U�C�|�����, id �O primary key  (��� birthday �����n�إ�)
--       id			first name			last name		salary(���󭭨� ���i�j��200,000)

create table Table_employee(
      ID int PRIMARY KEY IDENTITY,
      firstname nvarchar(max)not null,
      lastname nvarchar(max)not null, 
      salary decimal(30,1)not null check (salary > 200000 )
	  );

select*from Table_employee;
go
-- 3.  �Х��λy�k insert �s�W���u�򥻸�� id firstname lastname salary

Set Identity_Insert Table_employee ON;
Insert Table_employee
(ID, firstname, lastname, salary)
values 
('100','�p��','��','30000.5'),
('200','����','��','40000.8'),
('300','�j��','�i','45000.9'),
('400','�p��','��','35000.1');
Set Identity_Insert Table_employee OFF;
select*from Table_employee;
go


-- 3.1 ���� insert �@���~�� 300,000 �[����~�T��, �N��ܪ����~�T���ƻs/�K�b���夤

Set Identity_Insert Table_employee ON;
Insert Table_employee
(ID, firstname, lastname, salary)
values 
('','','','300000');
Set Identity_Insert Table_employee OFF;
select*from Table_employee;
go


--  4.  �d�ߤ@�U�Ҧ����u���

select * from table_employee


--  5.  �d�ߤ@�U�~���j��40000 �Ҧ����u���, �å��~���� �Ѥj��p�Ƨ�

select*from  Table_employee
where salary > 40000
Order by salary DESC


--  6.  �N��ƪ� employee �W�[�@"�ͤ����", 
--  �դ@�ձN"�ͤ����"�]�� not null �M null ���t�O, ���G���P������? �бN���~�T���K�W�Y�i

Drop table If EXISTS Table_employee;

create table Table_employee(
      ID int identity(1,1) primary key,
      firstname nvarchar(max)not null,
      lastname nvarchar(max)not null, 
      salary decimal(30,1)not null check (salary > 200000 ),
	  Birthday date)

Set Identity_Insert Table_employee ON;
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('100','�p��','��','30000.5','1983-05-15')
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('200','����','��','40000.8','1990-11-30')
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('300','�j��','�i','45000.9','2005-02-25')
INSERT INTO Table_employee (ID, firstname, lastname,salary,birthday) VALUES ('400','�p��','��','35000.1','1999-06-19')
Set Identity_Insert Table_employee OFF;
select*from Table_employee;
go


--  7.  ���N��ܤT�ӭ��u�s�� �ק�  �ͤ���


Update table Table_employee


-- 8.  �p��@�U�Ҧ����u�~���`�M

SELECT SUM(salary)
FROM Table_employee

-- 9.  �p��@�U���u�ӧO���~��(�~��~�Y�i)




-- 10. �ЦC�L�X�~��̤֭��u���Ҧ����

SELECT MIN(salary)
FROM Table_employee
print ID, firstname, lastname,salary,birthday;


-- 11.  �ЧR�� ���p�� �H�Ƹ��

select * from Table_employee
delete Table_employee (ID, firstname, lastname,salary,birthday) 
VALUES ('100','�p��','��','30000.5','1983-05-15');
go



-- ú��@�~�бH��@�U�H�c :
-- Email : jungan0914@gmail.com