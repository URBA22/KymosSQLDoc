


        
-- ==========================================================================================
-- Entity Name:   FncCliOrdDetAttvtSrv
-- Author:        dav
-- Create date:   220520
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Controlla la presenza attività da oridne a progetto e viceversa
-- History:
-- dav 220520 Creazione
-- ==========================================================================================

CREATE FUNCTION [dbo].[FncCliOrdDetAttvtSrv]
(	
	
)
RETURNS TABLE 
AS
RETURN 
(

	----------------------------------------------------------------------------------
	-- Attività negli ordini non presenti nei progetti
	----------------------------------------------------------------------------------
	
	SELECT 'CLIORD' AS Tipo, drvAttvtOrd.IdCliOrd, drvAttvtOrd.IdCliPrj, FrmOpen, drvAttvtOrd.IdCliOrd As IdDoc, drvAttvtOrd.NRiga, drvAttvtOrd.IdArticolo, drvAttvtOrd.IdAttivita, drvAttvtOrd.DescAttivita
	FROM
	(
		SELECT
		'Kymos.Clienti.FrmCliOrdScheda' AS FrmOpen,
		TbCliOrdDet.IdCliOrd AS IdCliOrd,
		NULL AS IdCliPrj,
		TbCliOrdDet.NRiga,
		TbCliOrdDet.IdCliOrdDet, TbAttivita.IdAttivita, TbCliPrvDist.IdArticolo,
		TbAttivita.DescAttivita
		FROM
		TbCliOrdDet INNER JOIN
		TbCliPrvDist ON TbCliPrvDist.IdCliPrv = TbCliOrdDet.IdCliPrv INNER JOIN
		TbAttivita ON  TbAttivita.IdDoc = TbCliPrvDist.IdArticolo AND TbAttivita.TipoDoc = 'TbArticoli'

	) drvAttvtOrd LEFT OUTER JOIN
	(
		SELECT
		TbCliPrj.IdCliPrj,
		TbCliPrj.IdCliOrdDet, TbAttivita.IdAttivita, TbAttivita.IdAttivitaOrigine
		FROM
		TbCliPrj
		INNER JOIN
		TbAttivita
		ON TbAttivita.IdDoc = TbCliPrj.IdCliPrj AND TbAttivita.TipoDoc = 'TbCliPrj'
	) drvAttvtPrj ON drvAttvtPrj.IdCliOrdDet = drvAttvtOrd.IdCliOrdDet AND drvAttvtPrj.IdAttivitaOrigine = drvAttvtOrd.IdAttivita

	WHERE   
	drvAttvtPrj.IdAttivita IS NULL

	UNION ALL

	----------------------------------------------------------------------------------
	-- Attività nei progetti non presenti negli ordini
	----------------------------------------------------------------------------------

	SELECT 'CLIPRJ' AS Tipo, drvAttvtPrj.IdCliOrd, drvAttvtPrj.IdCliPrj, FrmOpen, drvAttvtPrj.IdCliPrj As IdDoc, 1 as NRiga, drvAttvtPrj.IdArticolo, drvAttvtPrj.IdAttivita, drvAttvtPrj.DescAttivita
	FROM
	(
		SELECT
		'Kymos.Progetti.FrmCliPrjScheda' AS FrmOpen,
		NULL AS IdCliOrd,
		TbCliPrj.IdCliPrj,
		TbCliPrj.IdCliOrdDet, TbAttivita.IdAttivita, TbAttivita.IdAttivitaOrigine, TbAttivita.DescAttivita, TbAttivita.IdArticolo
		FROM
		TbCliPrj
		INNER JOIN
		TbAttivita
		ON TbAttivita.IdDoc = TbCliPrj.IdCliPrj AND TbAttivita.TipoDoc = 'TbCliPrj'
	) drvAttvtPrj
	LEFT OUTER JOIN
	(
		SELECT
		TbCliOrdDet.IdCliOrd,
		TbCliOrdDet.IdCliOrdDet, TbAttivita.IdAttivita, TbCliPrvDist.IdArticolo
		FROM
		TbCliOrdDet INNER JOIN
		TbCliPrvDist ON TbCliPrvDist.IdCliPrv = TbCliOrdDet.IdCliPrv INNER JOIN
		TbAttivita ON  TbAttivita.IdDoc = TbCliPrvDist.IdArticolo AND TbAttivita.TipoDoc = 'TbArticoli'
	) drvAttvtOrd
	ON drvAttvtPrj.IdCliOrdDet = drvAttvtOrd.IdCliOrdDet AND drvAttvtPrj.IdAttivitaOrigine = drvAttvtOrd.IdAttivita

	WHERE   
	drvAttvtOrd.IdAttivita IS NULL

)

GO

