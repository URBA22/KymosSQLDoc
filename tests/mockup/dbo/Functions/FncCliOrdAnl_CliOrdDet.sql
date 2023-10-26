


        
-- ==========================================================================================
-- Entity Name:    FncCliOrdAnl_CliOrdDet
-- Author:         fab
-- Create date:    230710
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    Funzione su cui si basa la scheda FrmCliOrdOdlAnl di DboWeb per ritorna le righe
-- History:
-- fab 230710 Creazione
-- ==========================================================================================

CREATE FUNCTION [dbo].[FncCliOrdAnl_CliOrdDet]
(
	@IdCliOrd as nvarchar(50),
	@SysUser as nvarchar(256)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
         VstCliOrdDet.IdCliOrdDet,
         VstCliOrdDet.FlgSelezione,
         VstCliOrdDet.NRiga,
         VstOdlDet.IdOdlDet AS IdOdlDet, 
         VstOdlDet.IdOdl AS IdOdl, 
         ISNULL(VstOdlDet.IdArticolo, VstCliOrdDet.IdArticolo) AS IdArticolo, 
         ISNULL(VstOdlDet.Qta, VstCliOrdDet.Qta) AS Qta,
         VstOdlDet.UnitM, 
         VstOdlDet.UnitMCoeff, 
         VstOdlDet.RagSoc, 
         VstOdlDet.IdCliente, 
         VstOdlDet.NoteConsuntivo, 
         VstOdlDet.MargineMateriali, 
         VstOdlDet.MargineLavorazioni, 
         VstOdlDet.MargineCostiAgnt, 
         VstOdlDet.IdMatrConformita, 
         VstOdlDet.QtaScarto, 
         VstOdlDet.CostoUnitCsntScarto, 
         VstOdlDet.PrezzoUnitCsnt, 
         VstOdlDet.SysUserCreate, 
         VstOdlDet.SysDateUpdate, 
         VstOdlDet.SysUserUpdate, 
         VstCliOrdDet.SysRowVersion, 
         VstOdlDet.DataOdl, 
         VstOdlDet.CostoUnit, 
         VstOdlDet.PrezzoUnit, 
         VstOdlDet.Sem1, 
         VstOdlDet.Sem2, 
         VstOdlDet.Sem3, 
         VstOdlDet.Sem4, 
         VstOdlDet.QtaDaProdurre, 
         VstOdlDet.FlgRigaEvasa, 
         VstOdlDet.Ord, 
         VstOdlDet.CostoLavInt, 
         VstOdlDet.CostoLavEst, 
         VstOdlDet.CostoAgnt, 
         VstOdlDet.CostoLavIntUnit, 
         VstOdlDet.CostoLavEstUnit, 
         VstOdlDet.CostoAgntUnit, 
         VstOdlDet.CostoMaterialiUnit, 
         VstOdlDet.CostoMaterialiExtra, 
         VstOdlDet.CostoLavIntExtra, 
         VstOdlDet.CostoLavEstExtra, 
         VstOdlDet.CostoAgntExtra, 
         VstOdlDet.PrezzoMateriali, 
         VstOdlDet.PrezzoLavInt, 
         VstOdlDet.PrezzoLavEst, 
         VstOdlDet.PrezzoAgnt, 
         VstOdlDet.PrezzoLavIntUnit, 
         VstOdlDet.PrezzoLavEstUnit, 
         VstOdlDet.PrezzoAgntUnit, 
         VstOdlDet.PrezzoMaterialiUnit, 
         VstOdlDet.PrezzoMaterialiExtra, 
         VstOdlDet.PrezzoLavIntExtra, 
         VstOdlDet.PrezzoLavEstExtra, 
         VstOdlDet.PrezzoAgntExtra, 
         VstOdlDet.PrezzoProposto, 
         VstOdlDet.CostoTot, 
         VstOdlDet.CostoTotUnit, 
         VstOdlDet.CostoTotExtra, 
         VstOdlDet.MargineLavorazioniExt, 
         VstOdlDet.Margine, 
         VstOdlDet.MargineProposto, 
         VstOdlDet.Prezzo, 
         VstOdlDet.StatoElab, 
         VstOdlDet.DataElab, 
         VstOdlDet.PrezzoPrv, 
         VstOdlDet.CostoPrvAgntUnit, 
         VstOdlDet.CostoPrvMaterialiUnit, 
         VstOdlDet.CostoPrvTotUnit, 
         VstOdlDet.PrezzoPrvLavIntUnit, 
         VstOdlDet.PrezzoPrvLavEstUnit, 
         VstOdlDet.PrezzoPrvAgntUnit, 
         VstOdlDet.PrezzoPrvMaterialiUnit, 
         VstOdlDet.ColPrezzo, 
         VstOdlDet.StatoMrp, 
         VstOdlDet.ColStatoMrp, 
         VstOdlDet.DescStatoMrp, 
         VstOdlDet.OrdMrp, 
         VstOdlDet.MarginePrezzo, 
         VstOdlDet.PrezzoFat, 
         VstOdlDet.MarginePrezzoFat, 
         VstOdlDet.MargineFat, 
         VstOdlDet.QtaMage, 
         VstOdlDet.StatoElabPrezzo, 
         VstOdlDet.PrezzoExtra, 
         VstOdlDet.QtaMageDisponibile, 
         VstOdlDet.QtaMedia, 
         VstOdlDet.QtaMov, 
         VstOdlDet.CostoOdlTotUnitL, 
         VstOdlDet.CostoTotUnitP, 
         VstOdlDet.CostoPrvTotUnitP, 
         VstOdlDet.CostoOdlTotUnitP, 
         VstOdlDet.DurataTotD, 
         VstOdlDet.DurataOdlTotD, 
         VstOdlDet.DurataPrvTotD, 
         CONVERT(decimal(18,8),VstOdlDet.Qta * VstOdlDet.DurataTot) AS DurataTot,  -- da verificare perché è strano
         VstOdlDet.DurataOdlTot, 
         VstOdlDet.CostoLavEstUnitD, 
         VstOdlDet.CostoPrvLavEstUnitD, 
         VstOdlDet.CostoOdlLavEstUnitD, 
         VstOdlDet.CostoOdlLavEstUnitP, 
         VstOdlDet.CostoPrvLavEstUnitP, 
         VstOdlDet.CostoOdlMaterialiUnit, 
         VstOdlDet.CostoOdlLavIntUnit, 
         VstOdlDet.CostoOdlLavEstUnit, 
         VstOdlDet.CostoOdlAgntUnit, 
         VstOdlDet.PrezzoLavEstUnitP, 
         VstOdlDet.PrezzoTotUnitP, 
         VstOdlDet.PrezzoTotUnitL, 
         VstOdlDet.PrezzoLavEstUnitD, 
         VstOdlDet.CostoLavEstUnitP, 
         VstOdlDet.DurataPrvTot, 
         ISNULL(VstOdlDet.PrezzoTot, VstCliOrdDet.PrezzoTot) AS PrezzoTot, 
         VstOdlDet.PrezzoPropostoTot, 
         VstOdlDet.PrezzoFatTot, 
         VstOdlDet.PrezzoOffTot, VstOdlDet.ColMaterialiUnit, VstOdlDet.ColCostoAgntUnit, VstOdlDet.ColLavIntUnit, VstOdlDet.ColLavEstUnitP, VstOdlDet.ColLavEstUnitD, VstOdlDet.ColLavEstUnit, VstOdlDet.PrezzoCliPrvUnit, VstOdlDet.QtaDdt, VstOdlDet.ColQtaDdt, VstOdlDet.RicaricoPrezzo, VstOdlDet.RicaricoCosto, VstOdlDet.RicaricoPrezzoPerc, VstOdlDet.RicaricoCostoPerc, 
         VstOdlDet.ColQta, VstOdlDet.ColQtaProdotta, VstOdlDet.CostoOdlTotUnit, VstOdlDet.CostoLavEstP, VstOdlDet.CostoLavEstD, VstOdlDet.CostoPrvMateriali, VstOdlDet.CostoOdlMateriali, VstOdlDet.CostoPrvLavEstP, VstOdlDet.CostoOdlLavEstP, VstOdlDet.CostoPrvTotP, VstOdlDet.CostoOdlTotP, VstOdlDet.CostoPrvLavInt, VstOdlDet.CostoOdlLavInt, VstOdlDet.CostoPrvLavEstD, 
         VstOdlDet.CostoOdlLavEstD, VstOdlDet.CostoPrvTotL, VstOdlDet.CostoOdlTotL, VstOdlDet.CostoPrvTot, VstOdlDet.CostoOdlTot, VstOdlDet.CostoPrvAgnt, VstOdlDet.CostoOdlAgnt, VstOdlDet.CostoTotP, VstOdlDet.CostoTotL, VstOdlDet.PrezzoMateriale, VstOdlDet.PrezzoLavEstP, VstOdlDet.PrezzoTotP, VstOdlDet.PrezzoLavUnit, VstOdlDet.PrezzoTotL, VstOdlDet.PrezzoLavEstD, 
         VstOdlDet.DurataPrvTotProd, VstOdlDet.DurataOdlTotProd, VstOdlDet.DurataTotProd, VstOdlDet.DurataPrvTotProdD, VstOdlDet.DurataOdlTotProdD, VstOdlDet.DurataTotProdD, VstOdlDet.PrezzoCliPrvTot, VstOdlDet.RicaricoCostoTot, VstOdlDet.RicaricoCostoPercTot, VstOdlDet.RicaricoPrezzoTot, VstOdlDet.RicaricoPrezzoPercTot, VstOdlDet.PrezzoLavIntMedioOra, 
         VstOdlDet.FlgConsuntivato, VstOdlDet.NoteOdlDet, VstOdlDet.CostoUnitCsnt, VstOdlDet.SysDateCreate, VstOdlDet.QtaProdotta, VstOdlDet.IdCliOrd, 
         ISNULL(VstOdlDet.Descrizione, VstCliOrdDet.Descrizione) AS Descrizione, 
         VstOdlDet.DataConsegna, VstOdlDet.ColRiga, VstOdlDet.CostoMateriali, VstOdlDet.ColElab, VstOdlDet.PrezzoOff, VstOdlDet.CostoPrvLavIntUnit, VstOdlDet.CostoPrvLavEstUnit, VstOdlDet.CostoScarti, 
         VstOdlDet.CostoTotUnitL, VstOdlDet.CostoPrvTotUnitL,
         TbArticoli.UnitMDim,
         TbArticoli.DimAltezza,
         TbArticoli.DimLunghezza,
         TbArticoli.DimLarghezza,
         TbArticoli.DimSpessore,
         TbArticoli.DimPeso,
         TbArticoli.UnitMPeso,
         ISNULL(VstOdlDet.Acronimo, VstCliOrdDet.Acronimo) AS Acronimo
    FROM VstCliOrdDet 
        LEFT OUTER JOIN VstOdlDet 
                ON VstCliOrdDet.IdCliOrdDet = VstOdlDet.IdCliOrdDet 
        LEFT OUTER JOIN TbOdlDetCliOrd 
            ON  TbOdlDetCliOrd.IdOdlDet = VstOdlDet.IdOdlDet 
        LEFT OUTER JOIN TbArticoli
            ON TbArticoli.IdArticolo = VstCliOrdDet.IdArticolo
    WHERE (VstCliOrdDet.IdCliOrd = @IdCliOrd)
)

GO

