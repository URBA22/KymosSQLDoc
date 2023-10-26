

-- ==========================================================================================
-- Entity Name:   StpMntRebuildIndex
-- Author:        dav
-- Create date:   21.09.15
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	 
-- Description:	  Ricostruisce gli indici del db
-- dav 200803 Ottimizzazione con filtro per percentuale
-- ==========================================================================================


CREATE Procedure [dbo].[StpMntRebuildIndex] 
	(
		@PercRebuild real = 15
	)
AS 
		

	DECLARE @TableName varchar(255) 
	DECLARE @IndexName varchar(255) 
	DECLARE @IndexType varchar(255) 
	DECLARE @AvgFrag as real
	DECLARE @RecordCount as int
	DECLARE @Sql as nvarchar(1000)


	DECLARE TableCursor CURSOR FOR 

	--SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
	--WHERE TABLE_TYPE = 'base table' 
	--ORDER BY TABLE_NAME

	SELECT s.[name] +'.'+t.[name]  AS table_name
	,i.NAME AS index_name
	,index_type_desc
	,ROUND(avg_fragmentation_in_percent,2) AS avg_fragmentation_in_percent
	,record_count AS table_record_count
	FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ips
	INNER JOIN sys.tables t on t.[object_id] = ips.[object_id]
	INNER JOIN sys.schemas s on t.[schema_id] = s.[schema_id]
	INNER JOIN sys.indexes i ON (ips.object_id = i.object_id) AND (ips.index_id = i.index_id)
	WHERE ROUND(avg_fragmentation_in_percent,2) > @PercRebuild
	ORDER BY avg_fragmentation_in_percent DESC


	OPEN TableCursor 

	FETCH NEXT FROM TableCursor INTO @TableName, @IndexName, @IndexType, @AvgFrag, @RecordCount
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		PRINT @TableName + ' ' + @IndexName + ' # ' + convert(nvarchar(20), round(@AvgFrag,2))

		--DBCC DBREINDEX(@TableName,' ',100) 

		IF @AvgFrag < 30
			BEGIN
				set @Sql ='ALTER INDEX ' + @IndexName + ' ON ' + @TableName + ' REORGANIZE'
			END
		ELSE
			BEGIN
				set @Sql ='ALTER INDEX ' + @IndexName + ' ON ' + @TableName + ' REBUILD'
			END

		execute sp_executesql @Sql

		FETCH NEXT FROM TableCursor INTO @TableName, @IndexName, @IndexType, @AvgFrag, @RecordCount
	END 

	CLOSE TableCursor 

	DEALLOCATE TableCursor

GO

