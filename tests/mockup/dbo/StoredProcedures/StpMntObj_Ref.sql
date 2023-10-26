
-- ==========================================================================================
-- Entity Name:    StpMntObj_Ref
-- Author:         dav
-- Create date:    230821
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    Ricerca referenze di table.column in tutti gli oggetti del db
-- History:
-- dav 230821 Creazione
-- ==========================================================================================

CREATE PROCEDURE [dbo].[StpMntObj_Ref] (
	-- Add the parameters for the function here
	@TableName AS NVARCHAR(256),
	@ColumnName AS NVARCHAR(256),
    @Ref AS NVARCHAR(4000) = NULL,
    @Livello AS INT = 0
	)
AS
BEGIN
    SET NOCOUNT ON

    IF @Ref IS NULL
    BEGIN
        SET @Ref = @TableName + '.' + @ColumnName
    END
    ELSE
    BEGIN
        SET @Ref = @TableName + '.' + @Ref
    END

    

    SET @Livello = @Livello + 1

	DECLARE @ObjectName AS NVARCHAR(256)
	DECLARE @TObjecType AS NVARCHAR(256)
	DECLARE @Dummy AS NVARCHAR(256)
	DECLARE @I AS INT

    IF OBJECT_ID('tempdb..#TmpObj') IS  NULL
    begin
	create  TABLE   #TmpObj(
		Id INT,
		ObjName NVARCHAR(256),
        ObjRef NVARCHAR(4000)
		)
    END

	SET @I = 0

	PRINT '---------------------------------------------------------------------------'
	PRINT 'Controllo utilizzo di ' + @Ref + ' nel database corrente'
	PRINT '---------------------------------------------------------------------------'

	DECLARE db_cursor CURSOR
	FOR
	-- SELECT DISTINCT OBJECT_SCHEMA_NAME(O.OBJECT_ID) + '.' + o.name AS ObjectName,
	-- 	o.type_desc
	-- FROM sys.sql_modules m
	-- INNER JOIN sys.objects o
	-- 	ON m.object_id = o.object_id
	-- --WHERE '.' + m.DEFINITION + '.' LIKE '%[^a-z]' + '' + @ColumnName +'' + '[^a-z]%'
	-- ORDER BY o.type_desc,
	-- 	OBJECT_SCHEMA_NAME(O.OBJECT_ID) + '.' + o.name

    SELECT referencing_schema_name + '.' + referencing_entity_name as ObjectName, referencing_class_desc as type_desc
FROM sys.dm_sql_referencing_entities ('dbo.' + @TableName, 'OBJECT'); 

	OPEN db_cursor

	FETCH NEXT
	FROM db_cursor
	INTO @ObjectName,
		@TObjecType

	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			IF EXISTS (
					SELECT referenced_entity_name AS [Entity],
						referenced_minor_name AS [Minor],
						referenced_class_desc AS [Class]
					FROM sys.dm_sql_referenced_entities(@ObjectName, 'OBJECT')
					WHERE referenced_entity_name = @Tablename
						AND referenced_minor_name = @ColumnName
					)
			BEGIN
				SET @I = @I + 1
				SET @Dummy = RIGHT('0' + CONVERT(NVARCHAR(20), @Livello), 2) + '/' + RIGHT('0' + CONVERT(NVARCHAR(20), @I), 2) + ' - ' + @ObjectName

				PRINT @Dummy

                

				INSERT INTO #TmpObj (
					ObjName,
                    ObjRef,
					Id
					)
				VALUES (
					@ObjectName, 
                    @Ref,
					@Livello * 1000 + @I * 100
					)

                SET @ObjectName = SUBSTRING(@ObjectName,5,999) 
                
                EXECUTE [dbo].[StpMntObj_Ref] @ObjectName, @ColumnName, @Ref, @Livello 

			END
		END TRY

		BEGIN CATCH
			PRINT @ObjectName
		END CATCH

		FETCH NEXT
		FROM db_cursor
		INTO @ObjectName,
			@TObjecType
	END

	CLOSE db_cursor

	DEALLOCATE db_cursor

	PRINT '---------------------------------------------------------------------------'

    IF @Livello = 1
    BEGIN
        SELECT *
        FROM #TmpObj
    END

	RETURN
END

GO

