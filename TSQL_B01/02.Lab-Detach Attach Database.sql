--	Module 01 : 02.Lab - DROP DATABASE.sql

-- 1-2 : �p������P���[��Ʈw
use master
go

--  �i�H�N��Ʈw����ƩM����O���ɨ����A�M��A���s���[�ܬۦP�Τ��P�� SQL Server�������C
--  �Y�n�N��Ʈw�ܧ�ܦP�@�x�q���W�����P SQL Server �������A�έn���ʸ�Ʈw�A
--  �����M���[��Ʈw�۷��ΡC

--	"����" ��Ʈw (xxxxx ��Ʈw (�k��) �� �u�@ �� ����),  
--  "���["��Ʈw (��Ʈw �� ���[ �� �[�J �� ......) 

-- "����" ��Ʈw
-- skipchecks �]�� true ����Ʈw����, ���w�O�_���L�ΰ����s�έp��ơC


exec sp_detach_db 'Class', 'true'			-- sp : Stored Procedure,      sys.databases


--  �z�L���[�i�N�ثe���ϥΧe�{�������A����Ʈw�[�J�A�p�G���ݭn�ɥi�N������A
--	�קK���Өt�θ귽�A���ɺ޲z�Ĳv�A(�Y�Ӹ�Ʈw "�ϥΤ�" �|�L�k�����A�Ҧp:�d�ߵ����ϥΤ�)


--  "���["��Ʈw
exec sp_attach_db @dbname = 'Class',
@filename1 = 'c:\Temp\Class.mdf',
@filename2 = 'c:\Temp\Class_ndf.ndf'


--	Drop the  TestDB  Database if it already exists 
if db_id('class') is not null
begin
	drop database Class;
end


drop database if exists Class		-- ��Ʈw�]�i�H�o�� drop

--  �˵� C:\Temp,  Class.mdf, ndf, ldf �����F


--	2017/ 2019 SQL Server  (p19-23)

--  1-3 : �p��פJ�P�ץX���

--	��Ʈw�ץX
--		��Ʈw(�k��) Northwind(�k��)�� �u�@ �� �ץX���
--		��ƨӷ� : Microsoft OLE DB Provider for SQL Server
--		�ت��a : Microsoft Excel / csv Flat File Source �� ���| �� �ɦW


--	��Ʈw�פJ
--		��ƮwNorthwind(�k��) �� �u�@ �� �פJ���
--		��ƨӷ� : Microsoft Excel / csv Flat File Source �� �ɮ׸��|
--		�ت��a : Microsoft OLE DB Provider for SQL Server
--		�ت��a : [dbo].[xxxx���Jtable �W��] table �W��
--		�ت��a�طs���W�r(���i�ΥH�s�b���ɦW, �]�����O append)


--  ��Ʈw�ƥ�
create database backup_test
--		��Ʈwbackup_test(�k��) �� �u�@ ���ƥ�



--  ��Ʈw�٭�
drop database backup_test
--		��Ʈw(�k��) �� �٭��Ʈw �� �˸m �� ... 
