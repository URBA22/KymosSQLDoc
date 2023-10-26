

-- ==========================================================================================
-- Entity Name:   VstCliPrjRegTmp
-- Author:        dav
-- Create date:   210817
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 210817 Creazione
-- dav 210923 Aggiunto Acronimo, RagSoc
-- dav 211128 Aggiunto TbAtvtScn.IdAttivita.IdAttivitaPadre, TbAtvtScn.IdAttivitaMaster
-- fab 220302 Aggiunto IdArticolo e DescPrj
-- dav 220422 Aggiunto FlgBloccoFat
-- vale 220428 Aggiunto FlgRimborsoCosto
-- dav 220507 Gestione ColRiga
-- sim 220531 Aggiunto RagSocCompleta
-- FRA 221004 Aggiunto AcronimoSetting
-- FRA 221122 Aggiunto FlgScadPrs per filtrare sulla griglia Progetti senza scadenza, per controllo
-- FRA 230808 Aggiunto IdTodo,
-- FRA 230809 Aggiunto DescTktTodo e DescTkt dalla VstTktTodo
-- ==========================================================================================
CREATE   VIEW [dbo].[zzz_VstCliPrjRegTmp_230809]
AS
	SELECT TbCliPrjRegTmp.IdCliPrjRegTmp, TbCliPrjRegTmp.IdCliPrj, TbCliPrjRegTmp.IdAttivita, TbCliPrjRegTmp.IdUtente, TbCliPrjRegTmp.DataAttivita, TbCliPrjRegTmp.DescAttivita, TbCliPrjRegTmp.NoteAttivita, TbCliPrjRegTmp.NoteInterne, TbCliPrjRegTmp.Costo, TbCliPrjRegTmp.Prezzo, TbCliPrjRegTmp.DescCosto, 
	TbCliPrjRegTmp.KmPercorsi, TbCliPrjRegTmp.CostoKm, TbCliPrjRegTmp.OraInizio, TbCliPrjRegTmp.OraFine, TbCliPrjRegTmp.DurataViaggio, TbCliPrjRegTmp.DurataViaggioUte, TbCliPrjRegTmp.DurataAttivita, TbCliPrjRegTmp.CostoOra, TbCliPrjRegTmp.PrezzoOra, TbCliPrjRegTmp.DurataAttivitaDch, TbCliPrjRegTmp.DurataAttivitaElab, 
	TbCliPrjRegTmp.CostoTot, TbCliPrjRegTmp.PrezzoTot, TbCliPrjRegTmp.PrezzoAttivita, TbCliPrjRegTmp.PrezzoViaggio, TbCliPrjRegTmp.Ambito, TbCliPrjRegTmp.CodFnzLuogo, TbCliPrjRegTmp.CodFnzTipoTrasferta, TbCliPrjRegTmp.CodFnzTipoRimborso,  

	right('00000000000' + convert(nvarchar(20), TbCliPrjRegTmp.IdCliPrjRegTmp),20) as Ord,
	CASE 
	WHEN TbCliPrjRegTmp.DurataAttivitaElab IS NULL THEN '#FFFFE6' 
	WHEN TbCliPrjRegTmp.DurataAttivita IS NULL THEN '#E6FFF7' 
	WHEN TbCliPrjRegTmp.DurataAttivita = 0 THEN '#FFFF66' 
	WHEN TbCliPrjRegTmp.DurataAttivita > 60 * 10 THEN '#FF0000'
	WHEN TbCliPrjRegTmp.DurataAttivita < 15 THEN '#FF0000'
	ELSE '#FFEECF' END AS ColDurata,

	CONVERT(BIT, CASE WHEN (TbCliPrjRegTmp.DurataAttivita IS NULL) THEN 0 ELSE 1 END) AS FlgGestManDurata,

	CASE 
		WHEN TbCliOrdDetScad.IdCliOrdDetScad is not null THEN [dbo].[FncAdmDhColor] ('GREEN') 
		WHEN TbCliPrjRegTmp.FlgBloccoFat = 1 THEN [dbo].[FncAdmDhColor] ('RED') 
		ELSE [dbo].[FncAdmDhColor] ('GREY')  
		END AS ColRiga,

	CASE WHEN TbCliOrdDetScad.IdCliOrdDetScad is not null THEN 1 ELSE 0 END AS FlgScadPrs,

	Convert(smallint, 0) as Sem1,
	Convert(smallint, 0) as Sem2,
	Convert(smallint, 0) as Sem3,
	Convert(smallint, 0) as Sem4,

	TbAtvtPrm.IdAttivita AS IdAttivitaPrm, 
	TbAtvtPrm.DescAttivita AS DescAttivitaPrm, 
	TbAtvtScn.IdAttivita AS IdAttivitaScn, 
	TbAtvtScn.DescAttivita AS DescAttivitaScn,

	TbCliPrjRegTmp.IdCliFatDet, TbCliFatDet.IdCliFat,
	TbUtenti.CognomeNome,

	TbCliPrjRegTmp.SysDateCreate, TbCliPrjRegTmp.SysUserCreate, 
	TbCliPrjRegTmp.SysDateUpdate, TbCliPrjRegTmp.SysUserUpdate, TbCliPrjRegTmp.SysRowVersion, TbClienti.Acronimo, TbClienti.RagSoc,
	TbAtvtScn.IdAttivitaPadre, TbAtvtScn.IdAttivitaMaster, TbCliPrj.IdArticolo, TbCliPrj.DescPrj, TbCliPrjRegTmp.FlgBloccoFat,
	FlgRimborsoCosto, TbClienti.RagSocCompleta,
	TbSetting.Acronimo AS AcronimoSetting
    --,
    --TbCliPrjRegTmp.IdTodo

FROM  dbo.TbCliPrjRegTmp TbCliPrjRegTmp LEFT OUTER JOIN
         dbo.TbAttivita AS TbAtvtScn ON TbCliPrjRegTmp.IdAttivita = TbAtvtScn.IdAttivita LEFT OUTER JOIN
         dbo.TbAttivita AS TbAtvtPrm ON TbAtvtScn.IdAttivitaPadre = TbAtvtPrm.IdAttivita LEFT OUTER JOIN
		 dbo.TbCliFatDet AS TbCliFatDet ON TbCliFatDet.IdCliFatDet = TbCliPrjRegTmp.IdCliFatDet  LEFT OUTER JOIN
		 dbo.TbUtenti TbUtenti ON TbUtenti.IdUtente = TbCliPrjRegTmp.IdUtente LEFT OUTER JOIN
		 dbo.TbCliPrj AS TbCliPrj ON TbCliPrj.IdCliPrj = TbCliPrjRegTmp.IdCliPrj  LEFT OUTER JOIN
		 dbo.TbClienti AS TbClienti ON TbClienti.IdCliente = TbCliPrj.IdCliente LEFT OUTER JOIN
		 dbo.TbCliOrdDetScad TbCliOrdDetScad ON TbCliOrdDetScad.IdCliPrjRegTmp = TbCliPrjRegTmp.IdCliPrjRegTmp LEFT OUTER JOIN
		 dbo.TbSetting AS TbSetting ON TbCliPrjRegTmp.IdSetting = TbSetting.IdSetting 
         LEFT OUTER JOIN
		 dbo.VstTktTodo AS VstTktTodo ON VstTktTodo.IdTodo = TbCliPrjRegTmp.IdTodo

GO

