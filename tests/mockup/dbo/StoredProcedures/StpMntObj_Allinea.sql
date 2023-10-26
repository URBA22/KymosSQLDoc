

-- ==========================================================================================
-- Entity Name:   StpMntObj_Allinea
-- Author:	      dav
-- Create date:	  05.06.18
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	  Write custom note here
-- Description:	  Allinea DBO
-- History:
-- dav 190901 Tolta sezione aggiunta colonna
-- ==========================================================================================
      
CREATE Procedure [dbo].[StpMntObj_Allinea]

As
Begin
	
	Declare @Sql as nvarchar (300)
				
	If  DB_NAME() <> 'dbo'
				
		BEGIN
			

			Execute StpUteMsg_Ins   'Allinea',
									'Allinea Object da DBO',
									'',
									'INF',
									 NULL

			Declare @DbVer as nvarchar(20)
			Set @DbVer = IsNull(dbo.FncKeyValue (N'DbVersion', null),'000000')

			--If @DbVer < '180605'
			--	BEGIN

					
			--		-- aggiunge la colonna alla tabella TbMntObjDef
			--		IF COL_LENGTH('dbo.TbMntObjDef', 'FlgSel') IS  NULL
			--			BEGIN
			--				BEGIN TRANSACTION
			--				ALTER TABLE dbo.TbMntObjDef ADD
			--				FlgSel bit NOT NULL CONSTRAINT DF_TbMntObjDef_FlgSel DEFAULT 0
			--				ALTER TABLE dbo.TbMntObjDef SET (LOCK_ESCALATION = TABLE)
			--				COMMIT
			--			END
						
			--	END

			/**********************************
			* Aggiorna versione db
			**********************************/

			If dbo.FncKeyValueExists('DbVersion',null) = 0
					BEGIN
						INSERT INTO TbSettingKey
						(IdKey, CodFnz, NoteSetting, SysDateCreate)
						VALUES        (N'DbVersion', N'KEYE', N'Inserimento automatico versione db aggiornato', GETDATE())
					END


			Select @DbVer = max(IdVrs) from TbMntObjVrs

			UPDATE  TbSettingKey
			SET  SysDateUpdate = GETDATE(), Value = @DbVer
			WHERE  (IdKey = N'DbVersion') and isnull(Value,'') < @DbVer 

			Print 'Aggiornamento Versione Completato'

		END

End

GO

