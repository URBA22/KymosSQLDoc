

/*
 * History
 * vale 20.10.16 aggiunto campi per pizeta
 * fab 07.11.16 aggiunto campo DescListino
 * dav 30.12.16 aggiunto nolock
 * dav 15.04.17 nolock su elab
 * vale 07.03.19 aggiunta ragsocvettore e idvettore
 */
CREATE VIEW [dbo].[VstTrspTrasporti]
AS
SELECT dbo.TbTrspTrasporti.IdTrsp, CASE WHEN drvFatturato.IdTrsp IS NULL THEN 0 ELSE 1 END AS FlgTrspFatturato, dbo.TbTrspTrasporti.DataPrenotazione, dbo.TbTrspTrasporti.IdCausaleTrsp, dbo.TbTrspTrasporti.IdCliente, dbo.TbTrspTrasporti.Destinatario, 
             dbo.TbTrspTrasporti.IdCliDest, dbo.TbTrspTrasporti.Destinazione, dbo.TbTrspTrasporti.IdProvinciaDestinazione, dbo.TbTrspTrasporti.IdZonaDestinazione, dbo.TbTrspTrasporti.IdCliMittente, dbo.TbTrspTrasporti.Mittente, dbo.TbTrspTrasporti.IdProvinciaMittente, 
             dbo.TbTrspTrasporti.IdZonaMittente, dbo.TbTrspTrasporti.DescMerce, dbo.TbTrspTrasporti.NoteTrsp, dbo.TbTrspTrasporti.PesoKg, dbo.TbTrspTrasporti.NColli, dbo.TbTrspTrasporti.NPallet, dbo.TbTrspTrasporti.MC, dbo.TbTrspTrasporti.IdIva, 
             dbo.TbTrspTrasporti.IdPorto, dbo.TbTrspTrasporti.FlgBloccoFat, dbo.TbTrspTrasporti.DescFattura, dbo.TbTrspTrasporti.IdValuta, dbo.TbTrspTrasporti.Cambio, dbo.TbTrspTrasporti.IdLingua, dbo.TbTrspTrasporti.ImportoVlt, dbo.TbTrspTrasporti.Sconto, 
             dbo.TbTrspTrasporti.Sconto1, dbo.TbTrspTrasporti.Sconto2, dbo.TbTrspTrasporti.Sconto3, dbo.TbTrspTrasporti.ImportoTotVlt, dbo.TbTrspTrasporti.BlocDoc, dbo.TbTrspTrasporti.IdCondPag, dbo.TbTrspTrasporti.CodFnzStato, dbo.TbTrspTrasporti.ImportoTot, 
             dbo.TbTrspTrasporti.FlgAssicurato, dbo.TbTrspTrasporti.FlgContrassegno, dbo.TbTrspTrasporti.FlgSpondaIdraulica, dbo.TbTrspTrasporti.FlgAnnullato, dbo.TbTrspTrasporti.FlgCompensazione, dbo.TbTrspTrasporti.ImportoAssicurato, 
             dbo.TbTrspTrasporti.ImportoContrassegno, dbo.TbTrspTrasporti.Priorita, dbo.TbTrspTrasporti.SysDateCreate, dbo.TbTrspTrasporti.SysUserCreate, dbo.TbTrspTrasporti.SysDateUpdate, dbo.TbTrspTrasporti.SysUserUpdate, dbo.TbTrspTrasporti.SysRowVersion, 
             dbo.TbTrspAnagCausali.DescCausaleTrsp, dbo.TbTrspAnagCausali.FlgAdeguamento, TbClienti_1.RagSoc, dbo.TbCliDest.DescDest, dbo.TbClienti.RagSoc AS RagSocMittente, dbo.TbCntIva.DescIva, dbo.TbCntIva.Aliquota, dbo.TbSpedPorto.DescPorto, 
             dbo.TbCntCondPag.DescPag, dbo.TbTrspTrasporti.FlgNoDdt, dbo.TbTrspTrasportiElab.NoteElab, TbClienti_1.Disabilita, dbo.TbTrspTrasporti.MittenteOrigine, dbo.TbTrspTrasporti.DimH, dbo.TbTrspTrasporti.DimL, dbo.TbTrspTrasporti.DimP, dbo.TbTrspTrasporti.UnitM, 
             dbo.TbTrspTrasporti.IdListino, dbo.TbTrspTrasporti.NoteCalcolo, dbo.TbTrspTrasporti.ImportoVltCalcolato, dbo.TbTrspTrasporti.DataCalcolo, dbo.TbTrspTrasporti.QtaEquivalente, dbo.TbTrspTrasporti.ImportoCtrlData, dbo.TbTrspTrasporti.ImportoCtrlNote, 
             dbo.TbTrspTrasporti.ImportoCtrlUser, dbo.TbTrspTrasporti.FlgImportoCtrl, dbo.TbTrspTrasporti.FlgMerceSede, dbo.TbTrspTrasportiElab.FlgWarnings, dbo.TbTrspTrasportiElab.FlgAllert, dbo.TbTrspTrasportiElab.AllertDesc, dbo.TbTrspTrasportiElab.WarningsDesc, 
             dbo.TbTrspTrasportiElab.FlgMerceSedeSped, dbo.TbTrspTrasportiElab.ColRiga, 
			 
			 CONVERT(smallint, 0) AS Sem1, 
			 CONVERT(smallint, 0) AS Sem2, 
			 CONVERT(smallint, 0) AS Sem3, 
			 CONVERT(smallint, 0) AS Sem4, 
			 
			 dbo.TbTrspTrasporti.Km, dbo.TbTrspTrasporti.ImportoVltKm, 
             dbo.TbTrspTrasporti.ImportoVltKmTot, dbo.TbTrspTrasporti.Ore, dbo.TbTrspTrasporti.ImportoVltOre, dbo.TbTrspTrasporti.ImportoExtra, dbo.TbTrspTrasporti.ImportoExtraNote, TbTrspListini.DescListino, TbTrspTrasporti.IdVettore, TbTrspTrasporti.RagSocVettore
FROM   dbo.TbTrspTrasporti WITH (NOLOCK)  LEFT OUTER JOIN
             dbo.TbTrspTrasportiElab WITH (NOLOCK) ON dbo.TbTrspTrasporti.IdTrsp = dbo.TbTrspTrasportiElab.IdTrsp LEFT OUTER JOIN
             dbo.TbCntCondPag ON dbo.TbTrspTrasporti.IdCondPag = dbo.TbCntCondPag.IdCondPag LEFT OUTER JOIN
             dbo.TbClienti AS TbClienti_1 ON dbo.TbTrspTrasporti.IdCliente = TbClienti_1.IdCliente LEFT OUTER JOIN
             dbo.TbClienti ON dbo.TbTrspTrasporti.IdCliMittente = dbo.TbClienti.IdCliente LEFT OUTER JOIN
             dbo.TbSpedPorto ON dbo.TbTrspTrasporti.IdPorto = dbo.TbSpedPorto.IdPorto LEFT OUTER JOIN
             dbo.TbCntIva ON dbo.TbTrspTrasporti.IdIva = dbo.TbCntIva.IdIva LEFT OUTER JOIN
             dbo.TbCliDest ON dbo.TbTrspTrasporti.IdCliDest = dbo.TbCliDest.IdCliDest LEFT OUTER JOIN
             dbo.TbTrspAnagCausali ON dbo.TbTrspTrasporti.IdCausaleTrsp = dbo.TbTrspAnagCausali.IdCausaleTrsp LEFT OUTER JOIN
			(SELECT IdTrsp
			FROM    dbo.TbCliFatDet WITH (NOLOCK)
			GROUP BY IdTrsp) AS drvFatturato ON dbo.TbTrspTrasporti.IdTrsp = drvFatturato.IdTrsp LEFT OUTER JOIN 
			TbTrspListini ON dbo.TbTrspTrasporti.IdListino = TbTrspListini.IdListino

GO

