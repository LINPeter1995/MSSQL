--	Module 08 ?w?s?{??(Stored Procedure)???i???[???B?]?p?P??@
--		08-1 : ?p?????@?a???????w?s?{??    
--		08-2 : ?p?????a???????w?s?{??    
--		08-3 : ?p??q?w?s?{??N????^?????£`{??

--		Procedure ???T???? :
--			Input parameters (arguments)
--			Output parameters (arguments)
--			Return code

use LabDB2
-- drop table if exists Book

---- Step 2: Create a table:  dbo.Book

create table Book(
ISBN  nvarchar(20)  primary key ,
Title  nvarchar(50)  not null ,
ReleaseDate  date  not null ,
PublisherID  int  not null
) ;

select * from Book

-- Proc_C Encryption ????i?J proc
drop proc if exists Proc_C

create proc Proc_C
	@ISBN nvarchar(20), @title nvarchar(50), @ReleaseDate date, @Publisher int
with Encryption									--	Encryption
as
insert Book values (@ISBN, @title, @ReleaseDate, @Publisher)

exec Proc_C '6', 'Tommy story', '2000-1-1', '45'
exec Proc_C '7', 'John story', '2020-1-1', '65'
select * from Book



-- Proc_D ????X?? proc
drop proc if exists Proc_D

create proc Proc_D  @total int output					--  ?w?q total ?O output,  ????J??????
as
select @total =sum(UnitPrice) from Northwind.dbo.[Order Details]


declare @sum int		
exec Proc_D @sum output									-- @sum ????^?? @total int output
print 'total price : ' + cast(@sum as varchar)

exec sp_helptext 'Proc_C'		--  Encryption
exec sp_helptext 'Proc_D'		--  non Encryption

select * from sys.sql_modules where object_id =object_id ('Proc_C')
select * from sys.sql_modules where object_id =object_id ('Proc_D')



--  ??G

--	01.Lab - Stored Procedure with parameters.sql

-- Step 1: Open a new query window to the AdventureWorks database
use  LabDB2 


-- Step 2: Drop stored procedure if it already exists
drop proc if exists GetReviews ;


-- Step 3: Create procedure to output number of reviews and check product exists
--  create proc ?{??W??  @??J???, @??X??? output
 create proc GetReviews 	@ProductID int = 0, @NumberOfReviews int output	   -- default values
 as
 if (@ProductID) = 0								--	??J?w?]?? 0 ?? ?? ???  0
	 select p.Name, pr.ReviewDate, pr.ReviewerName, pr.Rating, pr.Comments, p.ProductID
	 from AdventureWorks.Production.ProductReview as pr
	 join AdventureWorks.Production.Product as p
	 on p.ProductID = pr.ProductID
	 order by p.Name, pr.ReviewDate desc
else
	if exists (select 1 from AdventureWorks.Production.Product where ProductID = @ProductID )
		 select p.Name, pr.ReviewDate, pr.ReviewerName, pr.Rating, pr.Comments, p.ProductID
		 from AdventureWorks.Production.ProductReview as pr
		 join AdventureWorks.Production.Product as p
		 on p.ProductID = pr.ProductID
		 where pr.ProductID = @ProductID					--	?u join @ProductID
		 order by p.Name, pr.ReviewDate desc
	else
		return -1
set @NumberOfReviews = @@rowcount 
return 0


-- Test 1-1: Test output and return values (positional arguments)
declare		@NumReviews int,	@ReturnValue int
exec			@ReturnValue = GetReviews 937,	@NumReviews output  --??ReturnValue ???? reture 0 or -1 ??
if (@ReturnValue =0)			--		ReturnValue as an index 0
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 1-2: Test output and return values (keyword arguments)
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews  @NumberOfReviews=@NumReviews output,  @ProductID = 937  
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 2: Test output and return values(@ProductID = 937 ?? 600)
declare		@NumReviews int,	@ReturnValue int
exec			@ReturnValue = GetReviews 600,  @NumReviews output  
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 3: Test output and return values (Remove OUTPUT )(positional arguments)
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews 937,	@NumReviews		-- remove 'output' ?L?k?^??@NumReviews
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 4: Test output and return values(@ProductID = 937 ?? Default (ProductID=0) )
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews default,	 @NumReviews output					
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Test 4-1 : remove @ProdcutID in order to use default,  keyword on @NumberOfReviews
declare		@NumReviews int,  @ReturnValue int
exec			@ReturnValue = GetReviews							 -- remove default, same as defualt
				@NumberOfReviews=@NumReviews output  -- key argument ???????, ???M??m?|???
if (@ReturnValue =0)
	select @NumReviews as NumberOfReviews
else
	select 'ProductID does not exist' as ErrorMessage



-- Step 5: Drop the procedure
drop proc  if exists GetReviews ; 
go

