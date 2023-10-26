
-- ==========================================================================================
-- Entity Name:	StpWebRichieste_Ins
-- Author:	Dav
-- Create date:	18/07/2013 00:06:00
-- AutoCreate:	NO
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Stp Portale Web, registra richieste
-- History:
-- MIK 17/12/15: StpWebRichieste_Ins sostituisce StpXWebRichieste_Ins che cade in disuso.
-- ==========================================================================================

CREATE Procedure [dbo].[StpWebRichieste_Ins]
( 
	@EMailRichiedente nvarchar(256),
	@Nominativo nvarchar(256),
	@TestoRichiesta nvarchar(max)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IdContatto int

	BEGIN TRY
		BEGIN TRANSACTION

			-- Inserisce l'utente se mai creato
			IF(EXISTS(select IdContatto  FROM TbContatti WHERE EMail = @EMailRichiedente))
				BEGIN
	
					--Contatto è già presente
					SET @IdContatto = (select IdContatto  FROM TbContatti WHERE EMail = @EMailRichiedente)
				END
			ELSE
				BEGIN
					--Contatto non pesente perciò lo aggiungo
					--Siccome l'utente inserisce un nominativo lo metto nella ragSoc e non sul campo Nome
					Insert Into TbContatti
								([RagSoc],[EMail],Disabilita,[CodFnzTipo],[AnnullatoWebData],[SysUserCreate],[SysDateCreate])
								Values
								(@Nominativo,@EMailRichiedente,0,'WEB',Getdate(),NULL,Getdate())

					SET @IdContatto = SCOPE_IDENTITY()
				END

			--Inserimento richiesta

			INSERT INTO TbAttivita (TipoDoc,IdDoc,NoteAttivita,CodFnz)
			VALUES ('TbContatti',@IdContatto,@TestoRichiesta,'WEB')
		COMMIT TRANSACTION
	END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			rollback transaction
			Declare @Msg as nvarchar(300)
			Declare @Msg1 as nvarchar(300)

			SET @Msg= ERROR_MESSAGE()
			SET @Msg1= 'Errore StpWebRichieste_Ins'

			Execute StpUteMsg_Ins   @Msg,@Msg1,'','WRN',null
		END CATCH


END

GO

