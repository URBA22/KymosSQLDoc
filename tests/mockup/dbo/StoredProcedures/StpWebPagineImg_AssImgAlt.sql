
-- ==========================================================================================
-- Entity Name:	StpWebPagineImg_AssImgAlt
-- Author:	Fab
-- Create date:	27/05/2013 09:24:27
-- AutoCreate:	NO
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Upload immagini 
-- ==========================================================================================


CREATE Procedure [dbo].[StpWebPagineImg_AssImgAlt]
	(
	@IdPaginaImg int
	)
AS
	/* SET NOCOUNT ON */
			
			-- aggancia immagine inserita nel db
			
			UPDATE TbWebPagineImg 
			SET IdImgAlt = (SELECT TOP(1) IdImg FROM TbImmagini  WHERE (IdDoc = @IdPaginaImg) AND TipoDoc = 'TbWebPagineImg_Over')
			WHERE IdPaginaImg = @IdPaginaImg
			
			-- aggiorna anche le pagine derivate con immagine nulla
			-- aggiorna solo i figli con immagine nulla (resettata in fase di modifica del padre)
			
			UPDATE TbWebPagineImg
			SET  IdImgAlt = TbWebPagineImg_Master.IdImgAlt
			FROM  TbWebPagineImg AS TbWebPagineImg_Master INNER JOIN
			TbWebPagineImg ON TbWebPagineImg_Master.IdPaginaImg = TbWebPagineImg.IdPaginaImgPadre
			WHERE  (TbWebPagineImg.IdImgAlt IS NULL) AND (TbWebPagineImg_Master.IdPaginaImg = @IdPaginaImg)
			
	RETURN

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_AssImgAlt';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_AssImgAlt';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_AssImgAlt';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_AssImgAlt';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '04/25/2013 21:44:45', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_AssImgAlt';


GO

