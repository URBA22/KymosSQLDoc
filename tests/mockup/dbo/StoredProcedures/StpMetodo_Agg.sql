
-- ==========================================================================================
-- Entity Name:   StpMetodo_Agg
-- Author:        mik
-- Create date:   11.01.21
-- Custom_Dbo:	  NO
-- Standard_dbo:  Dbo
-- CustomNote:    
-- Description:   
-- History:
-- mik 210111 : Procedfura usata per il ritorno della procedura di importazione DDT/Fatture in Metodo
-- mik 210211 : Cambiato messaggio nell'attività
-- ==========================================================================================
CREATE Procedure [dbo].[StpMetodo_Agg]
(
	@DaId as nvarchar(20), --ID iniziale
	@AId as nvarchar(20), --ID finale
	@TipoDoc as nvarchar(5), -- tipo: Indica il tipo di operazione per cui si sta facendo l'aggiornamento
							-- CDDT : CliDdt
							-- CFAT : CliFat
	@Cmd as nvarchar(20), -- comando: UPD aggiornamento su esito attività del singolo oggetto
							--			END terminazione attività
	@StatoCmd as nvarchar(20),		--stato del comando: 
									--			OK
									--			ERR
	@NoteCmd as nvarchar(max), --messaggio eventuale
	@SysUserCreate as nvarchar(256)
)
As
Begin

	DECLARE @Msg as nvarchar(max)
	DECLARE @Msg1 as nvarchar(max)
	
	BEGIN TRY
		BEGIN TRANSACTION
			-- Clienti DDT
			IF(@TipoDoc='CDDT')
			BEGIN
				IF(@Cmd='UPD')
				BEGIN
					If @StatoCmd = 'OK'
					BEGIN
						--esito positivo
						--aggiorno DataExport
						UPDATE TbCliDdt
						SET DataExport = GETDATE()
						WHERE(IdCliDdt >= @DaId) AND(IdCliDdt <= @AId)
					END

					--If @StatoCmd = 'ERR'
					--BEGIN
					--END
				END

				IF(@Cmd='END')
				BEGIN
					If @StatoCmd = 'OK'
					BEGIN
						INSERT INTO TbAttivita
						(IdUtente, IdUtenteDest, DescAttivita, FlgAperta, NoteAttivita, DataAttivita, SysDateCreate, SysUserCreate)
						SELECT   @SysUserCreate AS IdUtente, @SysUserCreate as IdUtenteDest, 'Esito importazione DDT in Metodo.' AS DescAttivita, 
						0 AS FlgAperta, 'Importazione DDT da ' + ISNULL(@DaId,'') + ' a ' + ISNULL(@AId,'') + ' in Metodo completata con successo. ' + @NoteCmd AS NoteAttivita, GETDATE() AS DataAttivita, GETDATE() AS SysDateCreate, @SysUserCreate AS SysUserCreate
					END

					If @StatoCmd = 'ERR'
					BEGIN
						INSERT INTO TbAttivita
						(IdUtente, IdUtenteDest, DescAttivita, FlgAperta, NoteAttivita, DataAttivita, SysDateCreate, SysUserCreate)
						SELECT   @SysUserCreate AS IdUtente, @SysUserCreate as IdUtenteDest, 'Esito importazione DDT in Metodo.' AS DescAttivita, 
						1 AS FlgAperta, 'Importazione DDT da ' + ISNULL(@DaId,'') + ' a ' + ISNULL(@AId,'') + ' in Metodo completata con errori. ' + @NoteCmd AS NoteAttivita, GETDATE() AS DataAttivita, GETDATE() AS SysDateCreate, @SysUserCreate AS SysUserCreate
					END
				END
			END

			-- Clienti Fatture
			IF(@TipoDoc='CFAT')
			BEGIN
				IF(@Cmd='UPD')
				BEGIN
					If @StatoCmd = 'OK'
					BEGIN
						--esito positivo
						--aggiorno DataExport
						
						UPDATE TbCliFat
						SET DataExport = GETDATE(),
						Contabilizzata =1
						WHERE TbCliFat.IdCliFat >= @DaId AND TbCliFat.IdCliFat <= @AId AND TbCliFat.CodiceContabile IS NOT NULL
						AND DataExport IS NULL
					END

					--If @StatoCmd = 'ERR'
					--BEGIN
					--END
				END

				IF(@Cmd='END')
				BEGIN
					If @StatoCmd = 'OK'
					BEGIN
						INSERT INTO TbAttivita
						(IdUtente, IdUtenteDest, DescAttivita, FlgAperta, NoteAttivita, DataAttivita, SysDateCreate, SysUserCreate)
						SELECT   @SysUserCreate AS IdUtente, @SysUserCreate as IdUtenteDest, 'Esito importazione fatture in Metodo.' AS DescAttivita, 
						0 AS FlgAperta, 'Importazione fatture da ' + ISNULL(@DaId,'') + ' a ' + ISNULL(@AId,'') + ' in Metodo completata con successo. ' + @NoteCmd AS NoteAttivita, GETDATE() AS DataAttivita, GETDATE() AS SysDateCreate, @SysUserCreate AS SysUserCreate
					END

					If @StatoCmd = 'ERR'
					BEGIN
						INSERT INTO TbAttivita
						(IdUtente, IdUtenteDest, DescAttivita, FlgAperta, NoteAttivita, DataAttivita, SysDateCreate, SysUserCreate)
						SELECT   @SysUserCreate AS IdUtente, @SysUserCreate as IdUtenteDest, 'Esito importazione fatture in Metodo.' AS DescAttivita, 
						1 AS FlgAperta, 'Importazione fatture da ' + ISNULL(@DaId,'') + ' a ' + ISNULL(@AId,'') + ' in Metodo completata con errori. ' + @NoteCmd AS NoteAttivita, GETDATE() AS DataAttivita, GETDATE() AS SysDateCreate, @SysUserCreate AS SysUserCreate
					END
				END
			END

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		-- Execute error retrieval routine.
		rollback transaction Trans1
		Declare @MsgExt as nvarchar(max)
		SET @MsgExt= ERROR_MESSAGE()
		
	END CATCH
End

GO

