
-- ==========================================================================================
-- Entity Name:	StpWebPaginePrt_AssImg
-- Author:	Fab
-- Create date:	12/03/2013 00:06:00
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Stp Interna, aggiorna immagini in TbWebAmbitiPrt
-- ==========================================================================================


CREATE Procedure [dbo].[StpWebPaginePrt_AssImg]
	(
	@IdWebAmbitoPrt int
	)
AS
	/* SET NOCOUNT ON */

	UPDATE    TbWebAmbitiPrt
	SET              IdImg =
	(SELECT     TOP (1) IdImg
	FROM          TbImmagini
	WHERE      (IdDoc = @IdWebAmbitoPrt) AND (TipoDoc = 'TbWebAmbitiPrt'))
	WHERE     (IdWebAmbitoPrt = @IdWebAmbitoPrt)
	
	RETURN

GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPaginePrt_AssImg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPaginePrt_AssImg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPaginePrt_AssImg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPaginePrt_AssImg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '04/25/2013 21:44:58', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPaginePrt_AssImg';


GO

