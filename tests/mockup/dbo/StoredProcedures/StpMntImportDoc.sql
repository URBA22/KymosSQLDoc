
-- ==========================================================================================
-- Entity Name:    StpMntImportDoc
-- Author:         dav
-- Create date:    11.07.18
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    Importa un file nella tabella documenti
-- History:
-- dav 230628 Disabilitata gestione FileStream
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntImportDoc]
(
	@IdDocumento int OUTPUT,
	@TipoDoc nvarchar(300),					-- Tipo di documento da caricare, ad esempio TbArticoli
	@IdDoc nvarchar(50),
	@Descrizione nvarchar(200),
	@ExtDoc nvarchar(8),
	@PathDoc nvarchar(256),
	@SysUserCreate nvarchar(256)
)
As
Begin
DECLARE @cmd varchar(1000)

		BEGIN TRY
			BEGIN TRANSACTION

				Insert Into TbDocumenti
					([TipoDoc],[IdDoc],[Descrizione],[ExtDoc],[PathDoc],[SysUserCreate],[SysDateCreate])
				Values
					(@TipoDoc,@IdDoc,@Descrizione,@ExtDoc,@PathDoc,@SysUserCreate,Getdate())

				print @pathdoc
				
				Select @IdDocumento = SCOPE_IDENTITY() 
				
				SET @cmd = 'UPDATE TbDocumenti SET Documento = ' + 
				' (SELECT * FROM ' +
				' OPENROWSET(BULK '''+ @PathDoc + ''', SINGLE_BLOB) AS doc)'+
				' where TbDocumenti.IdDocumento = ' + CAST(@IdDocumento as NVARCHAR(20))
			
				--print @cmd
				EXEC (@cmd)

				-- IF dbo.FncOggettoPrs('VST','VstDocumenti_FileStream')=1
				-- BEGIN
				-- 	IF NOT(EXISTS(SELECT IdDocumento FROM VstDocumenti_FileStream WHERE (IdDocumento = @IdDocumento)))
				-- 	BEGIN
				-- 		INSERT INTO VstDocumenti_FileStream
				-- 		(IdDocumento, Id)
				-- 		VALUES
				-- 		(@IdDocumento, newid())
				-- 	END
				-- 	Declare @DocStream as varbinary(max)

				-- 	Select @DocStream = Documento from TbDocumenti where IdDocumento = @IdDocumento

				-- 	UPDATE       VstDocumenti_FileStream
				-- 	SET                Documento =  @DocStream
				-- 	WHERE        (IdDocumento = @IdDocumento)

				-- 	UPDATE       TbDocumenti
				-- 	SET          
				-- 	PathDoc = 'FileStream',
				-- 	Documento = NULL
				-- 	WHERE        (IdDocumento = @IdDocumento)
		
				-- END

				
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			rollback transaction
			print @@ERROR
		END CATCH

		
End

GO

