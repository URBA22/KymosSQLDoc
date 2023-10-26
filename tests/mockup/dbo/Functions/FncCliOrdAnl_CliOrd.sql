-- ==========================================================================================
-- Entity Name:    FncCliOrdAnl_CliOrd
-- Author:         fab
-- Create date:    230710
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    Funzione su cui si basa la scheda FrmCliOrdOdlAnl di DboWeb per ritorna la testata
-- History:
-- fab 230710 Creazione
-- ==========================================================================================
CREATE FUNCTION [dbo].[FncCliOrdAnl_CliOrd] 
(
    @IdCliOrd as nvarchar(50),
	@SysUser as nvarchar(256)
)
RETURNS @TbCliOrdDet TABLE (
	[IdCliOrd] [nvarchar](20) NOT NULL,
	[CostoAgn] [money] NULL,
	[CostoAgntExtra] [money] NULL,
	[CostoMaterialiUnit] [money] NULL,
	[CostoOdlMaterialiUnit] [money] NULL,
	[CostoPrvMaterialiUnit] [money] NULL,
	[CostoLavEstUnitP] [money] NULL,
	[CostoOdlLavEstUnitP] [money] NULL,
	[CostoPrvLavEstUnitP] [money] NULL,
	[CostoAgntUnit] [money] NULL,
	[CostoOdlAgntUnit] [money] NULL,
	[CostoPrvAgntUnit] [money] NULL,
	[CostoLavIntUnit] [money] NULL,
	[CostoOdlLavIntUnit] [money] NULL,
	[CostoPrvLavIntUnit] [money] NULL,
	[CostoTotUnitP] [money] NULL,
	[CostoOdlTotUnitP] [money] NULL,
	[CostoPrvTotUnitP] [money] NULL,
	[PrezzoMaterialiUnit] [money] NULL,
	[PrezzoLavEstUnitP] [money] NULL,
	[PrezzoAgntUnit] [money] NULL,
	[PrezzoLavIntUnit] [money] NULL,
	[PrezzoTotUnitP] [money] NULL,
	[CostoTotUnitL] [money] NULL,
	[CostoOdlTotUnitL] [money] NULL,
	[CostoPrvTotUnitL] [money] NULL,
	[PrezzoTotUnitL] [money] NULL,
	[CostoLavEstUnitD] [money] NULL,
	[CostoOdlLavEstUnitD] [money] NULL,
	[CostoPrvLavEstUnitD] [money] NULL,
	[PrezzoLavEstUnitD] [money] NULL,
	[DurataOdlTot] [decimal](38, 2) NULL,
	[DurataTot] [decimal](38, 2) NULL,
	[DurataPrvTot] [decimal](38, 2) NULL,
	[DurataOdlTotD] [decimal](38, 2) NULL,
	[DurataTotD] [decimal](38, 2) NULL,
	[DurataPrvTotD] [decimal](38, 2) NULL,
	[CostoPrvTotUnit] [money] NULL,
	[CostoOdlTotUnit] [money] NULL,
	[CostoTotUnit] [money] NULL,
	[PrezzoProposto] [money] NULL,
	[PrezzoCliPrvUnit] [money] NULL,
	[RicaricoPrezzo] [money] NULL,
	[RicaricoCosto] [money] NULL,
	[RagSoc] [nvarchar](300) NULL,
    [Prezzo] [money] NULL,
	[PrezzoOff] [money] NULL,
	[PrezzoFat] [money] NULL,
    [InfoRowSelect] [nvarchar](50)
	)
AS
BEGIN
	DECLARE @FlgSelectAll BIT
    DECLARE @CountRowSel int
    DECLARE @CountRow int

    SELECT 
        @CountRowSel = SUM(CASE WHEN FlgSelezione = 1 THEN 1 ELSE 0 END),
        @CountRow = COUNT(*)
    FROM TbCliOrdDet 
    WHERE IdCliOrd = @IdCliOrd AND ISNULL(IdArticolo, '') <> ''

    SET @FlgSelectAll = CASE WHEN (@CountRowSel = @CountRow OR @CountRowSel = 0) THEN 1 ELSE 0 END

    INSERT INTO @TbCliOrdDet
    (
        IdCliOrd,
        CostoAgn, 
        CostoAgntExtra, 
        CostoMaterialiUnit, 
        CostoOdlMaterialiUnit, 
        CostoPrvMaterialiUnit, 
        CostoLavEstUnitP, 
        CostoOdlLavEstUnitP,
        CostoPrvLavEstUnitP,
        CostoAgntUnit,
        CostoOdlAgntUnit, 
        CostoPrvAgntUnit, 
        CostoLavIntUnit, 
        CostoOdlLavIntUnit, 
        CostoPrvLavIntUnit, 
        CostoTotUnitP, 
        CostoOdlTotUnitP, 
        CostoPrvTotUnitP, 
        PrezzoMaterialiUnit, 
        PrezzoLavEstUnitP, 
        PrezzoAgntUnit, 
        PrezzoLavIntUnit, 
        PrezzoTotUnitP, 
        CostoTotUnitL, 
        CostoOdlTotUnitL, 
        CostoPrvTotUnitL, 
        PrezzoTotUnitL, 
        CostoLavEstUnitD, 
        CostoOdlLavEstUnitD, 
        CostoPrvLavEstUnitD, 
        PrezzoLavEstUnitD, 
        DurataOdlTot, 
        DurataTot, 
        DurataPrvTot, 
        DurataOdlTotD, 
        DurataTotD, 
        DurataPrvTotD, 
        CostoPrvTotUnit, 
        CostoOdlTotUnit, 
        CostoTotUnit, 
        PrezzoProposto, 
        PrezzoCliPrvUnit, 
        RicaricoPrezzo, 
        RicaricoCosto,
        Prezzo,
        PrezzoFat,
        PrezzoOff,
        RagSoc
    )
    SELECT 
        VstCliOrd.IdCliOrd,
        drvOdl.CostoAgn, 
        drvOdl.CostoAgntExtra, 
        drvOdl.CostoMaterialiUnit, 
        drvOdl.CostoOdlMaterialiUnit, 
        drvOdl.CostoPrvMaterialiUnit, 
        drvOdl.CostoLavEstUnitP, 
        drvOdl.CostoOdlLavEstUnitP,
        drvOdl.CostoPrvLavEstUnitP,
        drvOdl.CostoAgntUnit,
        drvOdl.CostoOdlAgntUnit, 
        drvOdl.CostoPrvAgntUnit, 
        drvOdl.CostoLavIntUnit, 
        drvOdl.CostoOdlLavIntUnit, 
        drvOdl.CostoPrvLavIntUnit, 
        drvOdl.CostoTotUnitP, 
        drvOdl.CostoOdlTotUnitP, 
        drvOdl.CostoPrvTotUnitP, 
        drvOdl.PrezzoMaterialiUnit, 
        drvOdl.PrezzoLavEstUnitP, 
        drvOdl.PrezzoAgntUnit, 
        drvOdl.PrezzoLavIntUnit, 
        drvOdl.PrezzoTotUnitP, 
        drvOdl.CostoTotUnitL, 
        drvOdl.CostoOdlTotUnitL, 
        drvOdl.CostoPrvTotUnitL, 
        drvOdl.PrezzoTotUnitL, 
        drvOdl.CostoLavEstUnitD, 
        drvOdl.CostoOdlLavEstUnitD, 
        drvOdl.CostoPrvLavEstUnitD, 
        drvOdl.PrezzoLavEstUnitD, 
        drvOdl.DurataOdlTot, 
        drvOdl.DurataTot, 
        drvOdl.DurataPrvTot, 
        drvOdl.DurataOdlTotD, 
        drvOdl.DurataTotD, 
        drvOdl.DurataPrvTotD, 
        drvOdl.CostoPrvTotUnit, 
        drvOdl.CostoOdlTotUnit, 
        drvOdl.CostoTotUnit, 
        drvOdl.PrezzoProposto, 
        drvOdl.PrezzoCliPrvUnit, 
        drvOdl.RicaricoPrezzo, 
        drvOdl.RicaricoCosto,
        ISNULL(drvOdl.Prezzo, VstCliOrd.PrezzoTot) AS Prezzo,
        drvOdl.PrezzoFat,
        drvOdl.PrezzoOff,
        TbClienti.RagSoc
    FROM VstCliOrd
        LEFT OUTER JOIN (
	        SELECT 
                TbCliOrdDet.IdCliOrd,
                SUM(ROUND(TbOdlDetElab.CostoAgnt,2)) AS CostoAgn,
                SUM(ROUND(TbOdlDetElab.CostoAgntExtra,2)) AS CostoAgntExtra,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoMaterialiUnit,2)) AS CostoMaterialiUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlMaterialiUnit,2)) AS CostoOdlMaterialiUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvMaterialiUnit,2)) AS CostoPrvMaterialiUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoLavEstUnitP,2)) AS CostoLavEstUnitP,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlLavEstUnitP,2)) AS CostoOdlLavEstUnitP,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvLavEstUnitP,2)) AS CostoPrvLavEstUnitP,
                SUM(ROUND(TbOdlDetElab.CostoAgnt,2)) AS CostoAgntUnit, -- Usato CostoAgnt perché soggetto a calcoli vari
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlAgntUnit,2)) AS CostoOdlAgntUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvAgntUnit,2)) AS CostoPrvAgntUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoLavIntUnit,2)) AS CostoLavIntUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlLavIntUnit,2)) AS CostoOdlLavIntUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvLavIntUnit,2)) AS CostoPrvLavIntUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoTotUnitP,2)) AS CostoTotUnitP,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlTotUnitP,2)) AS CostoOdlTotUnitP,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvTotUnitP,2)) AS CostoPrvTotUnitP,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoMaterialiUnit,2)) AS PrezzoMaterialiUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoLavEstUnitP,2)) AS PrezzoLavEstUnitP,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoAgntUnit,2)) AS PrezzoAgntUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoLavIntUnit,2)) AS PrezzoLavIntUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoTotUnitP,2)) AS PrezzoTotUnitP,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoTotUnitL,2)) AS CostoTotUnitL,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlTotUnitL,2)) AS CostoOdlTotUnitL,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvTotUnitL,2)) AS CostoPrvTotUnitL,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoTotUnitL,2)) AS PrezzoTotUnitL,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoLavEstUnitD,2)) AS CostoLavEstUnitD,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlLavEstUnitD,2)) AS CostoOdlLavEstUnitD,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvLavEstUnitD,2)) AS CostoPrvLavEstUnitD,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoLavEstUnitD,2)) AS PrezzoLavEstUnitD,
                SUM(TbOdlDet.Qta * TbOdlDetElab.DurataOdlTot) AS DurataOdlTot,
                SUM(TbOdlDet.Qta * TbOdlDetElab.DurataTot) AS DurataTot,
                SUM(TbOdlDet.Qta * TbOdlDetElab.DurataPrvTot) AS DurataPrvTot,
                SUM(TbOdlDet.Qta * TbOdlDetElab.DurataOdlTotD) AS DurataOdlTotD,
                SUM(TbOdlDet.Qta * TbOdlDetElab.DurataTotD) AS DurataTotD,
                SUM(TbOdlDet.Qta * TbOdlDetElab.DurataPrvTotD) AS DurataPrvTotD,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoPrvTotUnit,2)) AS CostoPrvTotUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoOdlTotUnit,2)) AS CostoOdlTotUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.CostoTotUnit,2)) AS CostoTotUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoProposto,2)) AS PrezzoProposto,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.PrezzoCliPrvUnit,2)) AS PrezzoCliPrvUnit,
                SUM(ROUND(TbOdlDet.Qta * TbOdlDetElab.Prezzo,2)) AS Prezzo,
                SUM(ROUND(ISNULL(TbOdlDet.Qta * TbOdlDetElab.PrezzoFat, DrvCliFat.PrezzoTot),2)) AS PrezzoFat,
                SUM(ROUND(ISNULL(TbOdlDet.Qta * TbOdlDetElab.PrezzoOff, VstCliOffDet.PrezzoTot),2)) AS PrezzoOff,
                SUM(
                    Round(TbOdlDet.Qta * (ISNULL(dbo.TbOdlDetElab.PrezzoFat, dbo.TbOdlDetElab.Prezzo) - dbo.TbOdlDetElab.PrezzoProposto), 2)
                ) AS RicaricoPrezzo,
                SUM(
                    Round(TbOdlDet.Qta * (ISNULL(dbo.TbOdlDetElab.PrezzoFat, dbo.TbOdlDetElab.Prezzo) - dbo.TbOdlDetElab.CostoTotUnit), 2)
                ) AS RicaricoCosto
            FROM TbCliOrdDet 
                LEFT OUTER JOIN TbOdlDet
                    ON TbCliOrdDet.IdCliOrdDet = TbOdlDet.IdCliOrdDet
                LEFT OUTER JOIN TbOdlDetCliOrd 
                    ON  TbOdlDetCliOrd.IdOdlDet = TbOdlDet.IdOdlDet 
                LEFT OUTER JOIN TbOdlDetElab
                    ON TbOdlDet.IdOdlDet = TbOdlDetElab.IdOdlDet OR TbOdlDetCliOrd.IdOdlDet = TbOdlDetElab.IdOdlDet
                LEFT OUTER JOIN VstCliOffDet
                    ON VstCliOffDet.IdCliOffDet = TbCliOrdDet.IdCliOffDet
                LEFT OUTER JOIN (SELECT TbCliOrdDet.IdCliOrdDet, SUM(VstCliFatDet.PrezzoTot) AS PrezzoTot
                                FROM TbCliOrdDet 
                                    LEFT OUTER JOIN (
                                        SELECT IdCliOrdDet, IdCliDdtDet
                                        FROM TbCliDdtDet 
                                            INNER JOIN VstCliDdt
                                                ON VstCliDdt.IdCliDdt = TbCliDdtDet.IdCliDdt
                                        WHERE TbCliDdtDet.FlgBloccoFat = 0 AND VstCliDdt.FlgBloccoFat = 0 AND VstCliDdt.FlgPrebolla = 0) 
                                        AS DrvCliDdt
                                        ON DrvCliDdt.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet
                                    INNER JOIN VstCliFatDet
                                        ON VstCliFatDet.IdCliDdtDet = DrvCliDdt.IdCliDdtDet OR VstCliFatDet.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet
                                    WHERE TbCliOrdDet.IdCliOrd = @IdCliOrd AND VstCliFatDet.FlgProforma = 0
                                GROUP BY TbCliOrdDet.IdCliOrdDet
                                ) AS DrvCliFat
                    ON DrvCliFat.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet
            WHERE TbCliOrdDet.IdCliOrd = @IdCliOrd AND 
                  (@FlgSelectAll = 1 OR TbCliOrdDet.IdCliOrdDet IN (SELECT IdCliOrdDet FROM TbCliOrdDet WHERE FlgSelezione = 1))
            GROUP BY TbCliOrdDet.IdCliOrd
	) drvOdl
	ON drvOdl.IdCliOrd = VstCliOrd.IdCliOrd LEFT OUTER JOIN TbClienti
		ON TbClienti.IdCliente = VstCliOrd.IdCliente
    WHERE VstCliOrd.IdCliOrd = @IdCliOrd


    UPDATE @TbCliOrdDet
    SET InfoRowSelect = (CASE WHEN @FlgSelectAll = 1 THEN 
                            CONVERT(nvarchar(50), @CountRow) 
                        ELSE 
                            (CONVERT(nvarchar(50), @CountRowSel))
                        END) + ' di ' + CONVERT(nvarchar(50), @CountRow)
	RETURN
END

GO

