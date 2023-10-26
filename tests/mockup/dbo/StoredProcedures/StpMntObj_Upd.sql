             
-- ==========================================================================================
-- Entity Name:   StpMntObj_Upd
-- Author:        Dav
-- Create date:   210517
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Stp lanciata alla fine del processo di aggiornamento
-- History:
-- dav 210517 Creazione
-- dav 210724 inserimento data DataDbAgg
-- dav 210909 Gestione log
-- ==========================================================================================

CREATE Procedure [dbo].[StpMntObj_Upd]
(
	@SysUser nvarchar(256)
)
As
Begin
	
	Print 'Analisi compatibilità'
	-- Richiama compatibility per settare codice in funzione della versione 
	execute  [dbo].[StpMntObjSetCompatibility] NULL

	If dbo.FncKeyValueExists('DataDbAgg',null) = 0
	BEGIN
		INSERT INTO TbSettingKey
		(IdKey, CodFnz, NoteSetting, SysDateCreate)
		VALUES        (N'DataDbAgg', N'KEYE', N'Inserimento automatico versione db aggiornato', GETDATE())
	END

	UPDATE TbSettingKey 
	SET value = CONVERT (NVARCHAR(20),GETDATE(),12)
	WHERE IDKEY = N'DataDbAgg'
	
	Declare @MntScriptVrs as nvarchar(50)
	Declare @MntSchemaVrs as nvarchar(50)
	Declare @MntDboCSchemaVrs as nvarchar(50)
	Declare @MntDboXSchemaVrs as nvarchar(50)
	Declare @MntDboWSchemaVrs as nvarchar(50)
	
	SET @MntScriptVrs = (Select Value From TbSettingKey where IdKey = 'MntScriptVer')
	SET @MntSchemaVrs = [dbo].[DboSchemaVrs]()
	SET @MntDboCSchemaVrs = [dbo].[DboCSchemaVrs]()
	SET @MntDboXSchemaVrs = [dbo].[DboXSchemaVrs]()
	SET @MntDboWSchemaVrs = [dbo].[DboWSchemaVrs]()

	DECLARE @NoteLog AS NVARCHAR(max)

	SET @NoteLog = dbo.FncStr (@NoteLog,'Schema Vrs: ' + @MntSchemaVrs)
	SET @NoteLog = dbo.FncStr (@NoteLog,'Script Vrs: ' + @MntScriptVrs)
	SET @NoteLog = dbo.FncStr (@NoteLog,'DBOC Vrs: ' + @MntDboCSchemaVrs)
	SET @NoteLog = dbo.FncStr (@NoteLog,'DBOX Vrs: ' + @MntDboXSchemaVrs)
	SET @NoteLog = dbo.FncStr (@NoteLog,'DBOW Vrs: ' + @MntDboWSchemaVrs)
	
	INSERT INTO TbLog
	(DataLog, UserName, TipoLog, DescLog, NoteLog, SysDateCreate, SysUserCreate)
	VALUES (GETDATE(), N'Cybe', N'AggiornamentoDb',@MntSchemaVrs, @NoteLog, GETDATE(), N'Cybe')



End

GO

