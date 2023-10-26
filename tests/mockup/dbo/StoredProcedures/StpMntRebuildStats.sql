
-- ==========================================================================================
-- Entity Name:    StpMntRebuildStats
-- Author:         dav
-- Create date:    221001
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    Ricostruisce le statistiche del db
-- History:
-- dav 221001 Creazione
-- ==========================================================================================

CREATE Procedure [dbo].[StpMntRebuildStats] 
	(
		@TableName varchar(255) = NULL --Se NULL allora aggiorna le statistiche di tutto altrimenti aggiorna solo le statistiche della tabella specificata 
								--(N.B.: bisogna specificare lo schema, es.: dbo.TbArticoli)
	)
AS 
	DECLARE @Sql as nvarchar(1000)

	set @Sql ='EXEC sp_updatestats'
	IF ISNULL(@TableName,'')<>''
	BEGIN
		set @Sql ='UPDATE STATISTICS' + ' ' + @TableName
	END

	execute sp_executesql @Sql

	IF ISNULL(@TableName,'')<>''
	BEGIN
		PRINT 'Ricostruito le statistiche di ' + @TableName 
	END
	ELSE
	BEGIN
		PRINT 'Ricostruito le statistiche di tutto il DB'
	END

GO

