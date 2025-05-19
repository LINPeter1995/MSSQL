-- Module 6    02.Lab - Exception Handling.sql

-- ERROR_NUMBER() ：回傳錯誤代碼
-- ERROR_SEVERITY() ：回傳錯誤嚴重程度（數值範圍 0~24，10 以下為資訊性錯誤）
--                    嚴重程度越高表示錯誤越嚴重，需要更嚴格處理
-- ERROR_STATE() ：回傳錯誤狀態碼，可用來判斷錯誤的來源與細節，方便除錯
-- ERROR_PROCEDURE() ：回傳發生錯誤的預存程序名稱（若有的話）
-- ERROR_LINE() ：回傳發生錯誤的 T-SQL 程式碼所在行數
-- ERROR_MESSAGE() ：回傳錯誤訊息的完整文字說明，用來顯示或記錄錯誤內容

use LabDB2
select * from NewTable;

-- 比較使用 @@ERROR 與 ERROR_NUMBER() 的差異：
--     @@ERROR：用於立即取得上一個 T-SQL 語句的錯誤代碼（0 表示無錯）
--     ERROR_NUMBER()：需在 CATCH 區塊內使用，才能回傳錯誤編號，否則為 NULL

begin tran
	Insert NewTable values(1, 'eeee');       -- 錯誤：id 欄位是 identity，不可指定值
	print @@error			-- 顯示上一步的錯誤代碼
	print @@error
	if @@error != 0
		begin
			print 'error happen'
			rollback tran
		end
	else 
		print 'commit'
		commit tran;

select @@trancount
select * from NewTable;

-----------------------------------------------------------------------

-- A. 使用 @@ERROR 來判斷是否發生主鍵違反錯誤
--    以下範例用來偵測是否為錯誤編號 2627（主鍵重複）

use LabDB2
select * from NewTable

Insert NewTable values(1, 'eeee'); 
if @@error = 2627
    begin
		print N'已發生 Primary Key 重複的錯誤';
    end

-----------------------------------------------------------------------------

-- 使用 TRY...CATCH 區塊來捕捉錯誤資訊
declare @TestTryCash int
begin try
		select @TestTryCash = 1000 / 0    -- 故意觸發除以 0 錯誤
end try
begin catch
		if @@error != 0
			select	error_number()		as [error number],
						error_severity()	as [error severity], 
						error_state()		as [error state],
						error_procedure()	as [error procedure],
						error_line()		as [error line], 
						error_message()		as [error message]
		else
			print 'OK'
end catch
