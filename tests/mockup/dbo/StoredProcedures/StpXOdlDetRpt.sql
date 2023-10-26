
-- ==========================================================================================
-- Entity Name:   StpXOdlDetRpt
-- Author:        dav
-- Create date:   221211
-- Custom_Dbo:	  YES
-- Standard_dbo:  NO
-- CustomNote:    
-- Description:	  Storicizza dati per report consuntivo
--
--                  Valori gestiti Dataset
--
--                  Consuntivo_00 -- Trigger di storicizzazione se JSON non elaborato
--                  Consuntivo_CostAgg 
--                  Consuntivo_Dist 
--                  Consuntivo_Fasi 
--                  Consuntivo_OrdFor 
--                  Consuntivo_RegTmp 
--                  Consuntivo_Tot
--             
--                  Se @DataSet NULL o '' Elabora tutto    
--                  Se JSON NULL 
--                      Se @DataSet = Consuntivo_00 e  Elabora tutto e carica  Consuntivo_00 
--                      Altrimenti attende 10 s e ricontrolla JSON, se NULL carica i dati e li resistuisce senza memorizzarli
--                  Se JSON NOT NULL
--                      Carica i dati dal JSON
-- History
-- dav 221211 Creazione
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpXOdlDetRpt] (
	@IdOdlDet INT,
	@DataSet NVARCHAR(50),
	@SysUser NVARCHAR(256)
	)
AS
BEGIN
	DECLARE @Debug AS INT = 1
	DECLARE @InfoElab AS NVARCHAR(200)
	DECLARE @JsonReport AS NVARCHAR(max)
	DECLARE @FlgElab AS BIT = 0
	DECLARE @StartExecutionTime DATETIME2

	SET @StartExecutionTime = SysUTCDateTime()
	SET @DataSet = ISNULL(@DataSet, '')

	IF @IdOdlDet IS NULL
		RETURN

	--------------------------------------------
	-- Carica JSON memorizzato
	--------------------------------------------
	SET @JsonReport = (
			SELECT JsonReport
			FROM TbOdlDetElab
			WHERE IdOdlDet = @IdOdldet
			)

	-- Se dataset '' richiede elab e storicizzazione
	IF @DataSet = ''
		SET @FlgElab = 1

	-- Se Consuntivo_00 e JSON NULL richiede elab e storicizzazione
	IF @DataSet = 'Consuntivo_00'
		AND @JsonReport IS NULL
		SET @FlgElab = 1

	-- Se JSON NULL e dataset definito attende 10 s
	-- Questo per permettere l'elaborazione lanciata da 00
	-- In questo modo velocizza perchè JSON elaborato da 00
	-- Se poi non è ancora finito carica il json dal select e poi lo restituisce
	IF @DataSet NOT IN ('Consuntivo_00', '')
		AND @JsonReport IS NULL
	BEGIN
		WAITFOR DELAY '00:00:10';

		SET @JsonReport = (
				SELECT JsonReport
				FROM TbOdlDetElab
				WHERE IdOdlDet = @IdOdldet
				)
	END

	--------------------------------------------
	-- Dataset non storicizzato, ELABORA TUTTO
	--------------------------------------------
	IF @JsonReport IS NULL
		OR @DataSet = ''
		OR @DataSet = 'Consuntivo_Chk'
	BEGIN
		--PRINT 'Elabora JSON'
		SET @InfoElab = 'Elabora JSON '

		--------------------------------------------
		-- Calcola dataset di controllo
		--------------------------------------------
		-- Calcola un record con i valori che possono essere cambiati
		DECLARE @JsonReport_Chk AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_00'
			OR @FlgElab = 1
			OR @DataSet = 'Consuntivo_Chk'
		BEGIN
			SET @InfoElab = @InfoElab + ' Chk'
			SET @JsonReport_Chk = (
					SELECT *
					FROM (
						SELECT VstOdlDet.IdOdl,
							VstOdlDet.SysRowVersion,
							VstOdlDet.CostoOdlTotUnit,
							VstOdlDet.PrezzoOffTot,
							VstOdlDet.PrezzoFatTot,
							VstOdlDet.PrezzoPropostoTot,
							VstOdlDet.PrezzoTot,
							VstOdlDet.DurataPrvTot,
							VstOdlDet.CostoLavEstUnitP,
							VstOdlDet.PrezzoLavEstUnitD,
							VstOdlDet.PrezzoTotUnitL,
							VstOdlDet.PrezzoTotUnitP,
							VstOdlDet.PrezzoLavEstUnitP,
							VstOdlDet.CostoOdlAgntUnit,
							VstOdlDet.CostoOdlLavEstUnit,
							VstOdlDet.CostoOdlLavIntUnit,
							VstOdlDet.CostoOdlMaterialiUnit,
							VstOdlDet.CostoPrvLavEstUnitP,
							VstOdlDet.CostoOdlLavEstUnitP,
							VstOdlDet.CostoOdlLavEstUnitD,
							VstOdlDet.CostoPrvLavEstUnitD,
							VstOdlDet.CostoLavEstUnitD,
							VstOdlDet.DurataOdlTot,
							VstOdlDet.DurataTot,
							VstOdlDet.DurataPrvTotD,
							VstOdlDet.DurataOdlTotD,
							VstOdlDet.DurataTotD,
							VstOdlDet.CostoOdlTotUnitP,
							VstOdlDet.CostoPrvTotUnitP,
							VstOdlDet.CostoTotUnitP,
							VstOdlDet.CostoOdlTotUnitL,
							VstOdlDet.CostoPrvTotUnitL,
							VstOdlDet.CostoTotUnitL,
							VstOdlDet.CostoPrvLavIntUnit,
							VstOdlDet.CostoPrvLavEstUnit,
							VstOdlDet.CostoPrvAgntUnit,
							VstOdlDet.CostoPrvMaterialiUnit,
							VstOdlDet.CostoPrvTotUnit,
							VstOdlDet.PrezzoPrvLavIntUnit,
							VstOdlDet.PrezzoPrvLavEstUnit,
							VstOdlDet.PrezzoPrvAgntUnit,
							VstOdlDet.PrezzoPrvMaterialiUnit,
							VstOdlDet.PrezzoOff,
							VstOdlDet.PrezzoPrv,
							VstOdlDet.MarginePrezzo,
							VstOdlDet.PrezzoFat,
							VstOdlDet.MarginePrezzoFat,
							VstOdlDet.MargineFat,
							VstOdlDet.MargineMateriali,
							VstOdlDet.MargineLavorazioni,
							VstOdlDet.MargineCostiAgnt,
							VstOdlDet.CostoUnit,
							VstOdlDet.QtaProdotta,
							VstOdlDet.CostoMateriali,
							VstOdlDet.CostoLavEst,
							VstOdlDet.CostoAgnt,
							VstOdlDet.CostoLavIntUnit,
							VstOdlDet.CostoLavEstUnit,
							VstOdlDet.CostoAgntUnit,
							VstOdlDet.CostoMaterialiUnit,
							VstOdlDet.CostoMaterialiExtra,
							VstOdlDet.CostoLavIntExtra,
							VstOdlDet.CostoLavEstExtra,
							VstOdlDet.PrezzoMateriali,
							VstOdlDet.CostoAgntExtra,
							VstOdlDet.PrezzoLavInt,
							VstOdlDet.CostoTotExtra,
							VstOdlDet.CostoTotUnit,
							VstOdlDet.CostoTot,
							VstOdlDet.PrezzoProposto,
							VstOdlDet.PrezzoAgntExtra,
							VstOdlDet.PrezzoLavEstExtra,
							VstOdlDet.PrezzoLavIntExtra,
							VstOdlDet.PrezzoMaterialiExtra,
							VstOdlDet.PrezzoMaterialiUnit,
							VstOdlDet.PrezzoAgntUnit,
							VstOdlDet.PrezzoLavEstUnit,
							VstOdlDet.PrezzoLavIntUnit,
							VstOdlDet.PrezzoAgnt,
							VstOdlDet.PrezzoLavEst,
							VstOdlDet.MargineLavorazioniExt,
							VstOdlDet.Margine,
							VstOdlDet.MargineProposto,
							VstOdlDet.Prezzo,
							VstOdlDet.CostoLavEstP,
							VstOdlDet.CostoLavEstD,
							VstOdlDet.CostoPrvMateriali,
							VstOdlDet.CostoOdlMateriali,
							VstOdlDet.CostoPrvLavEstP,
							VstOdlDet.CostoOdlLavEstP,
							VstOdlDet.CostoPrvTotP,
							VstOdlDet.CostoOdlTotP,
							VstOdlDet.CostoPrvLavInt,
							VstOdlDet.CostoOdlLavInt,
							VstOdlDet.CostoPrvLavEstD,
							VstOdlDet.CostoOdlLavEstD,
							VstOdlDet.CostoPrvTotL,
							VstOdlDet.CostoOdlTotL,
							VstOdlDet.CostoPrvTot,
							VstOdlDet.CostoOdlTot,
							VstOdlDet.CostoPrvAgnt,
							VstOdlDet.CostoOdlAgnt,
							VstOdlDet.CostoTotP,
							VstOdlDet.CostoLavInt,
							VstOdlDet.CostoTotL,
							VstOdlDet.PrezzoMateriale,
							VstOdlDet.PrezzoLavEstP,
							VstOdlDet.PrezzoTotP,
							VstOdlDet.PrezzoLavUnit,
							VstOdlDet.PrezzoTotL,
							VstOdlDet.PrezzoLavEstD,
							VstOdlDet.DurataPrvTotProd,
							VstOdlDet.DurataOdlTotProd,
							VstOdlDet.DurataTotProd,
							VstOdlDet.DurataPrvTotProdD,
							VstOdlDet.DurataOdlTotProdD,
							VstOdlDet.DurataTotProdD,
							VstOdlDet.PrezzoCliPrvTot,
							VstOdlDet.RicaricoCostoTot,
							VstOdlDet.RicaricoCostoPercTot,
							VstOdlDet.RicaricoPrezzoTot,
							VstOdlDet.RicaricoPrezzoPercTot,
							VstOdlDet_CtrlElab.IdOdlDet AS IdOdlDetElab
						FROM VstOdlDet
						LEFT OUTER JOIN VstOdlDet_CtrlElab
							ON VstOdlDet_CtrlElab.IdOdlDet = VstOdlDet.IdOdlDet
						WHERE (VstOdlDet.IdOdlDet = @IdOdlDet)
						) drv
					FOR JSON auto
					)

			-- Se di tipo Ckk controlla integrità, se non c'è resetta Json dataset per richiedere il caricamento complessivo
			IF @DataSet = 'Consuntivo_Chk'
			BEGIN
				DECLARE @JsonReport_ChkSto AS NVARCHAR(max)

				SET @JsonReport_ChkSto = (
						SELECT JsonReport
						FROM TbOdlDetElab
						WHERE IdOdlDet = @IdOdlDet
						)

				SELECT @JsonReport_ChkSto = root.VALUE
				FROM OPENJSON(@JsonReport_ChkSto) AS root
				WHERE root.[key] = 'Consuntivo_Chk'

				IF isnull(@JsonReport_Chk, '') <> isnull(@JsonReport_ChkSto, '')
				BEGIN
					PRINT 'Elabora Chk'

					SET @FlgElab = 1
				END
			END
		END

		--------------------------------------------
		-- Calcola dataset 00
		--------------------------------------------
		DECLARE @JsonReport_00 AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_00'
			OR @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' 00'
			SET @JsonReport_00 = (
					-- Incapsula il select altrimenti JSON AUTO crea un nodo per ogni namespace
					SELECT *
					FROM (
						SELECT VstOdlDet.IdOdl,
							VstOdlDet.NRiga,
							VstOdlDet.IdOdlDet,
							VstOdlDet.RagSoc,
							VstOdlDet.IdArticolo,
							VstOdlDet.Qta,
							VstOdlDet.UnitM,
							VstOdlDet.Descrizione,
							VstOdlDet.IdCliOrd,
							VstOdlDet.DataConsegna,
							VstOdlDet.RevisioneIdArt,
							VstOdlDet.NoteOdlDet,
							dbo.FncBcEncode(N'TbOdlDet', VstOdlDet.IdOdlDet, N'128') AS BCOdlDet,
							VstOdlDet.IdReparto,
							--VstArtImg.Immagine,
							TbArticoli.NPezziScatola,
							TbArticoli.NScatoleBancale,
							TbArticoli.StampoNImpronte,
							TbArticoli.QtaCiclo,
							CASE 
								WHEN TbArticoli.NPezziScatola = 0
									THEN NULL
								ELSE ceiling(VstOdlDet.Qta / TbArticoli.NPezziScatola)
								END AS NScatole,
							CASE 
								WHEN TbArticoli.QtaCiclo = 0
									THEN NULL
								ELSE ceiling(VstOdlDet.Qta / TbArticoli.QtaCiclo)
								END AS NGiorni,
							CASE 
								WHEN TbArticoli.NPezziScatola = 0
									THEN NULL
								ELSE ceiling(TbArticoli.QtaCiclo / TbArticoli.NPezziScatola)
								END AS NScatoleGiorno,
							VstCliOrdDet.IdImballo,
							VstCliOrdDet.DescImballo,
							VstCliOrdDet.IdCliPrj,
							TbArticoli.DimAltezza,
							TbArticoli.DimLunghezza,
							TbArticoli.DimLarghezza,
							VstCliOrdDet.IdMateriale,
							VstOdlDet.IdCliOff,
							VstOdlDet.DataRifCliOrd,
							VstOdlDet.DescRifCliOrd,
							VstOdlDet.IdArtDist,
							VstOdlDet.IdArtCiclo,
							VstOdlDet.IdCategoria,
							VstOdlDet.CicloVer,
							VstOdlDet.DistVer,
							VstOdlDet.Acronimo,
							VstCliOrdDet.Disegno,
							TbArtAnagMateriali.GruppoMateriale,
							CASE 
								WHEN isnull(VstOdlDet.qta, 0) <> isnull(VstOdlDet.QtaProdotta, 0)
									AND VstOdlDet.QtaProdotta > 0
									THEN '#ff0000'
								ELSE NULL
								END AS ColoreQta,
							VstOdlDet.CostoOdlTotUnit,
							VstOdlDet.ColQtaProdotta,
							VstOdlDet.ColQta,
							VstOdlDet.RicaricoCostoPerc,
							VstOdlDet.RicaricoPrezzoPerc,
							VstOdlDet.RicaricoCosto,
							VstOdlDet.RicaricoPrezzo,
							VstOdlDet.ColQtaDdt,
							VstOdlDet.QtaDdt,
							VstOdlDet.PrezzoCliPrvUnit,
							VstOdlDet.DescCompleta,
							VstOdlDet.ColLavEstUnit,
							VstOdlDet.ColLavEstUnitD,
							VstOdlDet.ColLavEstUnitP,
							VstOdlDet.ColLavIntUnit,
							VstOdlDet.ColCostoAgntUnit,
							VstOdlDet.ColMaterialiUnit,
							VstOdlDet.PrezzoOffTot,
							VstOdlDet.PrezzoFatTot,
							VstOdlDet.PrezzoPropostoTot,
							VstOdlDet.PrezzoTot,
							VstOdlDet.DurataPrvTot,
							VstOdlDet.CostoLavEstUnitP,
							VstOdlDet.PrezzoLavEstUnitD,
							VstOdlDet.PrezzoTotUnitL,
							VstOdlDet.PrezzoTotUnitP,
							VstOdlDet.PrezzoLavEstUnitP,
							VstOdlDet.CostoOdlAgntUnit,
							VstOdlDet.CostoOdlLavEstUnit,
							VstOdlDet.CostoOdlLavIntUnit,
							VstOdlDet.CostoOdlMaterialiUnit,
							VstOdlDet.CostoPrvLavEstUnitP,
							VstOdlDet.CostoOdlLavEstUnitP,
							VstOdlDet.CostoOdlLavEstUnitD,
							VstOdlDet.CostoPrvLavEstUnitD,
							VstOdlDet.CostoLavEstUnitD,
							VstOdlDet.DurataOdlTot,
							VstOdlDet.DurataTot,
							VstOdlDet.DurataPrvTotD,
							VstOdlDet.DurataOdlTotD,
							VstOdlDet.DurataTotD,
							VstOdlDet.CostoOdlTotUnitP,
							VstOdlDet.CostoPrvTotUnitP,
							VstOdlDet.CostoTotUnitP,
							VstOdlDet.CostoOdlTotUnitL,
							VstOdlDet.CostoPrvTotUnitL,
							VstOdlDet.CostoTotUnitL,
							VstOdlDet.CostoPrvLavIntUnit,
							VstOdlDet.CostoPrvLavEstUnit,
							VstOdlDet.CostoPrvAgntUnit,
							VstOdlDet.CostoPrvMaterialiUnit,
							VstOdlDet.CostoPrvTotUnit,
							VstOdlDet.PrezzoPrvLavIntUnit,
							VstOdlDet.PrezzoPrvLavEstUnit,
							VstOdlDet.PrezzoPrvAgntUnit,
							VstOdlDet.PrezzoPrvMaterialiUnit,
							VstOdlDet.PrezzoOff,
							VstOdlDet.PrezzoPrv,
							VstOdlDet.IdCliPrv,
							VstOdlDet.DataElab,
							VstOdlDet.MarginePrezzo,
							VstOdlDet.PrezzoFat,
							VstOdlDet.MarginePrezzoFat,
							VstOdlDet.MargineFat,
							VstOdlDet.MargineMateriali,
							VstOdlDet.MargineLavorazioni,
							VstOdlDet.MargineCostiAgnt,
							VstOdlDet.CostoUnit,
							VstOdlDet.QtaProdotta,
							VstOdlDet.CostoMateriali,
							VstOdlDet.CostoLavEst,
							VstOdlDet.CostoAgnt,
							VstOdlDet.CostoLavIntUnit,
							VstOdlDet.CostoLavEstUnit,
							VstOdlDet.CostoAgntUnit,
							VstOdlDet.CostoMaterialiUnit,
							VstOdlDet.CostoMaterialiExtra,
							VstOdlDet.CostoLavIntExtra,
							VstOdlDet.CostoLavEstExtra,
							VstOdlDet.PrezzoMateriali,
							VstOdlDet.CostoAgntExtra,
							VstOdlDet.PrezzoLavInt,
							VstOdlDet.CostoTotExtra,
							VstOdlDet.CostoTotUnit,
							VstOdlDet.CostoTot,
							VstOdlDet.PrezzoProposto,
							VstOdlDet.PrezzoAgntExtra,
							VstOdlDet.PrezzoLavEstExtra,
							VstOdlDet.PrezzoLavIntExtra,
							VstOdlDet.PrezzoMaterialiExtra,
							VstOdlDet.PrezzoMaterialiUnit,
							VstOdlDet.PrezzoAgntUnit,
							VstOdlDet.PrezzoLavEstUnit,
							VstOdlDet.PrezzoLavIntUnit,
							VstOdlDet.PrezzoAgnt,
							VstOdlDet.PrezzoLavEst,
							VstOdlDet.MargineLavorazioniExt,
							VstOdlDet.Margine,
							VstOdlDet.MargineProposto,
							VstOdlDet.Prezzo,
							VstOdlDet.NoteElab,
							VstOdlDet.ColElab,
							VstOdlDet.StatoElab,
							CASE 
								WHEN VstCliOrdDet.CodFnzStato = '8000'
									THEN '#c0c0c0'
								ELSE NULL
								END AS ColoreOrdine,
							CASE 
								WHEN CHARINDEX(CHAR(13), VstOdlDet.Descrizione) > 0
									THEN SUBSTRING(VstOdlDet.Descrizione, 0, CHARINDEX(CHAR(13), VstOdlDet.Descrizione))
								ELSE VstOdlDet.Descrizione
								END AS DescrizioneElab,
							VstCliOrdDet.DescMateriale,
							VstOdlDet.CostoLavEstP,
							VstOdlDet.CostoLavEstD,
							VstOdlDet.CostoPrvMateriali,
							VstOdlDet.CostoOdlMateriali,
							VstOdlDet.CostoPrvLavEstP,
							VstOdlDet.CostoOdlLavEstP,
							VstOdlDet.CostoPrvTotP,
							VstOdlDet.CostoOdlTotP,
							VstOdlDet.CostoPrvLavInt,
							VstOdlDet.CostoOdlLavInt,
							VstOdlDet.CostoPrvLavEstD,
							VstOdlDet.CostoOdlLavEstD,
							VstOdlDet.CostoPrvTotL,
							VstOdlDet.CostoOdlTotL,
							VstOdlDet.CostoPrvTot,
							VstOdlDet.CostoOdlTot,
							dbo.FncOreMin(VstOdlDet.DurataPrvTot / 60) AS DurataPrvTotFnc,
							dbo.FncOreMin(VstOdlDet.DurataOdlTot / 60) AS DurataOdlTotFnc,
							dbo.FncOreMin(VstOdlDet.DurataTot / 60) AS DurataTotFnc,
							VstOdlDet.CostoPrvAgnt,
							VstOdlDet.CostoOdlAgnt,
							VstOdlDet.CostoTotP,
							VstOdlDet.CostoLavInt,
							VstOdlDet.CostoTotL,
							VstOdlDet.PrezzoMateriale,
							VstOdlDet.PrezzoLavEstP,
							VstOdlDet.PrezzoTotP,
							VstOdlDet.PrezzoLavUnit,
							VstOdlDet.PrezzoTotL,
							VstOdlDet.PrezzoLavEstD,
							VstOdlDet.DurataPrvTotProd,
							VstOdlDet.DurataOdlTotProd,
							VstOdlDet.DurataTotProd,
							VstOdlDet.DurataPrvTotProdD,
							VstOdlDet.DurataOdlTotProdD,
							VstOdlDet.DurataTotProdD,
							VstOdlDet.PrezzoCliPrvTot,
							VstOdlDet.RicaricoCostoTot,
							VstOdlDet.RicaricoCostoPercTot,
							VstOdlDet.RicaricoPrezzoTot,
							VstOdlDet.RicaricoPrezzoPercTot,
							VstOdlDet.NoteConsuntivo,
							CASE 
								WHEN VstCliOrdDet.FlgPrezzoIpotetico = 1
									THEN 'A Consuntivo'
								ELSE NULL
								END AS PrezzoIpotetico,
							CASE 
								WHEN VstCliOrdDet.FlgPrezzoIpotetico = 1
									THEN '#ff7f50'
								ELSE NULL
								END AS ColorePrezzoIpotetico,
							ISNULL(VstOdlDet.PrezzoMaterialiUnit, 0) - ISNULL(VstOdlDet.CostoMaterialiUnit, 0) AS RegiaConsMat,
							ISNULL(VstOdlDet.PrezzoLavEstUnitP, 0) - ISNULL(VstOdlDet.CostoLavEstUnitP, 0) AS RegiaConsEst,
							ISNULL(VstOdlDet.PrezzoAgntUnit, 0) - ISNULL(VstOdlDet.CostoAgntUnit, 0) AS RegiaConsAgnt,
							ISNULL(VstOdlDet.PrezzoLavIntUnit, 0) - ISNULL(VstOdlDet.CostoLavIntUnit, 0) AS RegiaConsLavInt,
							drvPrv.MarginePrezzoProposto,
							drvDdtClienteMax.DataCliDdt,
							ISNULL(PrezzoLavEstUnitD, 0) - ISNULL(CostoLavEstUnitD, 0) AS DeltaDec
						FROM VstOdlDet
						LEFT OUTER JOIN VstCliOrdDet
							ON VstCliOrdDet.IdCliOrdDet = VstOdlDet.IdCliOrdDet
						LEFT OUTER JOIN VstArtImg
							ON VstArtImg.IdArticolo = VstOdlDet.IdArticolo
						INNER JOIN TbArticoli
							ON VstOdlDet.IdArticolo = TbArticoli.IdArticolo
						LEFT OUTER JOIN (
							SELECT DrvDdiClienti.IdOdlDet,
								TbCliDdt.DataCliDdt
							FROM (
								SELECT IdOdlDet,
									MAX(IdCliDdtDet) AS IdCliDdtDet
								FROM VstCliDdtDet
								WHERE (FlgPrebolla = 0)
								GROUP BY IdOdlDet
								) AS DrvDdiClienti
							INNER JOIN TbCliDdtDet
								ON DrvDdiClienti.IdCliDdtDet = TbCliDdtDet.IdCliDdtDet
							INNER JOIN TbCliDdt
								ON TbCliDdtDet.IdCliDdt = TbCliDdt.IdCliDdt
							) AS drvDdtClienteMax
							ON VstOdlDet.IdOdlDet = drvDdtClienteMax.IdOdlDet
						LEFT OUTER JOIN (
							SELECT MarginePrezzoProposto,
								IdCliPrv
							FROM VstCliPrv
							) AS drvPrv
							ON VstOdlDet.IdCliPrv = drvPrv.IdCliPrv
						LEFT OUTER JOIN TbArtAnagMateriali
							ON TbArticoli.IdMateriale = TbArtAnagMateriali.IdMateriale
						LEFT OUTER JOIN TbClienti
							ON VstOdlDet.IdCliente = TbClienti.IdCliente
						WHERE (VstOdlDet.IdOdlDet = @IdOdlDet)
						) drv
					FOR JSON auto
					)
		END

		--------------------------------------------
		-- Calcola dataset CostAgg
		--------------------------------------------
		DECLARE @JsonReport_CostAgg AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_CostAgg'
			OR @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' CostoAgg'
			SET @JsonReport_CostAgg = (
					-- Incapsula il select altrimenti JSON AUTO crea un nodo per ogni namespace
					SELECT *
					FROM (
						SELECT [IdOdlDetCostoAgnt],
							[IdOdlDet],
							[IdForOrdDet],
							[NRiga],
							[DescCosto],
							[IdCausaleCosto],
							[CostoUnit],
							[Qta],
							[UnitM],
							[CostoTot],
							[NoteOdlDetCostoAgnt],
							[Sem1],
							[Sem2],
							[Sem3],
							[Sem4],
							[SysDateCreate],
							[SysUserCreate],
							[SysDateUpdate],
							[SysUserUpdate],
							[IdArticolo],
							[MargineCostoAgnt],
							[PrezzoAgntProd],
							[CostoAgntProd],
							[PrezzoAgntProdUnit],
							[CostoAgntProdUnit],
							[PrezzoAgntExtra],
							[CostoAgntExtra],
							[DataCosto],
							[CodFnzTipoCosto],
							[CmpOpz01],
							[CmpOpz02],
							[CmpOpz03],
							[CmpOpz04],
							[CmpOpz05]
						FROM VstOdlDetCostiAgnt
						WHERE IdOdlDet = @IdOdlDet
						) drv
					FOR JSON auto
					)
		END

		--------------------------------------------
		-- Calcola dataset DIST
		--------------------------------------------
		DECLARE @JsonReport_Dist AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_Dist'
			OR @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' Dist'
			SET @JsonReport_Dist = (
					-- Incapsula il select altrimenti JSON AUTO crea un nodo per ogni namespace
					SELECT *
					FROM (
						SELECT @IdOdlDet AS IdOdlDet,
							FncOdlDetCostiDist_1.CostoTotDoc / FncOdlDetCostiDist_1.QtaOdlDet AS CostoTotDoc,
							CASE 
								WHEN CHARINDEX(CHAR(13), FncOdlDetCostiDist_1.DescCompleta) > 0
									THEN SUBSTRING(FncOdlDetCostiDist_1.DescCompleta, 0, CHARINDEX(CHAR(13), FncOdlDetCostiDist_1.DescCompleta))
								ELSE FncOdlDetCostiDist_1.DescCompleta
								END AS DescCompletaElab,
							FncOdlDetCostiDist_1.CmpOpz04 AS QtaPzPrv,
							CONVERT(MONEY, FncOdlDetCostiDist_1.CmpOpz02) AS CostoUnitPrv,
							CONVERT(MONEY, FncOdlDetCostiDist_1.CmpOpz03) AS CostoTotPrv,
							CONVERT(MONEY, FncOdlDetCostiDist_1.CmpOpz01) AS CostoPzPrv,
							FncOdlDetCostiDist_1.DataDdt,
							FncOdlDetCostiDist_1.IdArticoloCliPrv,
							FncOdlDetCostiDist_1.SviluppoS,
							FncOdlDetCostiDist_1.SviluppoH,
							FncOdlDetCostiDist_1.SviluppoL,
							FncOdlDetCostiDist_1.DescMateriale,
							FncOdlDetCostiDist_1.QtaTot,
							FncOdlDetCostiDist_1.CostoUnitForDocDist,
							FncOdlDetCostiDist_1.CostoForOrdDistProdUnit,
							FncOdlDetCostiDist_1.CostoForDocDistProd,
							FncOdlDetCostiDist_1.IdArticolo,
							FncOdlDetCostiDist_1.NRiga,
							FncOdlDetCostiDist_1.DescDoc
						FROM dbo.FncOdlDetCostiDist(NULL, @IdOdlDet, NULL) AS FncOdlDetCostiDist_1
						INNER JOIN VstOdlDet
							ON FncOdlDetCostiDist_1.IdOdlDet = VstOdlDet.IdOdlDet
						) drv
					FOR JSON auto
					)
		END

		--------------------------------------------
		-- Calcola dataset Fasi
		--------------------------------------------
		DECLARE @JsonReport_Fasi AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_Fasi'
			OR @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' Fasi'
			SET @JsonReport_Fasi = (
					-- Incapsula il select altrimenti JSON AUTO crea un nodo per ogni namespace
					SELECT *
					FROM (
						SELECT IdOdlDet,
							IdCdl,
							ISNULL(IdOdlDetFase, - 1) AS IdOdlDetFase,
							Descfase,
							NFase,
							CostoCliPrv,
							dbo.FncOreMin(DurataCliPrv) AS DurataCliPrv,
							CostoPrev,
							dbo.FncOreMin(DurataPrev) AS DurataPrev,
							dbo.FncOreMin(DurataTot) AS DurataTot,
							CostoTot,
							KeyFaseRegTmp,
							DurataUnit,
							CostoUnit,
							DurataProd,
							LEFT(NoteFase, 150) AS NoteFase,
							DurataCiclo,
							NumOprzProgrm,
							NumUtensiliProgrm,
							SUBSTRING(KeyFaseRegTmp, 0, CHARINDEX('#', KeyFaseRegTmp, 0)) AS Tipo,
							CASE 
								WHEN CHARINDEX(CHAR(13), NoteFase) > 0
									THEN ISNULL(SUBSTRING(NoteFase, 0, CHARINDEX(CHAR(13), NoteFase)), '')
								ELSE isnull(LEFT(NoteFase, 40), '')
								END AS Note,
							CASE 
								WHEN FlgFaseDecentrata = 1
									THEN 'Decentramento'
								ELSE ''
								END AS NoteDec,
							CostoTotCons,
							StatoDoc,
							CASE 
								WHEN StatoDoc = 'ORD'
									THEN '#FF4500'
								WHEN StatoDoc = 'RCV'
									THEN '#FFA500'
								WHEN StatoDoc = 'FAT'
									THEN '#ADFF2F'
								WHEN SUBSTRING(KeyFaseRegTmp, 0, CHARINDEX('#', KeyFaseRegTmp, 0)) = 'CLIPRV'
									THEN '#F0E68C'
								ELSE '#D3D3D3'
								END AS ColRiga
						FROM dbo.FncOdlDetCostiFasi(NULL, @IdOdlDet, NULL) AS FncOdlDetCostiFasi_1
						) drv
					FOR JSON auto
					)
		END

		--------------------------------------------
		-- Calcola dataset OrdFor
		--------------------------------------------
		DECLARE @JsonReport_OrdFor AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_OrdFor'
			OR @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' OrdFor'
			SET @JsonReport_OrdFor = (
					-- Incapsula il select altrimenti JSON AUTO crea un nodo per ogni namespace
					SELECT *
					FROM (
						SELECT VstOdlDetForOrdDet.IdOdlDet,
							VstOdlDetForOrdDet.RagSoc,
							VstOdlDetForOrdDet.DocTipo,
							VstOdlDetForOrdDet.TipoMov,
							VstOdlDetForOrdDet.IdArticolo,
							VstOdlDetForOrdDet.UnitM,
							VstOdlDetForOrdDet.QtaRicevuta,
							VstOdlDetForOrdDet.CostoTotOrd,
							VstOdlDetForOrdDet.CostoTotFat,
							VstOdlDetForOrdDet.QtaOrd,
							VstOdlDetForOrdDet.QtaFat,
							VstOdlDetForOrdDet.QtaRcv,
							VstOdlDetForOrdDet.ColRiga,
							VstOdlDetForOrdDet.CostoOrd,
							VstOdlDetForOrdDet.CostoFat,
							VstOdlDetForOrdDet.IdForOrd,
							VstOdlDetForOrdDet.QtaRda,
							VstOdlDetForOrdDet.CostoTotRcv,
							VstOdlDetForOrdDet.Descrizione,
							VstOdlDetForOrdDet.DimLarghezza,
							VstOdlDetForOrdDet.DimAltezza,
							VstOdlDetForOrdDet.DimLunghezza,
							VstOdlDetForOrdDet.DescMateriale,
							VstOdlDetForOrdDet.CostoTotDoc,
							VstOdlDetForOrdDet.ForRcvDdtDataReg,
							drvForRcv.DataCarico
						FROM VstOdlDetForOrdDet
						LEFT OUTER JOIN (
							SELECT MAX(DataCarico) AS DataCarico,
								IdForOrdDet
							FROM VstForRcvDdtDet
							GROUP BY IdForOrdDet
							) AS drvForRcv
							ON VstOdlDetForOrdDet.IdForOrdDet = drvForRcv.IdForOrdDet
						WHERE (VstOdlDetForOrdDet.IdOdlDet = @IdOdlDet)
							AND (NOT (VstOdlDetForOrdDet.IdForOrd IS NULL))
						) drv
					FOR JSON auto
					)
		END

		--------------------------------------------
		-- Calcola dataset RegTmp
		--------------------------------------------
		DECLARE @JsonReport_RegTmp AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_RegTmp'
			OR @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' RegTmp'
			SET @JsonReport_RegTmp = (
					-- Incapsula il select altrimenti JSON AUTO crea un nodo per ogni namespace
					SELECT *
					FROM (
						SELECT NULL AS Dent,
							IdOdlDet,
							IdCdl,
							ISNULL(IdOdlDetFase, - 1) AS IdOdlDetFase,
							Descfase,
							NFase,
							CostoCliPrv,
							DurataCliPrv,
							CostoCliPrv AS CostoPrev,
							DurataCliPrv * 60 AS DurataPrev,
							(DurataTot) AS DurataTot,
							CostoTot,
							KeyFaseRegTmp,
							LEFT(NoteFase, 150) AS NoteFase,
							CASE 
								WHEN CHARINDEX(CHAR(13), NoteFase) > 0
									THEN ISNULL(SUBSTRING(NoteFase, 0, CHARINDEX(CHAR(13), NoteFase)), '')
								ELSE isnull(LEFT(NoteFase, 40), '')
								END AS Note,
							CASE 
								WHEN FlgFaseDecentrata = 1
									THEN 'Decentramento'
								ELSE ''
								END AS NoteDec,
							CostoTotCons,
							CASE 
								WHEN StatoDoc = 'ORD'
									THEN '#FF4500'
								WHEN StatoDoc = 'RCV'
									THEN '#FFA500'
								WHEN StatoDoc = 'FAT'
									THEN '#ADFF2F'
								WHEN SUBSTRING(KeyFaseRegTmp, 0, CHARINDEX('#', KeyFaseRegTmp, 0)) = 'CLIPRV'
									THEN '#F0E68C'
								ELSE '#D3D3D3'
								END AS ColRiga,
							0 AS Tipo,
							NULL AS DataReg,
							NULL AS CognomeNome,
							'OFF' AS LabelOFF,
							'Costo OFF' AS LabelCostoOff,
							'CONS' AS LabelCosn,
							'Costo Cons.' AS LabelCostoCons,
							NFase AS NFaseElab,
							NULL AS IdForOrd,
							NULL AS RagSoc,
							NULL AS QtaOrd,
							NULL AS CostoOrd,
							NULL AS ForRcvDdtDataReg,
							NULL AS DataConsegna,
							NULL AS DataForDdt
						FROM dbo.FncOdlDetCostiFasi(GETDATE(), @IdOdlDet, NULL) AS FncOdlDetCostiFasi_1
						
						UNION ALL
						
						SELECT '-- ' AS Dent,
							IdOdlDet,
							IdCdl,
							IdOdlDetFase,
							NULL,
							NFase,
							NULL AS CostoCliPrv,
							NULL AS DurataCliPrv,
							NULL AS CostoPrev,
							NULL AS DurataPrev,
							(x.DurataMinuti) AS DurataFnc,
							x.Costo,
							NULL AS KeyFaseRegTmp,
							NULL AS notefase,
							NULL AS note,
							NULL AS NoteDec,
							x.costo,
							NULL AS ColRiga,
							1 AS Tipo,
							DataReg,
							CognomeNome,
							NULL AS LabelOFF,
							NULL AS LabelCostoOff,
							NULL AS LabelCosn,
							NULL AS LabelCostoCons,
							NULL AS NFaseElab,
							NULL AS IdForOrd,
							NULL AS RagSoc,
							NULL AS QtaOrd,
							NULL AS CostoOrd,
							NULL AS ForRcvDdtDataReg,
							NULL AS DataConsegna,
							NULL AS DataForDdt
						FROM (
							SELECT IdCdl,
								DataReg,
								CostoUnit,
								ROUND(SUM(Costo), 2) AS Costo,
								CognomeNome,
								SUM(DurataMinuti * 60) AS DurataMinuti,
								IdOdlDet,
								IdOdlDetFase,
								NFase
							FROM VstOdlDetRegTmp
							WHERE (IdOdlDet = @IdOdlDet)
								AND (IdCdl NOT IN ('Z.110.0', 'Z.521.0', 'Z.520.0', 'Z.610.0'))
							GROUP BY IdCdl,
								DataReg,
								CostoUnit,
								CognomeNome,
								IdOdlDet,
								IdOdlDetFase,
								NFase
							) AS x
						
						UNION ALL
						
						SELECT '-- ' AS Dent,
							IdOdlDet,
							IdCdl,
							IdOdlDetFase,
							NULL,
							NFase,
							NULL AS CostoCliPrv,
							NULL AS DurataCliPrv,
							NULL AS CostoPrev,
							NULL AS DurataPrev,
							(x.DurataMinuti) AS DurataFnc,
							x.Costo,
							NULL AS KeyFaseRegTmp,
							NULL AS notefase,
							NULL AS note,
							NULL AS NoteDec,
							x.costo,
							'#ffe4c4' AS ColRiga,
							4 AS Tipo,
							DataReg,
							CognomeNome,
							NULL AS LabelOFF,
							NULL AS LabelCostoOff,
							NULL AS LabelCosn,
							NULL AS LabelCostoCons,
							NULL AS NFaseElab,
							NULL AS IdForOrd,
							NULL AS RagSoc,
							NULL AS QtaOrd,
							NULL AS CostoOrd,
							NULL AS ForRcvDdtDataReg,
							NULL AS DataConsegna,
							NULL AS DataForDdt
						FROM (
							SELECT IdCdl,
								DataReg,
								CostoUnit,
								ROUND(SUM(Costo), 2) AS Costo,
								CognomeNome,
								SUM(DurataMinuti * 60) AS DurataMinuti,
								IdOdlDet,
								IdOdlDetFase,
								NFase
							FROM VstOdlDetRegTmp
							WHERE (IdOdlDet = @IdOdlDet)
								AND (IdCdl IN ('Z.110.0', 'Z.521.0', 'Z.520.0', 'Z.610.0'))
							GROUP BY IdCdl,
								DataReg,
								CostoUnit,
								CognomeNome,
								IdOdlDet,
								IdOdlDetFase,
								NFase
							) AS x
						
						UNION ALL
						
						SELECT drvdec.Dent,
							drvdec.IdOdlDet,
							TbOdlDetFasi.IdCdl,
							drvdec.IdOdlDetFase,
							drvdec.Descrizione,
							TbOdlDetFasi.NFase,
							drvdec.CostoCliPrv,
							drvdec.DurataCliPrv,
							drvdec.CostoPrev,
							drvdec.DurataPrev,
							drvdec.DurataTot,
							drvdec.CostoTot,
							drvdec.KeyFaseRegTmp,
							drvdec.notefase,
							drvdec.note,
							drvdec.NoteDec,
							drvdec.Expr1,
							drvdec.ColRiga,
							drvdec.Tipo,
							drvdec.Data,
							drvdec.CognomeNome,
							drvdec.LabelOFF,
							drvdec.LabelCostoOff,
							drvdec.LabelCosn,
							drvdec.LabelCostoCons,
							drvdec.NFaseElab,
							drvdec.IdForOrd,
							drvdec.RagSoc,
							drvdec.QtaOrd,
							drvdec.CostoOrd,
							drvdec.ForRcvDdtDataReg,
							drvdec.DataConsegna,
							drvdec.DataForDdt
						FROM (
							SELECT NULL AS Dent,
								VstOdlDetForOrdDet.IdOdlDet,
								NULL AS IdCdl,
								SUBSTRING(VstOdlDetForOrdDet.DocKeyDet, CHARINDEX('#', VstOdlDetForOrdDet.DocKeyDet) + 1, 999) AS IdOdlDetFase,
								VstOdlDetForOrdDet.Descrizione,
								NULL AS NFase,
								NULL AS CostoCliPrv,
								NULL AS DurataCliPrv,
								NULL AS CostoPrev,
								NULL AS DurataPrev,
								NULL AS DurataTot,
								VstOdlDetForOrdDet.CostoTotOrd AS CostoTot,
								NULL AS KeyFaseRegTmp,
								VstOdlDetForOrdDet.Descrizione AS notefase,
								NULL AS note,
								NULL AS NoteDec,
								VstOdlDetForOrdDet.CostoTotOrd / VstOdlDetForOrdDet.QtaOrd AS Expr1,
								'#e4eefa' AS ColRiga,
								3 AS Tipo,
								NULL AS Data,
								NULL AS CognomeNome,
								NULL AS LabelOFF,
								NULL AS LabelCostoOff,
								NULL AS LabelCosn,
								NULL AS LabelCostoCons,
								NULL AS NFaseElab,
								VstOdlDetForOrdDet.IdForOrd,
								VstOdlDetForOrdDet.RagSoc,
								VstOdlDetForOrdDet.QtaOrd,
								VstOdlDetForOrdDet.CostoOrd,
								drvDataCarico.DataCarico AS ForRcvDdtDataReg,
								VstOdlDetForOrdDet.DataConsegna,
								drvDataDdtFor.DataForDdt
							FROM VstOdlDetForOrdDet
							LEFT OUTER JOIN (
								SELECT IdForOrdDet,
									MAX(DataCarico) AS DataCarico
								FROM VstForRcvDdtDet
								GROUP BY IdForOrdDet
								) AS drvDataCarico
								ON VstOdlDetForOrdDet.IdForOrdDet = drvDataCarico.IdForOrdDet
							LEFT OUTER JOIN (
								SELECT TbForDdtDet.IdForOrdDet,
									MAX(TbForDdt.DataForDdt) AS DataForDdt
								FROM TbForDdtDet
								INNER JOIN TbForDdt
									ON TbForDdtDet.IdForDdt = TbForDdt.IdForDdt
								GROUP BY TbForDdtDet.IdForOrdDet
								) AS drvDataDdtFor
								ON VstOdlDetForOrdDet.IdForOrdDet = drvDataDdtFor.IdForOrdDet
							WHERE (VstOdlDetForOrdDet.IdOdlDet = @IdOdlDet)
								AND (VstOdlDetForOrdDet.TipoMov = 'FASE')
							) AS drvdec
						INNER JOIN TbOdlDetFasi
							ON drvdec.IdOdlDetFase = TbOdlDetFasi.IdOdlDetFase
						INNER JOIN TbProdCdl
							ON TbOdlDetFasi.IdCdl = TbProdCdl.IdCdl
								--WHERE  (TbProdCdl.FlgCdlExt = 0)
						) drvRegTmp
					FOR JSON auto
					)
		END

		--------------------------------------------
		-- Calcola dataset Tot
		--------------------------------------------
		DECLARE @JsonReport_Tot AS NVARCHAR(max)

		IF @DataSet = 'Consuntivo_Tot'
			OR @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' Tot'
			SET @JsonReport_Tot = (
					-- Incapsula il select altrimenti JSON AUTO crea un nodo per ogni namespace
					SELECT *
					FROM (
						SELECT @IdOdlDet AS IdOdlDet,
							CostoCliPrv,
							dbo.FncOreMin(DurataCliPrv) AS DurataCliPrv,
							CostoPrev,
							dbo.FncOreMin(DurataPrev) AS DurataPrev,
							CostoTot,
							dbo.FncOreMin(DurataTot) AS DurataTot,
							CostoTotCons,
							dbo.FncOreMin(DurataTotDecentramento) AS DurataTotDecentramento
						FROM (
							SELECT SUM(CostoCliPrv) AS CostoCliPrv,
								SUM(DurataCliPrv) AS DurataCliPrv,
								SUM(CostoPrev) AS CostoPrev,
								SUM(DurataPrev) AS DurataPrev,
								SUM(CostoTot) AS CostoTot,
								SUM(DurataTot) AS DurataTot,
								SUM(CostoTotCons) AS CostoTotCons,
								SUM(DurataTotDecentramento) AS DurataTotDecentramento
							FROM [dbo].[FncOdlDetCostiFasi](getdate(), @IdOdlDet, NULL)
							) drv
						) AS DrvTot
					FOR JSON auto
					)
		END

		--------------------------------------------
		-- Calcola JSON complessivo
		--------------------------------------------
		-- Se elaborazione richeista storicizza
		IF @FlgElab = 1
		BEGIN
			SET @InfoElab = @InfoElab + ' -Update'
			-- Se non ci sono record ne precarica 1 uno -1
			SET @JsonReport_Chk = ISNULL(@JsonReport_Chk, '[{"IdOdlDet":-1}]')
			SET @JsonReport_00 = ISNULL(@JsonReport_00, '[{"IdOdlDet":-1}]')
			SET @JsonReport_CostAgg = ISNULL(@JsonReport_CostAgg, '[{"IdOdlDet":-1}]')
			SET @JsonReport_Dist = ISNULL(@JsonReport_Dist, '[{"IdOdlDet":-1}]')
			SET @JsonReport_Fasi = ISNULL(@JsonReport_Fasi, '[{"IdOdlDet":-1}]')
			SET @JsonReport_OrdFor = ISNULL(@JsonReport_OrdFor, '[{"IdOdlDet":-1}]')
			SET @JsonReport_RegTmp = ISNULL(@JsonReport_RegTmp, '[{"IdOdlDet":-1}]')
			SET @JsonReport_Tot = ISNULL(@JsonReport_Tot, '[{"IdOdlDet":-1}]')
			-- Crea un unico json
			SET @JsonReport = '{
                                "Consuntivo_Chk":' + @JsonReport_Chk + ',
                                "Consuntivo_00":' + @JsonReport_00 + ',
                                "Consuntivo_CostAgg":' + @JsonReport_CostAgg + ',
                                "Consuntivo_Dist":' + @JsonReport_Dist + ',
                                "Consuntivo_Fasi":' + @JsonReport_Fasi + ',
                                "Consuntivo_OrdFor":' + @JsonReport_OrdFor + ',
                                "Consuntivo_RegTmp":' + @JsonReport_RegTmp + ',
                                "Consuntivo_Tot":' + @JsonReport_Tot + '
                                }'

			-- Memorizza
			UPDATE TbOdlDetElab
			SET JsonReport = @JsonReport
			WHERE IdOdlDet = @IdOdldet
		END
	END
	ELSE
	BEGIN
		SET @InfoElab = 'Carica JSON'
	END

	--------------------------------------------
	-- Cerca il nodo richiesto
	--------------------------------------------
	SELECT @JsonReport = root.VALUE
	FROM OPENJSON(@JsonReport) AS root
	WHERE root.[key] = @DataSet

	--------------------------------------------
	-- Restituisce JSON dataset 'Consuntivo_00'
	--------------------------------------------
	IF @DataSet = 'Consuntivo_00'
	BEGIN
		-- Se non trova il record lo precarica dal Json elaborato, questo per restituire dati anche se non ancora elaborati
		IF @JsonReport IS NULL
			SET @JsonReport = @JsonReport_00

		SELECT *
		FROM OPENJSON(@JsonReport) WITH (
				[IdOdl] [nvarchar](20),
				[NRiga] [int],
				[IdOdlDet] [int],
				[RagSoc] [nvarchar](300),
				[IdArticolo] [nvarchar](50),
				[Qta] [real],
				[UnitM] [nvarchar](20),
				[Descrizione] [nvarchar](max),
				[IdCliOrd] [nvarchar](20),
				[DataConsegna] [date],
				[RevisioneIdArt] [nvarchar](10),
				[NoteOdlDet] [nvarchar](max),
				[BCOdlDet] [nvarchar](300),
				[IdReparto] [nvarchar](20),
				[Immagine] [varbinary](max),
				[NPezziScatola] [real],
				[NScatoleBancale] [real],
				[StampoNImpronte] [int],
				[QtaCiclo] [real],
				[NScatole] [float],
				[NGiorni] [float],
				[NScatoleGiorno] [float],
				[IdImballo] [nvarchar](20),
				[DescImballo] [nvarchar](200),
				[IdCliPrj] [nvarchar](20),
				[DimAltezza] [real],
				[DimLunghezza] [real],
				[DimLarghezza] [real],
				[IdMateriale] [nvarchar](50),
				[IdCliOff] [nvarchar](20),
				[DataRifCliOrd] [date],
				[DescRifCliOrd] [nvarchar](200),
				[IdArtDist] [int],
				[IdArtCiclo] [int],
				[IdCategoria] [nvarchar](20),
				[CicloVer] [nvarchar](10),
				[DistVer] [nvarchar](10),
				[Acronimo] [nvarchar](50),
				[Disegno] [nvarchar](50),
				[GruppoMateriale] [nvarchar](20),
				[ColoreQta] [varchar](7),
				[CostoOdlTotUnit] [money],
				[ColQtaProdotta] [nvarchar](7),
				[ColQta] [nvarchar](7),
				[RicaricoCostoPerc] [decimal](18, 8),
				[RicaricoPrezzoPerc] [decimal](18, 8),
				[RicaricoCosto] [money],
				[RicaricoPrezzo] [money],
				[ColQtaDdt] [nvarchar](7),
				[QtaDdt] [decimal](18, 8),
				[PrezzoCliPrvUnit] [money],
				[DescCompleta] [nvarchar](1001),
				[ColLavEstUnit] [nvarchar](7),
				[ColLavEstUnitD] [nvarchar](7),
				[ColLavEstUnitP] [nvarchar](7),
				[ColLavIntUnit] [nvarchar](7),
				[ColCostoAgntUnit] [nvarchar](7),
				[ColMaterialiUnit] [nvarchar](7),
				[PrezzoOffTot] [money],
				[PrezzoFatTot] [money],
				[PrezzoPropostoTot] [money],
				[PrezzoTot] [money],
				[DurataPrvTot] [decimal](18, 2),
				[CostoLavEstUnitP] [money],
				[PrezzoLavEstUnitD] [money],
				[PrezzoTotUnitL] [money],
				[PrezzoTotUnitP] [money],
				[PrezzoLavEstUnitP] [money],
				[CostoOdlAgntUnit] [money],
				[CostoOdlLavEstUnit] [money],
				[CostoOdlLavIntUnit] [money],
				[CostoOdlMaterialiUnit] [money],
				[CostoPrvLavEstUnitP] [money],
				[CostoOdlLavEstUnitP] [money],
				[CostoOdlLavEstUnitD] [money],
				[CostoPrvLavEstUnitD] [money],
				[CostoLavEstUnitD] [money],
				[DurataOdlTot] [decimal](18, 2),
				[DurataTot] [decimal](18, 2),
				[DurataPrvTotD] [decimal](18, 2),
				[DurataOdlTotD] [decimal](18, 2),
				[DurataTotD] [decimal](18, 2),
				[CostoOdlTotUnitP] [money],
				[CostoPrvTotUnitP] [money],
				[CostoTotUnitP] [money],
				[CostoOdlTotUnitL] [money],
				[CostoPrvTotUnitL] [money],
				[CostoTotUnitL] [money],
				[CostoPrvLavIntUnit] [money],
				[CostoPrvLavEstUnit] [money],
				[CostoPrvAgntUnit] [money],
				[CostoPrvMaterialiUnit] [money],
				[CostoPrvTotUnit] [money],
				[PrezzoPrvLavIntUnit] [money],
				[PrezzoPrvLavEstUnit] [money],
				[PrezzoPrvAgntUnit] [money],
				[PrezzoPrvMaterialiUnit] [money],
				[PrezzoOff] [money],
				[PrezzoPrv] [money],
				[IdCliPrv] [nvarchar](20),
				[DataElab] [datetime],
				[MarginePrezzo] [money],
				[PrezzoFat] [money],
				[MarginePrezzoFat] [money],
				[MargineFat] [real],
				[MargineMateriali] [real],
				[MargineLavorazioni] [real],
				[MargineCostiAgnt] [real],
				[CostoUnit] [money],
				[QtaProdotta] [real],
				[CostoMateriali] [money],
				[CostoLavEst] [money],
				[CostoAgnt] [money],
				[CostoLavIntUnit] [money],
				[CostoLavEstUnit] [money],
				[CostoAgntUnit] [money],
				[CostoMaterialiUnit] [money],
				[CostoMaterialiExtra] [money],
				[CostoLavIntExtra] [money],
				[CostoLavEstExtra] [money],
				[PrezzoMateriali] [money],
				[CostoAgntExtra] [money],
				[PrezzoLavInt] [money],
				[CostoTotExtra] [money],
				[CostoTotUnit] [money],
				[CostoTot] [money],
				[PrezzoProposto] [money],
				[PrezzoAgntExtra] [money],
				[PrezzoLavEstExtra] [money],
				[PrezzoLavIntExtra] [money],
				[PrezzoMaterialiExtra] [money],
				[PrezzoMaterialiUnit] [money],
				[PrezzoAgntUnit] [money],
				[PrezzoLavEstUnit] [money],
				[PrezzoLavIntUnit] [money],
				[PrezzoAgnt] [money],
				[PrezzoLavEst] [money],
				[MargineLavorazioniExt] [real],
				[Margine] [real],
				[MargineProposto] [real],
				[Prezzo] [money],
				[NoteElab] [nvarchar](max),
				[ColElab] [nvarchar](7),
				[StatoElab] [nvarchar](5),
				[ColoreOrdine] [varchar](7),
				[DescrizioneElab] [nvarchar](max),
				[DescMateriale] [nvarchar](200),
				[CostoLavEstP] [money],
				[CostoLavEstD] [money],
				[CostoPrvMateriali] [real],
				[CostoOdlMateriali] [real],
				[CostoPrvLavEstP] [real],
				[CostoOdlLavEstP] [real],
				[CostoPrvTotP] [real],
				[CostoOdlTotP] [real],
				[CostoPrvLavInt] [real],
				[CostoOdlLavInt] [real],
				[CostoPrvLavEstD] [real],
				[CostoOdlLavEstD] [real],
				[CostoPrvTotL] [real],
				[CostoOdlTotL] [real],
				[CostoPrvTot] [real],
				[CostoOdlTot] [real],
				[DurataPrvTotFnc] [nvarchar](10),
				[DurataOdlTotFnc] [nvarchar](10),
				[DurataTotFnc] [nvarchar](10),
				[CostoPrvAgnt] [real],
				[CostoOdlAgnt] [real],
				[CostoTotP] [real],
				[CostoLavInt] [money],
				[CostoTotL] [real],
				[PrezzoMateriale] [real],
				[PrezzoLavEstP] [real],
				[PrezzoTotP] [real],
				[PrezzoLavUnit] [real],
				[PrezzoTotL] [real],
				[PrezzoLavEstD] [real],
				[DurataPrvTotProd] [real],
				[DurataOdlTotProd] [real],
				[DurataTotProd] [real],
				[DurataPrvTotProdD] [real],
				[DurataOdlTotProdD] [real],
				[DurataTotProdD] [real],
				[PrezzoCliPrvTot] [real],
				[RicaricoCostoTot] [money],
				[RicaricoCostoPercTot] [decimal](18, 8),
				[RicaricoPrezzoTot] [money],
				[RicaricoPrezzoPercTot] [decimal](18, 8),
				[NoteConsuntivo] [nvarchar](max),
				[PrezzoIpotetico] [varchar](12),
				[ColorePrezzoIpotetico] [varchar](7),
				[RegiaConsMat] [money],
				[RegiaConsEst] [money],
				[RegiaConsAgnt] [money],
				[RegiaConsLavInt] [money],
				[MarginePrezzoProposto] [money],
				[DataCliDdt] [date],
				[DeltaDec] [money]
				) AS DataReport
		WHERE IdOdlDet <> - 1
	END
			--------------------------------------------
			-- Restituisce JSON dataset 'Consuntivo_CostAgg'
			--------------------------------------------
	ELSE IF @DataSet = 'Consuntivo_CostAgg'
	BEGIN
		-- Se non trova il record lo precarica dal Json elaborato, questo per restituire dati anche se non ancora elaborati
		IF @JsonReport IS NULL
			SET @JsonReport = @JsonReport_CostAgg

		SELECT *
		FROM OPENJSON(@JsonReport) WITH (
				[IdOdlDetCostoAgnt] [int],
				[IdOdlDet] [int],
				[IdForOrdDet] [int],
				[NRiga] [int],
				[DescCosto] [nvarchar](max),
				[IdCausaleCosto] [nvarchar](20),
				[CostoUnit] [money],
				[Qta] [real],
				[UnitM] [nvarchar](20),
				[CostoTot] [real],
				[NoteOdlDetCostoAgnt] [nvarchar](max),
				[Sem1] [smallint],
				[Sem2] [smallint],
				[Sem3] [smallint],
				[Sem4] [smallint],
				[SysDateCreate] [datetime],
				[SysUserCreate] [nvarchar](256),
				[SysDateUpdate] [datetime],
				[SysUserUpdate] [nvarchar](256),
				[SysRowVersion] [timestamp],
				[IdArticolo] [nvarchar](50),
				[MargineCostoAgnt] [real],
				[PrezzoAgntProd] [money],
				[CostoAgntProd] [money],
				[PrezzoAgntProdUnit] [money],
				[CostoAgntProdUnit] [money],
				[PrezzoAgntExtra] [money],
				[CostoAgntExtra] [money],
				[DataCosto] [date],
				[CodFnzTipoCosto] [nvarchar](5),
				[CmpOpz01] [nvarchar](50),
				[CmpOpz02] [nvarchar](50),
				[CmpOpz03] [nvarchar](50),
				[CmpOpz04] [nvarchar](50),
				[CmpOpz05] [nvarchar](50)
				) AS DataReport
		WHERE IdOdlDet <> - 1
	END
			--------------------------------------------
			-- Restituisce JSON dataset 'Consuntivo_Dist'
			--------------------------------------------
	ELSE IF @DataSet = 'Consuntivo_Dist'
	BEGIN
		-- Se non trova il record lo precarica dal Json elaborato, questo per restituire dati anche se non ancora elaborati
		IF @JsonReport IS NULL
			SET @JsonReport = @JsonReport_Dist

		SELECT *
		FROM OPENJSON(@JsonReport) WITH (
				[IdOdlDet] [int],
				[CostoTotDoc] [float],
				[DescCompletaElab] [nvarchar](max),
				[QtaPzPrv] [nvarchar](50),
				[CostoUnitPrv] [money],
				[CostoTotPrv] [money],
				[CostoPzPrv] [money],
				[DataDdt] [date],
				[IdArticoloCliPrv] [nvarchar](50),
				[SviluppoS] [real],
				[SviluppoH] [real],
				[SviluppoL] [real],
				[DescMateriale] [nvarchar](200),
				[QtaTot] [real],
				[CostoUnitForDocDist] [float],
				[CostoForOrdDistProdUnit] [float],
				[CostoForDocDistProd] [float],
				[IdArticolo] [nvarchar](50),
				[NRiga] [int],
				[DescDoc] [nvarchar](328)
				) AS DataReport
		WHERE IdOdlDet <> - 1
	END
			--------------------------------------------
			-- Restituisce JSON dataset 'Consuntivo_Fasi'
			--------------------------------------------
	ELSE IF @DataSet = 'Consuntivo_Fasi'
	BEGIN
		-- Se non trova il record lo precarica dal Json elaborato, questo per restituire dati anche se non ancora elaborati
		IF @JsonReport IS NULL
			SET @JsonReport = @JsonReport_Fasi

		SELECT *
		FROM OPENJSON(@JsonReport) WITH (
				[IdOdlDet] [int],
				[IdCdl] [nvarchar](20),
				[IdOdlDetFase] [int],
				[Descfase] [nvarchar](200),
				[NFase] [int],
				[CostoCliPrv] [float],
				[DurataCliPrv] [nvarchar](10),
				[CostoPrev] [money],
				[DurataPrev] [nvarchar](10),
				[DurataTot] [nvarchar](10),
				[CostoTot] [money],
				[KeyFaseRegTmp] [nvarchar](78),
				[DurataUnit] [float],
				[CostoUnit] [float],
				[DurataProd] [int],
				[NoteFase] [nvarchar](max),
				[DurataCiclo] [decimal](8, 3),
				[NumOprzProgrm] [int],
				[NumUtensiliProgrm] [int],
				[Tipo] [nvarchar](78),
				[Note] [nvarchar](max),
				[NoteDec] [varchar](13),
				[CostoTotCons] [float],
				[StatoDoc] [varchar](3),
				[ColRiga] [varchar](7)
				) AS DataReport
		WHERE IdOdlDet <> - 1
	END
			--------------------------------------------
			-- Restituisce JSON dataset 'Consuntivo_OrdFor'
			--------------------------------------------
	ELSE IF @DataSet = 'Consuntivo_OrdFor'
	BEGIN
		-- Se non trova il record lo precarica dal Json elaborato, questo per restituire dati anche se non ancora elaborati
		IF @JsonReport IS NULL
			SET @JsonReport = @JsonReport_OrdFor

		SELECT *
		FROM OPENJSON(@JsonReport) WITH (
				[IdOdlDet] [int],
				[RagSoc] [nvarchar](300),
				[DocTipo] [varchar](12),
				[TipoMov] [varchar](11),
				[IdArticolo] [nvarchar](50),
				[UnitM] [nvarchar](20),
				[QtaRicevuta] [real],
				[CostoTotOrd] [money],
				[CostoTotFat] [money],
				[QtaOrd] [real],
				[QtaFat] [float],
				[QtaRcv] [float],
				[ColRiga] [varchar](7),
				[CostoOrd] [money],
				[CostoFat] [money],
				[IdForOrd] [nvarchar](20),
				[QtaRda] [real],
				[CostoTotRcv] [money],
				[Descrizione] [nvarchar](max),
				[DimLarghezza] [real],
				[DimAltezza] [real],
				[DimLunghezza] [real],
				[DescMateriale] [nvarchar](200),
				[CostoTotDoc] [float],
				[ForRcvDdtDataReg] [datetime],
				[DataCarico] [datetime]
				) AS DataReport
		WHERE IdOdlDet <> - 1
	END
			--------------------------------------------
			-- Restituisce JSON dataset 'Consuntivo_RegTmp'
			--------------------------------------------
	ELSE IF @DataSet = 'Consuntivo_RegTmp'
	BEGIN
		-- Se non trova il record lo precarica dal Json elaborato, questo per restituire dati anche se non ancora elaborati
		IF @JsonReport IS NULL
			SET @JsonReport = @JsonReport_RegTmp

		SELECT *
		FROM OPENJSON(@JsonReport) WITH (
				[Dent] [varchar](3),
				[IdOdlDet] [int],
				[IdCdl] [nvarchar](20),
				[IdOdlDetFase] [int],
				[Descfase] [nvarchar](max),
				[NFase] [int],
				[CostoCliPrv] [float],
				[DurataCliPrv] [float],
				[CostoPrev] [float],
				[DurataPrev] [float],
				[DurataTot] [float],
				[CostoTot] [float],
				[KeyFaseRegTmp] [nvarchar](78),
				[NoteFase] [nvarchar](max),
				[Note] [nvarchar](max),
				[NoteDec] [varchar](13),
				[CostoTotCons] [float],
				[ColRiga] [varchar](7),
				[Tipo] [int],
				[DataReg] [date],
				[CognomeNome] [nvarchar](511),
				[LabelOFF] [varchar](3),
				[LabelCostoOff] [varchar](9),
				[LabelCosn] [varchar](4),
				[LabelCostoCons] [varchar](11),
				[NFaseElab] [int],
				[IdForOrd] [nvarchar](20),
				[RagSoc] [nvarchar](300),
				[QtaOrd] [real],
				[CostoOrd] [money],
				[ForRcvDdtDataReg] [datetime],
				[DataConsegna] [date],
				[DataForDdt] [date]
				) AS DataReport
		WHERE IdOdlDet <> - 1
	END
			--------------------------------------------
			-- Restituisce JSON dataset 'Consuntivo_Tot'
			--------------------------------------------
	ELSE IF @DataSet = 'Consuntivo_Tot'
	BEGIN
		-- Se non trova il record lo precarica dal Json elaborato, questo per restituire dati anche se non ancora elaborati
		IF @JsonReport IS NULL
			SET @JsonReport = @JsonReport_Tot

		SELECT *
		FROM OPENJSON(@JsonReport) WITH (
				[IdOdlDet] [int],
				[CostoCliPrv] [float],
				[DurataCliPrv] [nvarchar](10),
				[CostoPrev] [money],
				[DurataPrev] [nvarchar](10),
				[CostoTot] [money],
				[DurataTot] [nvarchar](10),
				[CostoTotCons] [float],
				[DurataTotDecentramento] [nvarchar](10)
				) AS DataReport
		WHERE IdOdlDet <> - 1
	END

	SET @InfoElab = ISNULL(@InfoElab, '') + '-' + @DataSet + '-' + CONVERT(NVARCHAR(20), @IdOdlDet)

	EXECUTE StpCmdLog 'StpXOdlDetRpt',
		@StartExecutionTime,
		@InfoElab,
		0,
		@SysUser
END
	/*****************************
 * Utilizzo di chk per decidere se rilanciare l'elaborazione
 DECLARE @JsonReport AS NVARCHAR(max)
DECLARE @JsonReport_Chk AS NVARCHAR(max)

SET @JsonReport = (
		SELECT *
		FROM (
			SELECT VstOdlDet.IdOdl,
				VstOdlDet.SysRowVersion,
				VstOdlDet.CostoOdlTotUnit,
				VstOdlDet.PrezzoOffTot,
				VstOdlDet.PrezzoFatTot,
				VstOdlDet.PrezzoPropostoTot,
				VstOdlDet.PrezzoTot,
				VstOdlDet.DurataPrvTot,
				VstOdlDet.CostoLavEstUnitP,
				VstOdlDet.PrezzoLavEstUnitD,
				VstOdlDet.PrezzoTotUnitL,
				VstOdlDet.PrezzoTotUnitP,
				VstOdlDet.PrezzoLavEstUnitP,
				VstOdlDet.CostoOdlAgntUnit,
				VstOdlDet.CostoOdlLavEstUnit,
				VstOdlDet.CostoOdlLavIntUnit,
				VstOdlDet.CostoOdlMaterialiUnit,
				VstOdlDet.CostoPrvLavEstUnitP,
				VstOdlDet.CostoOdlLavEstUnitP,
				VstOdlDet.CostoOdlLavEstUnitD,
				VstOdlDet.CostoPrvLavEstUnitD,
				VstOdlDet.CostoLavEstUnitD,
				VstOdlDet.DurataOdlTot,
				VstOdlDet.DurataTot,
				VstOdlDet.DurataPrvTotD,
				VstOdlDet.DurataOdlTotD,
				VstOdlDet.DurataTotD,
				VstOdlDet.CostoOdlTotUnitP,
				VstOdlDet.CostoPrvTotUnitP,
				VstOdlDet.CostoTotUnitP,
				VstOdlDet.CostoOdlTotUnitL,
				VstOdlDet.CostoPrvTotUnitL,
				VstOdlDet.CostoTotUnitL,
				VstOdlDet.CostoPrvLavIntUnit,
				VstOdlDet.CostoPrvLavEstUnit,
				VstOdlDet.CostoPrvAgntUnit,
				VstOdlDet.CostoPrvMaterialiUnit,
				VstOdlDet.CostoPrvTotUnit,
				VstOdlDet.PrezzoPrvLavIntUnit,
				VstOdlDet.PrezzoPrvLavEstUnit,
				VstOdlDet.PrezzoPrvAgntUnit,
				VstOdlDet.PrezzoPrvMaterialiUnit,
				VstOdlDet.PrezzoOff,
				VstOdlDet.PrezzoPrv,
				VstOdlDet.MarginePrezzo,
				VstOdlDet.PrezzoFat,
				VstOdlDet.MarginePrezzoFat,
				VstOdlDet.MargineFat,
				VstOdlDet.MargineMateriali,
				VstOdlDet.MargineLavorazioni,
				VstOdlDet.MargineCostiAgnt,
				VstOdlDet.CostoUnit,
				VstOdlDet.QtaProdotta,
				VstOdlDet.CostoMateriali,
				VstOdlDet.CostoLavEst,
				VstOdlDet.CostoAgnt,
				VstOdlDet.CostoLavIntUnit,
				VstOdlDet.CostoLavEstUnit,
				VstOdlDet.CostoAgntUnit,
				VstOdlDet.CostoMaterialiUnit,
				VstOdlDet.CostoMaterialiExtra,
				VstOdlDet.CostoLavIntExtra,
				VstOdlDet.CostoLavEstExtra,
				VstOdlDet.PrezzoMateriali,
				VstOdlDet.CostoAgntExtra,
				VstOdlDet.PrezzoLavInt,
				VstOdlDet.CostoTotExtra,
				VstOdlDet.CostoTotUnit,
				VstOdlDet.CostoTot,
				VstOdlDet.PrezzoProposto,
				VstOdlDet.PrezzoAgntExtra,
				VstOdlDet.PrezzoLavEstExtra,
				VstOdlDet.PrezzoLavIntExtra,
				VstOdlDet.PrezzoMaterialiExtra,
				VstOdlDet.PrezzoMaterialiUnit,
				VstOdlDet.PrezzoAgntUnit,
				VstOdlDet.PrezzoLavEstUnit,
				VstOdlDet.PrezzoLavIntUnit,
				VstOdlDet.PrezzoAgnt,
				VstOdlDet.PrezzoLavEst,
				VstOdlDet.MargineLavorazioniExt,
				VstOdlDet.Margine,
				VstOdlDet.MargineProposto,
				VstOdlDet.Prezzo,
				VstOdlDet.CostoLavEstP,
				VstOdlDet.CostoLavEstD,
				VstOdlDet.CostoPrvMateriali,
				VstOdlDet.CostoOdlMateriali,
				VstOdlDet.CostoPrvLavEstP,
				VstOdlDet.CostoOdlLavEstP,
				VstOdlDet.CostoPrvTotP,
				VstOdlDet.CostoOdlTotP,
				VstOdlDet.CostoPrvLavInt,
				VstOdlDet.CostoOdlLavInt,
				VstOdlDet.CostoPrvLavEstD,
				VstOdlDet.CostoOdlLavEstD,
				VstOdlDet.CostoPrvTotL,
				VstOdlDet.CostoOdlTotL,
				VstOdlDet.CostoPrvTot,
				VstOdlDet.CostoOdlTot,
				VstOdlDet.CostoPrvAgnt,
				VstOdlDet.CostoOdlAgnt,
				VstOdlDet.CostoTotP,
				VstOdlDet.CostoLavInt,
				VstOdlDet.CostoTotL,
				VstOdlDet.PrezzoMateriale,
				VstOdlDet.PrezzoLavEstP,
				VstOdlDet.PrezzoTotP,
				VstOdlDet.PrezzoLavUnit,
				VstOdlDet.PrezzoTotL,
				VstOdlDet.PrezzoLavEstD,
				VstOdlDet.DurataPrvTotProd,
				VstOdlDet.DurataOdlTotProd,
				VstOdlDet.DurataTotProd,
				VstOdlDet.DurataPrvTotProdD,
				VstOdlDet.DurataOdlTotProdD,
				VstOdlDet.DurataTotProdD,
				VstOdlDet.PrezzoCliPrvTot,
				VstOdlDet.RicaricoCostoTot,
				VstOdlDet.RicaricoCostoPercTot,
				VstOdlDet.RicaricoPrezzoTot,
				VstOdlDet.RicaricoPrezzoPercTot,
			    OdlDet_CtrlElab.IdOdlDet AS IdOdlDetElab
			FROM VstOdlDet
            LEFT OUTER JOIN VstOdlDet_CtrlElab ON VstOdlDet_CtrlElab.IdOdlDet = VstOdlDet.IdOdlDet
			WHERE (VstOdlDet.IdOdlDet = @IdOdlDet)
			) drv
		FOR JSON auto
		)
SET @JsonReport_Chk = (
		SELECT JsonReport
		FROM TbOdlDetElab
		WHERE IdOdlDet = @IdOdlDet
		)



SELECT @JsonReport_Chk = root.VALUE
FROM OPENJSON(@JsonReport_Chk) AS root
WHERE root.[key] = 'Consuntivo_Chk'

IF isnull(@JsonReport_Chk, '') <> isnull(@JsonReport, '')
BEGIN
	PRINT 'Elabora'

	EXECUTE [dbo].[StpXOdlDetRpt] @IdOdlDet,
		NULL,
		NULL
END
**************************************/

GO

