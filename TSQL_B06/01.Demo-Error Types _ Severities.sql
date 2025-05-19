-- Module 6：T-SQL 錯誤處理與系統錯誤訊息
-- 6-1: 常見的 T-SQL 錯誤類型與例子
-- 6-2: 使用 ERROR_XXX() 函數捕捉錯誤
-- 6-3: 使用 @@ERROR 和 ERROR_NUMBER() 錯誤追蹤方法

-- 錯誤訊息查詢（建議收藏）：
-- 官方文件：SQL Server 錯誤與事件代碼總表
-- https://docs.microsoft.com/zh-tw/sql/relational-databases/errors-events/database-engine-events-and-errors?view=sql-server-ver15

-- 錯誤嚴重性（Severity）說明：
-- 錯誤等級從 0~24，越高代表問題越嚴重：
-- - 0~9 通常為訊息提示
-- - 10~16 屬於使用者錯誤（如語法錯誤、資料不存在）
-- - 17~24 為系統錯誤（資源不足、磁碟故障等）
-- 詳細說明：https://docs.microsoft.com/zh-tw/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver15

-- Lab：01.Demo - Error types and Severities.sql

-- Step 1：使用 AdventureWorks 資料庫
use AdventureWorks;
go

-- Step 2：語法錯誤的範例（select 拼錯為 selec）
selec * from Person.Person;  -- 'selec' 是錯誤拼字，會造成語法錯誤
go

-- Step 3：物件解析錯誤（查詢不存在的資料表）
select * from Dog;           -- 資料表 'Dog' 不存在，會報錯
go

-- Step 4：執行時錯誤（除以 0）
select 12/0;                 -- 除以 0 會引發執行時錯誤
go

-- Step 5：查詢系統錯誤訊息 sys.messages 的內容
-- 顯示所有語言的錯誤訊息
select * from sys.messages;

-- 只查詢繁體中文（language_id = 1028）的錯誤訊息
select * from sys.messages 
where language_id = 1028
order by language_id, message_id;
go

-- Step 6：只查詢英文（language_id = 1033），嚴重性大於等於 19 的錯誤訊息
-- 並注意是否會被記錄（is_event_logged 欄位）
select * from sys.messages
where language_id = 1033 and severity >= 19
order by severity, message_id;

select * from sys.messages
where language_id = 1028 and severity >= 19
order by severity, message_id;

-- 📌 額外補充：如何自訂錯誤訊息
-- sp_addmessage：新增自訂錯誤訊息（自訂的錯誤碼建議從 50001 開始）

-- 語法：
-- sp_addmessage 
--     @msgnum = 錯誤編號,
--     @severity = 錯誤嚴重度 (1~24),
--     @msgtext = N'錯誤內容',
--     @lang = '語言'（如 us_english、中文繁體為中文代碼),
--     @with_log = 'with_log'（可選，寫入 Windows 事件記錄）,
--     @replace = 'replace'（可選，允許覆蓋）

-- 實例：新增英文錯誤訊息
exec sp_addmessage 	
	@msgnum = 50003, 
	@severity = 16,
    @msgtext = N'The New Employee (%s) already exists.',
	@lang = 'us_english';

-- 新增繁體中文版本
exec sp_addmessage 
	@msgnum = 50003, 
	@severity = 16,
    @msgtext = N'新員工 (%1!) 已存在',
	@lang = N'zh-tw';

-- 查詢自訂錯誤訊息（50000以上）
select * from sys.messages
where message_id > 49958;

-- 觸發錯誤訊息
raiserror(50003, 12, 1, 'John');

-- 刪除錯誤訊息（所有語言）
exec sp_dropmessage 50003, @lang = 'all';

-- 再次確認已刪除
select * from sys.messages
where message_id > 49958;
