-- ==========================================================================================
-- Entity Name:    StpMntObjDbSchema_Ctrl
-- Author:         dav
-- Create date:    230110
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    Controlla modifiche allo schema di viste e tabelle di dbo
--                 Da utilizzare dopo un cambio tipo dati in tabella per allineare il dbml
--                 Da integrare con output dell funzioni
-- History:
-- dav 230110 Creazione
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpMntObjDbSchema_Ctrl] (
	@FlgRigenera AS BIT = 0 -- Se 1 rigenera lo schema storicizzato, se 0 comapara con storicizzato
	)
AS
BEGIN
	-----------------------------------------
	-- Refresh degli schemi delle viste
	-----------------------------------------
	DECLARE @Vst AS NVARCHAR(300)

	DECLARE db_cursor CURSOR
	FOR
	SELECT OBJECT_SCHEMA_NAME(v.object_id) + '.' + v.name Vst
	FROM sys.VIEWS AS v
	WHERE v.name NOT IN ('VstBachecheDet')

	OPEN db_cursor

	FETCH NEXT
	FROM db_cursor
	INTO @Vst

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Refresh ' + @Vst

		EXECUTE sp_refreshview @Vst
	    --EXEC sys.sp_refreshsqlmodule @Vst

		FETCH NEXT
		FROM db_cursor
		INTO @Vst
	END

	CLOSE db_cursor

	DEALLOCATE db_cursor


    -----------------------------------------
	-- Se richiesto storicizza
	-----------------------------------------
	IF @FlgRigenera = 1
	BEGIN
		DELETE
		FROM TbMntTableDataType

		INSERT INTO TbMntTableDataType (
			TableName,
			ColumnName,
			ColumnDataType,
			ColumnTypeCheck
			)
		SELECT TableName = tbl.table_schema + '.' + tbl.table_name,
			ColumnName = col.column_name,
			ColumnDataType = col.data_type,
			ColumnTypeCheck = ISNULL(col.data_type, '') + '#' + ISNULL(col.column_default, '') + '#' + ISNULL(col.is_nullable, '') + '#' + ISNULL(convert(NVARCHAR(20), col.character_maximum_length), '') + '#' + ISNULL(convert(NVARCHAR(20), col.character_octet_length), '') + '#' + ISNULL(convert(NVARCHAR(20), col.numeric_precision), '') + '#' + ISNULL(convert(NVARCHAR(20), col.numeric_precision_radix), '') + '#' + ISNULL(convert(NVARCHAR(20), col.numeric_scale), '') + '#' + ISNULL(convert(NVARCHAR(20), col.datetime_precision), '') + '#' + ISNULL(col.character_set_name, '') + '#'
		FROM INFORMATION_SCHEMA.TABLES tbl
		INNER JOIN INFORMATION_SCHEMA.COLUMNS col
			ON col.table_name = tbl.table_name
				AND col.table_schema = tbl.table_schema
	END

    -----------------------------------------
	-- Compara
	-----------------------------------------

	SELECT TableName = tbl.table_schema + '.' + tbl.table_name,
		ColumnName = col.column_name,
		ColumnDataType = col.data_type,
		ColumnTypeCheck = ISNULL(col.data_type, '') + '#' + ISNULL(col.column_default, '') + '#' + ISNULL(col.is_nullable, '') + '#' + ISNULL(convert(NVARCHAR(20), col.character_maximum_length), '') + '#' + ISNULL(convert(NVARCHAR(20), col.character_octet_length), '') + '#' + ISNULL(convert(NVARCHAR(20), col.numeric_precision), '') + '#' + ISNULL(convert(NVARCHAR(20), col.numeric_precision_radix), '') + '#' + ISNULL(convert(NVARCHAR(20), col.numeric_scale), '') + '#' + ISNULL(convert(NVARCHAR(20), col.datetime_precision), '') + '#' + ISNULL(col.character_set_name, '') + '#'
	INTO #TmpTableDataType
	FROM INFORMATION_SCHEMA.TABLES tbl
	INNER JOIN INFORMATION_SCHEMA.COLUMNS col
		ON col.table_name = tbl.table_name
			AND col.table_schema = tbl.table_schema

	SELECT drvMod.TableName, drvMod.ColumnName, drvMod.ColumnDataType, drvMod.ColumnTypeCheck, TbMntTableDataType.ColumnDataType as ColumnDataTypePrec
	FROM #TmpTableDataType drvMod
	LEFT OUTER JOIN TbMntTableDataType
		ON TbMntTableDataType.TableName = drvMod.TableName
			AND TbMntTableDataType.ColumnName = drvMod.ColumnName
	WHERE drvMod.ColumnTypeCheck <> TbMntTableDataType.ColumnTypeCheck
	ORDER BY drvMod.tablename

END

GO

