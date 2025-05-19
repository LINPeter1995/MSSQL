-- Module 6   03 T-SQL 錯誤處理範例
-- 03-1: 使用 TRY/CATCH 來做錯誤處理
-- 03-2: 使用 RAISERROR() 主動拋出錯誤訊息範例
-- 03-3: 使用 THROW 拋出例外錯誤

-- 本章介紹在 Transact-SQL、Visual C# 及 Microsoft Visual C++ 中的錯誤處理機制，
-- Microsoft 建議在 Transact-SQL 中使用 TRY 區塊包住可能錯誤的程式碼，
-- 一旦發生錯誤即由 CATCH 區塊捕捉並處理錯誤。

-- SQL Server 的錯誤結構說明：
--   Error number 是用來識別錯誤的代碼，範圍介於 1 到 49999。
--   Severity level 表示錯誤嚴重程度，範圍是 0 到 24：
--       0-9 代表資訊訊息，對執行不造成影響。
--       10   代表警告訊息，不會中斷執行。
--       11-16 代表使用者錯誤，會中斷當前作業。
--       17-24 代表嚴重錯誤，可能導致連線中斷。
--       20-24 特別代表系統嚴重錯誤。
--   注意：嚴重錯誤通常無法由使用者捕捉且系統可能中斷作業。

--   Error message 為錯誤訊息文字，最多支援 255 個 Unicode 字元。
--   State 是錯誤狀態碼，範圍為 0 到 127，用以指出錯誤的具體狀況。



-- 01.Lab - SQL Server Error Handling.sql

-- Step 1: 開啟一個新的查詢視窗並使用 LabDB2 資料庫
use LabDB2;
go

-- Step 2: 使用 RAISERROR 產生嚴重程度為 10 的錯誤訊息
-- 注意：在結果視窗中不會顯示為錯誤

-- 這邊是提醒 RAISERROR 可自訂錯誤訊息，並且訊息會被寫入 sys.messages 系統表
-- 如果你要自訂訊息，要先在 sys.messages 新增或修改訊息
-- TRY...CATCH 可以用來捕捉錯誤，CATCH 區段處理錯誤邏輯
-- THROW 是 SQL Server 2012 以後的新語法，也可以丟出錯誤

-- RAISERROR({msg_id|msg_string}, severity, state)
-- 參數說明：msg_id 或 msg_string 是錯誤訊息的 ID 或字串，ID 範圍在 50000 以上

declare @DataBaseID int = db_id()
declare @DataBaseName sysname = db_name()
RaisError('目前資料庫 ID 為 : %d,  資料庫名稱為 : %s', 
                11,       -- 嚴重程度 Severity 11 表示錯誤
                1,        -- 狀態 State
                @DataBaseID,
                @DataBaseName);
go

-- Step 3: 11-16 是使用者錯誤，17-24 是系統錯誤，20-24 是嚴重錯誤級別

declare @DataBaseID int = db_id()
declare @DataBaseName sysname = db_name()
RaisError('目前資料庫 ID 為 : %d,  資料庫名稱為 : %s', 
                22,       -- 嚴重程度 Severity 22，通常表示嚴重錯誤
                1,        -- 狀態 State
                @DataBaseID,
                @DataBaseName);
go

-- Step 4:
-- Step 4-1: 使用 @@ERROR 來取得上一筆 SQL 指令錯誤碼
RaisError ('message', 16, 1);
--print @@error
if @@error != 0
    print '錯誤代碼 : ' + cast(@@error as varchar(8))  -- 判斷是否有錯誤

-- Step 4-2: 也可以把 @@ERROR 的值存入變數中再判斷
declare @ErrorValue int;
RaisError ('message', 16, 1);
set @ErrorValue = @@error
--print @ErrorValue
if @ErrorValue <> 0
    print '錯誤代碼 : ' + cast(@ErrorValue as varchar(8));

-- Step 5: 使用 THROW 來丟出錯誤

-- 語法: THROW [{ error_number | @local_variable},
--                 { message | @local_variable},
--                 { state | @local_variable}];
-- 參數說明：
-- error_number: 錯誤號碼，範圍 50000 到 2147483647
-- message: 錯誤訊息，nvarchar(2048)
-- state: 狀態碼，0-255 之間的整數

throw 51245, 'hi Siri. good morning', 1;

throw 50000, 'Google, good morning', 2;

throw 50001, 'Happy now', 3;

throw 888, 'Happy, Happy now', 4   -- 這裡會出錯，因為錯誤號碼必須在 50000 到 2147483647 之間

-- 範例使用 TRY...CATCH 並重新丟出錯誤
declare @d1 decimal(5, 2)
begin try  
    set @d1 = 9999.99            -- 原本應該是 99.99 (5, 2) 會超過精度，會產生錯誤
    print @d1
end try
begin catch
    --print N'錯誤代碼為' + cast(error_number() as varchar(5)) + N'，錯誤訊息為' + error_message();
    --RaisError ('message', 15, 1);
    --throw;
    throw 50000, 'O!! my God!! ', 4;      -- 丟出自訂錯誤訊息
end catch

drop table if exists TestRethrow

create table TestRethrow (id int primary key);

begin try  
    insert TestRethrow(id) values(1);  
    insert TestRethrow(id) values(1);  -- 強制產生錯誤 2627 (主鍵重複違反)
end try  
begin catch  
    --print N'錯誤代碼為' + cast(error_number() as varchar(5)) + N'，錯誤訊息為' + error_message();
    --RaisError ('message', 15, 1);
    --throw                                                          -- 重新丟出錯誤
    throw 50000, 'O!! my God!! ', 4;      
end catch;  

-- 範例：用 while 迴圈測試除以零錯誤並使用 TRY...CATCH 處理錯誤
declare @i int = 1
while @i >= (-1)
begin
    print ('@i = ' + convert(varchar, @i))
    begin try
        print ('1/@i = ' + convert(varchar, 1 / @i))
        print ('@@ERROR = ' + convert(varchar, @@ERROR))
        print ('--------------------')
        set @i = @i - 1
    end try

    begin catch
        print ('1/0 錯誤，@@ERROR = ' + convert(varchar, @@ERROR) + ', 錯誤訊息：' + ERROR_MESSAGE())
        print ('--------------------')
        set @i = @i - 1
        continue
    end catch
end

-- 使用 TRANSACTION 範例，包含 BEGIN TRAN、COMMIT、ROLLBACK

select * from TestRethrow

begin try 
    begin tran
        insert TestRethrow(id) values(2);  
        insert TestRethrow(id) values(1);  -- 強制產生主鍵違反錯誤
    commit tran
end try  
begin catch  
    rollback tran
    print N'錯誤代碼為' + cast(error_number() as varchar(5)) + N'，錯誤訊息為' + error_message();
    --RaisError ('message', 15, 1);
    --throw
    --throw 50000, 'O!! my God!! ', 4;      
end catch;  

select * from TestRethrow

-- 查詢系統訊息表中 message_id 為 8134 的錯誤訊息
select * from sys.messages where message_id = 8134
