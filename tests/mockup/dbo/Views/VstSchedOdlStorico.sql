








-- ==========================================================================================
-- Entity Name:   VstSchedOdlStorico
-- Author:        dav
-- Create date:   
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 02.11.15 Allineamento con VstSchedOdl
-- dav 16.11.15 Aggiunto reparti e ledinfo
-- dav 26.11.15 Aggiunto FlgElabRicorsivo per controllo ricorsività , DescOdl con RagSoc
-- fab 25.03.16	Aggiunto ColRigaUte
-- dav 20.02.17 Aggiunta Campi
-- fab 09.08.17	Aggiunto DurataRes come differnza tra DurataProd e DurataMinutiTot
-- dav 12.03.18 Aggiunto ProdPrevGiorno
-- dav 14.03.18 Aggiunto FlgMultipallet
-- fab 200429 Convertito i Sem in smallint
-- fab 200430 Messo a 0 FlgMultipallet per evitare NULL
-- simone 210303 Aggiunto DurataObiettivo, DataInizioObiettivo, DataFineObiettivo
-- dav 230407 Formattazione, corretto DurataRes
-- ==========================================================================================


CREATE VIEW [dbo].[VstSchedOdlStorico]
AS

SELECT dbo.TbSchedOdl.IdArticolo,
	dbo.TbSchedOdl.Qta,
	ISNULL(dbo.TbSchedOdlElab.QtaProd, dbo.TbSchedOdl.QtaProdotta) AS QtaProdotta,
	dbo.TbSchedOdl.QtaDaProdurre,
	dbo.TbSchedOdl.DurataAtrz,
	dbo.TbSchedOdl.Durata,
	dbo.TbSchedOdl.DataInizio,
	dbo.TbSchedOdl.DurataMinutiTot,
	dbo.TbSchedOdl.DataFine,
	dbo.TbSchedOdl.DataInizioRichiesto,
	dbo.TbSchedOdl.DataChiusura,
	dbo.TbSchedOdl.NoteSchedOdl,
	dbo.TbSchedOdl.Colore,
	dbo.TbSchedOdl.FlgSchedulato,
	dbo.TbSchedOdl.FlgChiuso,
	dbo.TbSchedOdl.FlgInizioBloccato,
	dbo.TbSchedOdl.FlgInizioRichiesto,
	dbo.TbSchedOdl.IdSequenza,
	dbo.TbSchedOdl.IdCdlUnita,
	CONVERT(SMALLINT, dbo.TbSchedOdl.Sem1) AS Sem1,
	CONVERT(SMALLINT, dbo.TbSchedOdl.Sem2) AS Sem2,
	CONVERT(SMALLINT, dbo.TbSchedOdl.Sem3) AS Sem3,
	CONVERT(SMALLINT, dbo.TbSchedOdl.Sem4) AS Sem4,
	dbo.TbSchedOdl.Efficenza,
	dbo.TbSchedOdl.SysDateCreate,
	dbo.TbSchedOdl.SysUserCreate,
	dbo.TbSchedOdl.SysDateUpdate,
	dbo.TbSchedOdl.SysUserUpdate,
	dbo.TbSchedOdl.SysRowVersion,
	dbo.TbSchedOdl.IdSchedOdl,
	dbo.TbProdCdlUnita.IdCalendario,
	ISNULL(dbo.TbProdCdl.Ordinamento, 1) * 1000000 + ISNULL(dbo.TbProdAnagCdlCatgr.Ordinamento, 1) * 1000 + ISNULL(dbo.TbProdCdlUnita.Ordinamento, 1) AS Ord,
	dbo.TbOdlDet.IdOdlDet,
	dbo.TbProdCdlUnita.IdCdl,
	dbo.TbSchedOdl.IdOdlDetFase,
	dbo.TbSchedOdl.DescSchedOdlSnt,
	ISNULL(dbo.TbSchedOdl.DescSchedOdl, N'') + ISNULL(dbo.VstSchedOdlDesc.DescOdl, N'') AS DescSchedOdlDet,
	dbo.TbSchedOdl.IdCliOrdDet,
	dbo.TbProdCdl.IdCategoria,
	dbo.TbSchedOdl.DataFineRichiesta,
	dbo.TbSchedOdl.Similitudine,
	ISNULL(dbo.TbProdCdl.FlgPark, 0) AS FlgPark,
	CAST(CASE 
			WHEN dbo.TbSchedOdl.FlgChiuso = 1
				OR dbo.TbSchedOdl.FlgFaseExt = 1
				THEN 1
			ELSE 0
			END AS BIT) AS FlgBloccato,
	dbo.TbSchedOdl.LeadTimeFineProd,
	dbo.TbSchedOdl.DescSchedOdl,
	ISNULL(dbo.VstSchedOdlDesc.DescOdl, dbo.TbSchedOdl.DescSchedOdlSnt) + CHAR(10) + Isnull(TbSchedodl.RagSoc, N'') AS DescOdl,
	dbo.TbProdCdlUnita.Colore AS ColoreCdlUnita,
	dbo.TbSchedOdl.NFase,
	dbo.TbSchedOdl.IdSchedOdlNext,
	dbo.TbSchedOdl.DataFineLavExt,
	dbo.TbSchedOdl.ColoreLavExt,
	dbo.TbSchedOdl.IdForOrdDet,
	dbo.TbSchedOdl.DataInizioRichiestoPrev,
	dbo.TbSchedOdl.KeyExt,
	dbo.TbSchedOdl.KeyExtFase,
	dbo.TbSchedOdl.KeyProd,
	dbo.TbSchedOdl.KeyProdOrd,
	dbo.TbSchedOdl.FlgFaseExt,
	dbo.TbSchedOdl.IdSchedOdlExt,
	dbo.TbSchedOdl.FlgIniziato,
	dbo.TbSchedOdl.FlgSospeso,
	dbo.TbSchedOdl.DataInizioEffettivo,
	dbo.TbSchedOdl.DataChiusuraProd,
	dbo.TbSchedOdl.FlgRischedula,
	dbo.TbSchedOdl.NoteSchedOdlProd,
	dbo.TbSchedOdl.CodFnzStato,
	dbo.TbSchedOdl.RagSoc,
	ISNULL(dbo.TbSchedOdl.IdArticolo, N'') + N'-' + ISNULL(dbo.TbSchedOdl.NoteSchedOdl, N'') + N'-' + ISNULL(dbo.TbOdlDetFasi.IdCdlUnita, N'') + N'-' + ISNULL(dbo.TbSchedOdl.DescSchedOdl, N'') + ISNULL(dbo.VstSchedOdlDesc.DescOdl, N'') + N'-' + ISNULL(dbo.TbSchedOdl.DescSchedOdlSnt, N'') AS DescFilter,
	dbo.TbSchedOdl.FlgGestMan,
	dbo.TbSchedOdl.FlgGestManCdlUnita,
	dbo.TbSchedOdl.IdSchedOdlPrev,
	dbo.TbSchedOdl.FlgDataInizioRichiestoPrevElab,
	CONVERT(NVARCHAR(50), dbo.TbSchedOdl.IdSchedOdlMaster) AS IdSchedOdlMaster,
	CASE 
		WHEN dbo.TbSchedOdl.IdSchedOdl = dbo.TbSchedOdl.IdSchedOdlMaster
			THEN '000'
		ELSE NULL
		END AS IdSchedOdlMasterRif,
	dbo.TbSchedOdl.FlgAllarme,
	CASE 
		WHEN FlgAllarme = 1
			THEN '#FF0000'
		WHEN isnull(TbSchedOdl.Colore, '') <> ''
			THEN TbSchedOdl.Colore
		WHEN TbSchedOdl.FlgGestMan = 1
			THEN '#FF8000'
		WHEN FlgSchedulato = 1
			THEN '#0080FF'
		ELSE '#FFFF00'
		END AS ColRiga,
	dbo.TbSchedOdl.FlgSlegaSequenza,
	'F' + CONVERT(NVARCHAR(50), CASE 
			WHEN NOT (TbSchedOdl.IdSchedOdlNext IS NULL)
				OR NOT (TbSchedOdl.IdSchedOdlPrev IS NULL)
				THEN TbSchedOdl.NFase
			WHEN TbSchedOdl.KeyProdOrd = 10
				THEN NULL
			ELSE TbSchedOdl.KeyProdOrd
			END) AS NFaseInfo,
	dbo.TbProdCdlUnita.Efficenza AS EfficenzaMacchina,
	CASE 
		WHEN DataFineRichiesta < ISNULL(DataFineLav, DataFine)
			THEN 1
		ELSE 0
		END AS LedInfo,
	DrvSchedNext.IdCdlUnita AS IdCdlUnitaNext,
	DrvSchedNext.IdSequenza AS IdSequenzaNext,
	CONVERT(BIT, 0) AS FlgChangeNext,
	dbo.TbCliOrdDet.DataConsConfermataInit,
	dbo.TbProdCdl.IdReparto,
	dbo.TbSchedOdl.FlgElabRicorsivo,
	dbo.TbSchedOdl.FlgSchedInversa,
	dbo.TbSchedOdl.FlgCliCLav,
	dbo.TbSchedOdl.ColRigaUte,
	dbo.TbOdlDetElab.ColStatoMrp,
	dbo.TbOdlDetElab.DescStatoMrp,
	dbo.TbSchedOdlElab.DurataProd,
	dbo.TbSchedOdl.CmpOpz01,
	dbo.TbSchedOdl.CmpOpz02,
	dbo.TbSchedOdl.CmpOpz03,
	dbo.TbOdlDet.IdOdl,
	(dbo.TbSchedOdl.DurataMinutiTot * 60) - ISNULL(dbo.TbSchedOdlElab.DurataProd,0)  AS DurataRes,
	dbo.TbSchedOdl.ProdPrevGiorno,
	ISNULL(dbo.TbProdCdl.FlgMultipallet, 0) AS FlgMultipallet,
	dbo.TbSchedOdl.DurataObiettivo,
	dbo.TbSchedOdl.DataInizioObiettivo,
	dbo.TbSchedOdl.DataFineObiettivo
FROM dbo.TbSchedOdlElab
INNER JOIN dbo.TbSchedOdl
	ON dbo.TbSchedOdlElab.IdSchedOdl = dbo.TbSchedOdl.IdSchedOdl
LEFT OUTER JOIN (
	SELECT IdSchedOdl,
		IdCdlUnita,
		IdSequenza
	FROM dbo.TbSchedOdl AS TbSchedOdl_1
	) AS DrvSchedNext
	ON dbo.TbSchedOdl.IdSchedOdlNext = DrvSchedNext.IdSchedOdl
LEFT OUTER JOIN dbo.VstSchedOdlDesc
	ON dbo.TbSchedOdl.IdSchedOdl = dbo.VstSchedOdlDesc.IdSchedOdl
LEFT OUTER JOIN (
	SELECT IdOdlDet,
		MAX(DATEADD(dd, ISNULL(LeadTimeFineProd, 0), DataFine)) AS DataFineLav
	FROM dbo.TbSchedOdl AS TbSchedOdl_2
	WHERE (DataChiusura IS NULL)
	GROUP BY IdOdlDet
	) AS DrvDateFine
	ON DrvDateFine.IdOdlDet = dbo.TbSchedOdl.IdOdlDet
LEFT OUTER JOIN dbo.TbOdlDetFasi
	ON dbo.TbSchedOdl.IdOdlDetFase = dbo.TbOdlDetFasi.IdOdlDetFase
LEFT OUTER JOIN dbo.TbOdlDet
	ON TbOdlDet.IdOdlDet = TbOdlDetFasi.IdOdlDet
LEFT OUTER JOIN dbo.TbCliOrdDet
	ON dbo.TbOdlDet.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
LEFT OUTER JOIN dbo.TbProdCdlUnita
	ON dbo.TbSchedOdl.IdCdlUnita = dbo.TbProdCdlUnita.IdCdlUnita
LEFT OUTER JOIN dbo.TbProdCdl
	ON dbo.TbProdCdlUnita.IdCdl = dbo.TbProdCdl.IdCdl
LEFT OUTER JOIN dbo.TbProdAnagCdlCatgr
	ON dbo.TbProdCdl.IdCategoria = dbo.TbProdAnagCdlCatgr.IdCategoria
LEFT OUTER JOIN dbo.TbOdlDetElab
	ON dbo.TbOdlDet.IdOdlDet = dbo.TbOdlDetElab.IdOdlDet

GO

