-- 模組 4：練習 - 建立 Clustered Table（叢集資料表）

-- 叢集索引（Clustered）：
--		在 SQL Server 中，一張資料表只能有一個叢集索引（通常是主鍵），
--		資料會根據這個索引實際排序存放於磁碟中。
--		這種排序方式有助於提高查詢效能，尤其是在搜尋範圍或排序時。
--		可以想像成「依照順序排列好的電話簿」。

-- B Tree（平衡樹）架構是叢集索引的底層資料結構。
-- 延伸閱讀：https://blog.niclin.tw/2018/06/18/%E4%BB%80%E9%BA%BC%E6%98%AF-b-tree-balance-tree/

-- Step 1：使用 LabDB2 資料庫
use LabDB2;
go

-- 若資料表 PhoneLog 已存在，則先刪除
drop table if exists PhoneLog;

-- Step 2：建立資料表，指定主鍵，表示這是一個 Clustered Table
create table PhoneLog(
	PhoneLogID int identity(1, 1) primary key,    -- 主鍵，同時為叢集索引（Clustered Index）
	LogRecorded datetime2 not null,              -- 通話記錄時間
	PhoneNumberCalled nvarchar(100) not null,    -- 撥打的電話號碼
	CallDurationMs int not null                  -- 通話時長（毫秒）
);

-- Step 3：查詢系統資料表 sys.indexes，檢查該表的索引狀態
-- 注意 SQL Server 如何自動命名限制條件與索引名稱
select * from sys.indexes
where object_id = object_id('PhoneLog');        -- index_id = 1, type_desc = 'CLUSTERED'
go

-- 查看分割區（Partition）資訊以確認索引類型
select * from sys.partitions
where object_id = object_id('PhoneLog');        -- index_id = 1 表示為主索引
go

-- Step 4：可選，刪除資料表（若為示範用途）
-- drop table PhoneLog;
