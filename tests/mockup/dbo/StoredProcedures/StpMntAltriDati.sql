
-- ==========================================================================================
-- Entity Name:   StpMntAltriDati
-- Author:        mik
-- Create date:   05-02-18
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   STP per la creazione della Stp per gestire le TbX
-- Se si immette come @TableXName: TbXArticoli, verrà generata in automatico la StpXArticoli (fate Aggiorno sul nodo Stored Procedure per vederla).
-- La convenzione del nome della Stp generata è che tolgo le prime 2 lettere di @TableXName e aggiunto Stp all'inizio.
-- Se il nome della STP risultante è già presente verrà generato un errore.
-- History:
-- mik 180205 Creazione
-- mik 180614 Corretto parametrizzazione del nome della Stp generata, cambiato nome alla STP in StpMntAltriDati
-- dav 180626 Gestione chiavi multiple (prende solo la prima, poi va gestito manualmente)
-- dav 181202 Aggiunto controllo su chiave insesitente
-- MIK 210312: Conversione esplicita del tipo DATETIME in NVARCHAR col formato 101 come DBO si aspetta.
-- MIK 210316: Corretto conversione esplicita del tipo DATETIME in NVARCHAR col formato 101 come DBO si aspetta.
-- ==========================================================================================

CREATE PROCEDURE [dbo].[StpMntAltriDati]
(
	@TableXName NVARCHAR(255),
	@KYMsg NVARCHAR(MAX) OUTPUT,
	@KYRes INT OUTPUT
)
AS
BEGIN
	DECLARE @StpXTableSql AS NVARCHAR(MAX)
	DECLARE @HeaderSql AS NVARCHAR(MAX)
	DECLARE @DeclareSql AS NVARCHAR(MAX)
	DECLARE @ControlSql AS NVARCHAR(MAX)
	DECLARE @SetControlSql AS NVARCHAR(MAX)
	DECLARE @SetParamCtrlSql AS NVARCHAR(MAX)
	DECLARE @SetVariablesSql AS NVARCHAR(MAX)
	DECLARE @LoadValueSql AS NVARCHAR(MAX)
	DECLARE @SetUpdValuesSql AS NVARCHAR(MAX)
	DECLARE @NewLine AS NVARCHAR(2)
	DECLARE @PKName AS NVARCHAR(255)

	SET @NewLine = CHAR(13) + CHAR(10)
	SET @KYMsg = NULL
	SET @KYRes = 0


	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_NAME = @TableXName)
	BEGIN
		--Non esiste la tabella
		SET @KYMsg = 'Non esiste la tabella'
		SET @KYRes = -1
	END
	ELSE
	BEGIN
		--la tabella esiste
		
		SET @StpXTableSql = ''
		
		SET @StpXTableSql = @StpXTableSql + '-- =============================================' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '-- Author:		Auto' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '-- Create date: ' + CONVERT(NVARCHAR(20), GETDATE(), 5) + @NewLine
		SET @StpXTableSql = @StpXTableSql + '-- Description:	Estende la sched articolo' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '-- History:' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '-- Auto ' + CONVERT(NVARCHAR(20), GETDATE(), 5) + ': Generazione automatica' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '-- =============================================' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'CREATE PROCEDURE [dbo].[Stp' + RIGHT(@TableXName,LEN(@TableXName)-2) + ']' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '(' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '@IdDoc nvarchar(50),' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '@SysUser nvarchar(256),' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '@KYStato int = NULL output,' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '@KYMsg nvarchar(max) = NULL output,' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '@KYRes int = NULL' + @NewLine
		SET @StpXTableSql = @StpXTableSql + ')' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'AS' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'BEGIN' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'SET NOCOUNT ON;' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'DECLARE @ParamCtrl nvarchar(max)' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'Declare @Msg nvarchar(300)' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'Declare @Msg1 nvarchar(300)' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'Declare @MsgObj nvarchar(300)' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'Declare @CodFnzTipoMsg as nvarchar(5)' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'SET @Msg= ''Aggiorna''' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'SET @MsgObj=''' + @TableXName + '''' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'SET @ParamCtrl = ''<ParamCtrl>'' + REPLACE(REPLACE(@KYMsg,''-|'', ''<''), ''|-'', ''>'') + ''</ParamCtrl>''' + @NewLine
		
		SET @DeclareSql = ''
		SET @ControlSql = ''
		SET @SetControlSql = ''
		SET @LoadValueSql = ''
		SET @SetParamCtrlSql = ''
		SET @SetVariablesSql = ''
		SET @SetUpdValuesSql = ''
		
		SET @PKName = (SELECT Top 1 Col.Column_Name
		from INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab
		INNER JOIN
		INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
		ON Tab.TABLE_NAME = Col.TABLE_NAME AND Tab.TABLE_SCHEMA = Col.TABLE_SCHEMA
		WHERE 
		Col.Constraint_Name = Tab.Constraint_Name AND Col.Table_Name = Tab.Table_Name AND Constraint_Type = 'PRIMARY KEY' AND Col.Table_Name = @TableXName)
		 
		select @DeclareSql = @DeclareSql + 'DECLARE @' + COLUMN_NAME + ' AS ' + DATA_TYPE + (CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NULL THEN '' ELSE '(' + (CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX' ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(20)) END)  + ')' END) + @NewLine,
		@ControlSql = @ControlSql + 'DECLARE @Control' + COLUMN_NAME + ' AS ' + 'NVARCHAR(MAX)' + @NewLine,
		--MIK210312
		@SetControlSql = @SetControlSql + 'SET @Control' + COLUMN_NAME +' = dbo.FncKyMsgTextBox(''' + COLUMN_NAME + ''' ,@KYStato,''' + COLUMN_NAME + ':'', ' + (CASE DATA_TYPE WHEN 'date' THEN 'CONVERT(nvarchar(50), @' + COLUMN_NAME +',101)' WHEN 'datetime' THEN 'CONVERT(nvarchar(50), @' + COLUMN_NAME +',101)'  ELSE '@' + COLUMN_NAME END) + ', ''' + (CASE DATA_TYPE WHEN 'nvarchar' THEN 'string' WHEN 'nvarchar' THEN 'string' WHEN 'bit' THEN 'bool' WHEN 'money' THEN 'real' WHEN 'real' THEN 'real' WHEN 'int' THEN 'int' WHEN 'datetime' THEN 'datetime' WHEN 'date' THEN 'datetime' ELSE 'string' END) + ''' )' + @NewLine,
		@SetParamCtrlSql = @SetParamCtrlSql + 'SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @Control'+ COLUMN_NAME + ')' + @NewLine,
		@SetVariablesSql = @SetVariablesSql + 'SET @'+ COLUMN_NAME + ' = dbo.FncKyMsgCtrlValue(@ParamCtrl, ''' + COLUMN_NAME +''',1)' + @NewLine,
		@LoadValueSql  = @LoadValueSql + '@' + COLUMN_NAME + '=' + COLUMN_NAME + ', ',
		@SetUpdValuesSql = @SetUpdValuesSql + COLUMN_NAME + '=@' + COLUMN_NAME + ', '
		from information_schema.columns  AS Col
		LEFT OUTER JOIN
		(
		SELECT Col.Column_Name as ClnName
		from INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab
		INNER JOIN
		INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
		ON Tab.TABLE_NAME = Col.TABLE_NAME AND Tab.TABLE_SCHEMA = Col.TABLE_SCHEMA
		WHERE 
		Col.Constraint_Name = Tab.Constraint_Name AND Col.Table_Name = Tab.Table_Name AND Constraint_Type = 'PRIMARY KEY' AND Col.Table_Name = @TableXName
		) AS DrvPK
		ON Col.COLUMN_NAME = DrvPK.ClnName
		where table_name = @TableXName 
		AND DrvPK.ClnName IS NULL --ossia salto i campi Primary Key
		AND DATA_TYPE <> 'varbinary' --varbinary non verrà mai mostrato su una tab Altri Dati
		AND COLUMN_NAME NOT LIKE 'Sys%' -- escludo campi che iniziano per Sys
		AND COLUMNPROPERTY(OBJECT_ID(TABLE_SCHEMA+'.'+TABLE_NAME),COLUMN_NAME,'IsComputed')  = 0 -- escludo campi calcolati

		SET @StpXTableSql = @StpXTableSql + @DeclareSql + @NewLine
		SET @StpXTableSql = @StpXTableSql + @ControlSql + @NewLine

		SET @StpXTableSql = @StpXTableSql + '/****************************************************************'+ @NewLine
		SET @StpXTableSql = @StpXTableSql + '* Stato 0'+ @NewLine
		SET @StpXTableSql = @StpXTableSql + '****************************************************************/'+ @NewLine
		SET @StpXTableSql = @StpXTableSql + 'IF @KYStato  = 0'+ @NewLine
		SET @StpXTableSql = @StpXTableSql + 'BEGIN'+ @NewLine
		SET @StpXTableSql = @StpXTableSql + '	set  @KYStato = 1' + @NewLine
		
		SET @LoadValueSql = LEFT(@LoadValueSql,LEN(@LoadValueSql)-1)
		
		SET @StpXTableSql = @StpXTableSql + @NewLine + @NewLine

		If @PKName is not null
			BEGIN 
				SET @StpXTableSql = @StpXTableSql + 'SELECT ' + @LoadValueSql + @NewLine
				SET @StpXTableSql = @StpXTableSql + 'FROM ' + @TableXName + @NewLine
				SET @StpXTableSql = @StpXTableSql + 'WHERE (' + @PKName + ' = @IdDoc)' + @NewLine
			END
		ELSE
			BEGIN
				SET @StpXTableSql = @StpXTableSql + '--SELECT ' + @LoadValueSql + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--FROM ' + @TableXName + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--WHERE (' + '##MANCACHIAVEPRIMARIA##' + ' = @IdDoc)' + @NewLine
			END
	
		SET @StpXTableSql = @StpXTableSql + @NewLine + @NewLine

		SET @StpXTableSql = @StpXTableSql + @SetControlSql + @NewLine

		SET @StpXTableSql = @StpXTableSql + @SetParamCtrlSql + @NewLine
		
		

		SET @StpXTableSql = @StpXTableSql + 'SET @KYMsg = dbo.FncKYMsg(@Msg,Null,Null, Null,Null)' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'SET @KYMsg = @KYMsg + ''<ParamCtrl>'' + @ParamCtrl + ''</ParamCtrl>''' + @NewLine

		SET @StpXTableSql = @StpXTableSql + 'RETURN' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'END' + @NewLine
	
		SET @StpXTableSql = @StpXTableSql + '/****************************************************************' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '* Stato 1 - risposta affermativa' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '****************************************************************/' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'IF @KYStato = 1 ' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'BEGIN' + @NewLine
		SET @StpXTableSql = @StpXTableSql + '	SET @Msg = ''''' + @NewLine

		SET @StpXTableSql = @StpXTableSql + @SetVariablesSql + @NewLine
		
		If @PKName is not null
			BEGIN
				SET @StpXTableSql = @StpXTableSql + 'IF not  EXISTS(SELECT ' + @PKName + ' FROM ' + @TableXName + ' WHERE ' + @PKName + '= @IdDoc) ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + 'BEGIN' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '	INSERT INTO ' + @TableXName + ' ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '	(' + @PKName + ')' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '	VALUES        (@IdDoc)' + @NewLine
				SET @StpXTableSql = @StpXTableSql + 'END' + @NewLine
			END
		ELSE
			BEGIN
				SET @StpXTableSql = @StpXTableSql + '--IF not  EXISTS(SELECT ' + '##MANCACHIAVEPRIMARIA##' + ' FROM ' + @TableXName + ' WHERE ' + '##MANCACHIAVEPRIMARIA##' + '= @IdDoc) ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--BEGIN' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--	INSERT INTO ' + @TableXName + ' ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--	(' + '##MANCACHIAVEPRIMARIA##' + ')' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--	VALUES        (@IdDoc)' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--END' + @NewLine
			END

		SET @SetUpdValuesSql = LEFT(@SetUpdValuesSql,LEN(@SetUpdValuesSql)-1)

		SET @StpXTableSql = @StpXTableSql + @NewLine + @NewLine

		If @PKName is not null
			BEGIN
				SET @StpXTableSql = @StpXTableSql + 'UPDATE       ' + @TableXName + ' ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + 'SET          ' + @SetUpdValuesSql + ' ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + 'WHERE        (' + @PKName + ' = @IdDoc)' + @NewLine
			END
		ELSE
			BEGIN
				SET @StpXTableSql = @StpXTableSql + '--UPDATE       ' + @TableXName + ' ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--SET          ' + @SetUpdValuesSql + ' ' + @NewLine
				SET @StpXTableSql = @StpXTableSql + '--WHERE        (' + '##MANCACHIAVEPRIMARIA##' + ' = @IdDoc)' + @NewLine
			END

		SET @StpXTableSql = @StpXTableSql + @NewLine + @NewLine

		SET @StpXTableSql = @StpXTableSql + 'SET @KYMsg = dbo.FncKYMsg(@Msg,Null,Null, Null,Null)' + @NewLine
		SET @StpXTableSql = @StpXTableSql + 'SET @KYMsg = @KYMsg + ''<ParamCtrl>'' + @ParamCtrl + ''</ParamCtrl>''' + @NewLine

		SET @StpXTableSql = @StpXTableSql + 'RETURN' + @NewLine

		SET @StpXTableSql = @StpXTableSql + 'END' + @NewLine

		SET @StpXTableSql = @StpXTableSql + 'END' + @NewLine
	END

	EXEC (@StpXTableSql)

	--print @StpXTableSql

	
END

GO

