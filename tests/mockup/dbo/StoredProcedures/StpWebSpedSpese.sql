
-- ==========================================================================================
-- Entity Name:    StpWebSpedSpese
-- Author:         Miki
-- Create date:    29/03/2013 17:57:46
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    Stp di calcolo spese  da portale ecom
-- History:
-- dav 230123 Tolto ivadefault per cambio logica
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpWebSpedSpese] (
	@Provincia NVARCHAR(5),
	@IdPaese NVARCHAR(20)
	)
AS
BEGIN
	SELECT TbSpedSpese.IdTraspSpesa,
		TbSpedSpese.DescTraspSpesa,
		dbo.TbCntIva.Aliquota AS Aliquota,
		TbSpedSpese.CostoTraspSpesa AS SpeseTraspVlt,
		ROUND(TbSpedSpese.CostoTraspSpesa * CONVERT(MONEY, dbo.TbCntIva.Aliquota / 100), 2) AS SpeseTraspImpostaVlt,
		ROUND(TbSpedSpese.CostoTraspSpesa * CONVERT(MONEY, 1 + dbo.TbCntIva.Aliquota / 100), 2) AS SpeseTraspImportoVlt,
		TbSpedSpese.IdIva AS IdIva
	FROM TbSpedSpese
	LEFT OUTER JOIN TbCntIva
		ON TbSpedSpese.IdIva = TbCntIva.IdIva
	WHERE TbSpedSpese.Disabilita = 0
	ORDER BY ISNULL(TbSpedSpese.Ordinamento, 9999) ASC
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '03/12/2013 00:00:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebSpedSpese';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebSpedSpese';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Miki', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebSpedSpese';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebSpedSpese';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebSpedSpese';


GO

