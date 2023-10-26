


/*
 * History
 * fab  19.05.16	aggiunto FlgEseguito
 * vale 06.06.16 aggiunta DataTrasportoElab
 * vale 12.10.16 messo priorita di dettaglio
 * vale 20.10.16 messo campi in più per pizeta
 * fab  29.10.16 messo UpperCase su TipoTrsp
 * vale 06.11.16 aggiunta campi raggruppamento e sistemazione filtri,  colore riga
 * fab	25.11.16 aggiunta campo Categoria
 * dav  30.12.16 nolock e modifica fatturato (ottimizzazione)
 * fab	11.01.17 aggiunti IdUteAutista2, FlgEseguitoD, FlgVisibileWebD
 * vale 25.02.17 standard pz
 * dav  15.04.17 nolock su elab
 * dav  25.04.17 correzione sem1
 * dav  27.04.17 standardizazione sem4
 * vale 03.05.17 messo anche controllo sul colore pagamento nullo o a consegna 
 * vale 28.07.17 protezione dagli spazi e non solo nulli cond pag
 * vale 07.03.19 messo CodFnzStatoTipoTrsp per controllo filtro trasporti 
 * vale 16.05.19 standard LaPrima
 * fab	28.06.19 aggiunto ColCampi
 */
CREATE VIEW [dbo].[VstTrspTrasportiDetAZ]
AS
SELECT        dbo.TbTrspTrasportiDet.IdTrspDet, dbo.TbTrspTrasporti.IdTrsp, CASE WHEN drvCliFat.IdTrsp IS NULL THEN 0 ELSE 1 END AS FlgTrspFatturato, dbo.TbTrspTrasporti.DataPrenotazione, dbo.TbTrspTrasporti.IdCausaleTrsp, 
                         dbo.TbTrspTrasporti.IdCliente, dbo.TbTrspTrasporti.Destinatario, dbo.TbTrspTrasporti.IdCliDest, dbo.TbTrspTrasporti.IdProvinciaDestinazione, dbo.TbTrspTrasporti.IdZonaDestinazione, dbo.TbTrspTrasporti.IdCliMittente, 
                         dbo.TbTrspTrasporti.Mittente, dbo.TbTrspTrasporti.IdProvinciaMittente, dbo.TbTrspTrasporti.IdZonaMittente, dbo.TbTrspTrasporti.DescMerce, dbo.TbTrspTrasporti.NoteTrsp, dbo.TbTrspTrasporti.PesoKg, 
                         dbo.TbTrspTrasporti.NColli, dbo.TbTrspTrasporti.NPallet, dbo.TbTrspTrasporti.MC, dbo.TbTrspTrasporti.IdIva, dbo.TbTrspTrasporti.IdPorto, dbo.TbTrspTrasportiDet.FlgBloccoFat, dbo.TbTrspTrasporti.DescFattura, 
                         dbo.TbTrspTrasporti.IdValuta, dbo.TbTrspTrasporti.Cambio, dbo.TbTrspTrasporti.IdLingua, dbo.TbTrspTrasporti.ImportoVlt, dbo.TbTrspTrasporti.Sconto, dbo.TbTrspTrasporti.Sconto1, dbo.TbTrspTrasporti.Sconto2, 
                         dbo.TbTrspTrasporti.Sconto3, dbo.TbTrspTrasporti.ImportoTotVlt, dbo.TbTrspTrasporti.BlocDoc, dbo.TbTrspTrasporti.IdCondPag, dbo.TbTrspTrasporti.CodFnzStato, dbo.TbTrspTrasporti.ImportoTot, 
                         dbo.TbTrspTrasporti.FlgAssicurato, dbo.TbTrspTrasporti.FlgContrassegno, dbo.TbTrspTrasporti.FlgSpondaIdraulica, dbo.TbTrspTrasportiDet.FlgAnnullato, dbo.TbTrspTrasporti.FlgCompensazione, 
                         dbo.TbTrspTrasporti.ImportoAssicurato, dbo.TbTrspTrasporti.ImportoContrassegno, dbo.TbTrspTrasportiDet.Priorita, dbo.TbTrspAnagCausali.DescCausaleTrsp, dbo.TbTrspAnagCausali.FlgAdeguamento, TbClienti_1.RagSoc, 
                         dbo.TbCliDest.DescDest, dbo.TbClienti.RagSoc AS RagSocMittente, dbo.TbCntIva.DescIva, dbo.TbCntIva.Aliquota, dbo.TbSpedPorto.DescPorto, dbo.TbCntCondPag.DescPag, dbo.TbTrspTrasporti.FlgNoDdt, TbClienti_1.Disabilita, 
                         dbo.TbTrspTrasporti.MittenteOrigine, dbo.TbTrspTrasporti.DimH, dbo.TbTrspTrasporti.DimL, dbo.TbTrspTrasporti.DimP, dbo.TbTrspTrasporti.UnitM, dbo.TbTrspTrasporti.IdListino, dbo.TbTrspTrasporti.NoteCalcolo, 
                         dbo.TbTrspTrasporti.ImportoVltCalcolato, dbo.TbTrspTrasporti.DataCalcolo, dbo.TbTrspTrasporti.QtaEquivalente, dbo.TbTrspTrasporti.ImportoCtrlData, dbo.TbTrspTrasporti.ImportoCtrlNote, dbo.TbTrspTrasporti.ImportoCtrlUser, 
                         dbo.TbTrspTrasporti.FlgImportoCtrl, dbo.TbTrspTrasporti.FlgMerceSede, dbo.TbTrspTrasportiElab.FlgWarnings, dbo.TbTrspTrasportiElab.FlgAllert, dbo.TbTrspTrasportiElab.AllertDesc, dbo.TbTrspTrasportiElab.WarningsDesc, 
                         dbo.TbTrspTrasportiElab.FlgMerceSedeSped, CONVERT(smallint, CASE WHEN ImportoCtrlData IS NOT NULL AND ImportoVlt IS NOT NULL AND TbTrspTrasportiDet.FlgBloccoFat = 0 AND 
                         TbTrspTrasporti.FlgBloccoFat = 0 THEN 1 WHEN ImportoCtrlData IS NOT NULL AND ImportoVlt IS NOT NULL AND (TbTrspTrasportiDet.FlgBloccoFat = 1 OR
                         TbTrspTrasporti.FlgBloccoFat = 1) THEN 2 WHEN TbTrspTrasportiDet.FlgBloccoFat = 0 AND TbTrspTrasporti.FlgBloccoFat = 0 THEN 4 ELSE NULL END) AS Sem1, CONVERT(smallint, CASE WHEN drvCliFat.IdTrsp IS NOT NULL 
                         THEN 1 WHEN TbTrspTrasportiDet.FlgBloccoFat = 0 THEN 4 ELSE 0 END) AS Sem2, CONVERT(smallint, CASE WHEN TbTrspTrasportiDet.IdUteAutista IS NULL AND ISNULL(TipoTrsp, '--') 
                         <> 'R' THEN 2 WHEN TbTrspTrasportiDet.IdUteAutista1 IS NULL THEN 3 ELSE 0 END) AS Sem3, CONVERT(smallint, CASE WHEN TbTrspTrasporti.IdCondPag IS NULL 
                         THEN 3 WHEN dbo.TbCntCondPag.FlgPagConsegna = 1 THEN 2 ELSE 1 END) AS Sem4, UPPER(dbo.TbTrspTrasportiDet.TipoTrsp) AS TipoTrsp, dbo.TbTrspTrasportiDet.IdMezzo, dbo.TbTrspTrasportiDet.NoteTrspDet, 
                         dbo.TbTrspTrasportiDet.CostoVettore, dbo.TbTrspTrasportiDet.NoteVettore, dbo.TbTrspTrasportiDet.IdVettore, dbo.TbTrspTrasportiDet.RagSocVettore, dbo.TbTrspTrasportiDet.NFatVettore, dbo.TbTrspTrasportiDet.SysDateCreate, 
                         dbo.TbTrspTrasportiDet.SysUserCreate, dbo.TbTrspTrasportiDet.SysDateUpdate, dbo.TbTrspTrasportiDet.SysUserUpdate, dbo.TbTrspTrasportiDet.SysRowVersion, dbo.TbTrspTrasportiElab.NoteElab, 
                         dbo.TbTrspTrasportiDet.NFoglio, dbo.TbTrspTrasportiDet.NoteAutista, dbo.TbTrspTrasportiDet.CostoCtrlData, dbo.TbTrspTrasportiDet.CostoCtrlUser, dbo.TbTrspTrasportiDet.FlgCostoCtrl, 
                         CASE WHEN NOT (TbTrspTrasportiDetelab.ColRiga IS NULL) THEN TbTrspTrasportiDetelab.ColRiga ELSE CONVERT(nvarchar(7), CASE WHEN dbo.TbCntCondPag.FlgPagConsegna = 1 OR
                         isnull(TbTrspTrasporti.IdCondPag, '') = '' THEN '#FFFACD' ELSE NULL END) END AS ColRiga, dbo.TbTrspTrasportiDet.IdCliRitiro, dbo.TbTrspTrasportiDet.RagSocRitiro, dbo.TbTrspTrasportiDet.IdProvinciaRitiro, 
                         dbo.TbTrspTrasportiDet.IdZonaRitiro, dbo.TbTrspTrasportiDet.IdCliConsegna, dbo.TbTrspTrasportiDet.RagSocConsegna, dbo.TbTrspTrasportiDet.IdProvinciaConsegna, dbo.TbTrspTrasportiDet.IdZonaConsegna, 
                         dbo.TbTrspTrasportiDet.Km, dbo.TbTrspTrasportiDet.ImportoVltKm, dbo.TbTrspTrasportiDet.ImportoVltKmTot, dbo.TbTrspTrasportiDet.IdUteAutista, dbo.TbTrspTrasporti.Km AS KmMaster, 
                         dbo.TbTrspTrasporti.ImportoVltKm AS ImportoVltKmMaster, dbo.TbTrspTrasporti.ImportoVltKmTot AS ImportoVltKmTotMaster, dbo.TbTrspTrasporti.FlgAnnullato AS FlgAnnullatoMaster, 
                         dbo.TbTrspTrasportiDet.ColRiga AS ColRigaMaster, dbo.TbTrspTrasporti.Destinazione, dbo.TbTrspTrasportiDet.DataTrasporto, dbo.TbTrspTrasporti.ML, dbo.TbTrspTrasporti.ImportoExtra, dbo.TbTrspTrasporti.ImportoExtraNote, 
                         dbo.TbTrspTrasporti.Ore AS OreMaster, dbo.TbTrspTrasporti.ImportoVltOre AS ImportoVltOreMaster, dbo.TbTrspTrasportiDet.FlgEseguito, ISNULL(dbo.TbTrspTrasportiDet.DataTrasporto, CONVERT(date, GETDATE())) 
                         AS DataTrasportoElab, dbo.TbTrspTrasportiDet.IdUteAutista1, dbo.TbTrspTrasportiDet.FlgVibileWebC, dbo.TbTrspTrasportiDet.FlgVibileWebR, dbo.TbTrspTrasportiDet.FlgEseguitoC, dbo.TbTrspTrasportiDet.FlgEseguitoR, 
                         dbo.TbTrspTrasportiDet.FlgClonato, drvCliFat.IdCliFat, dbo.TbTrspTrasportiDet.IdRaggCliFatTrsp, dbo.TbTrspTrasportiDet.DescRaggCliFatTrsp, TbClienti_1.FlgRaggCliFatTrsp, 0 AS OrdIns, CONVERT(nvarchar(50), 
                         ISNULL(dbo.TbTrspTrasportiDet.DataTrasporto, GETDATE()), 112) + ISNULL(UPPER(dbo.TbTrspTrasportiDet.TipoTrsp), N'A') + ISNULL(dbo.TbTrspTrasporti.Destinatario, N'') AS Ord, CONVERT(nvarchar(MAX), 
                         CASE WHEN TbTrspTrasporti.IdCliente IS NULL THEN 'Cliente non codificato' WHEN FlgImportoCtrl = 0 AND isnull(ImportoVlt, 0) > 0 THEN 'Importo Verificato' WHEN TbTrspTrasporti.IdCondPag IS NULL 
                         THEN 'Attenzione non ci sono le condizioni di pagamento' ELSE NULL END) AS DescInfo, CASE WHEN NOT (TbTrspTrasportiDetELab.ColInfo IS NULL) THEN TbTrspTrasportiDetELab.ColInfo ELSE CONVERT(nvarchar(MAX), 
                         CASE WHEN TbTrspTrasporti.IdCliente IS NULL THEN '#FF0000' WHEN FlgImportoCtrl = 0 AND isnull(ImportoVlt, 0) > 0 THEN '#00FF00' WHEN TbTrspTrasporti.IdCondPag IS NULL THEN '#FFD700' ELSE NULL END) 
                         END AS ColInfo, TbClienti_1.Categoria, dbo.TbTrspTrasportiDet.IdUteAutista2, dbo.TbTrspTrasportiDet.FlgVibileWebD, dbo.TbTrspTrasportiDet.FlgEseguitoD, dbo.TbTrspTrasporti.CmpOpz01, dbo.TbTrspTrasporti.CmpOpz02, 
                         dbo.TbTrspTrasporti.CmpOpz03, dbo.TbTrspTrasporti.CmpOpz04, CONVERT(nvarchar(20), CASE WHEN RIGHT(TbTrspTrasporti.IdTrsp, 4) = 0000 AND FlgEseguito = 0 THEN 'DD' WHEN RIGHT(TbTrspTrasporti.IdTrsp, 4) 
                         <> 0000 AND FlgEseguito = 0 THEN 'AP' WHEN RIGHT(TbTrspTrasporti.IdTrsp, 4) = 0000 AND FlgEseguito = 1 THEN 'CH' ELSE '' END) AS CodFnzTipoTrsp, dbo.TbTrspTrasportiDet.IdForRitiro, 
                         dbo.TbTrspTrasportiDet.IdForConsegna, dbo.TbTrspTrasporti.IdVettore AS IdVettoreMaster, dbo.TbTrspTrasporti.RagSocVettore AS RagSocVettoreMaster, dbo.TbTrspTrasportiDet.PesoKgDet, dbo.TbTrspTrasportiDet.NColliDet, 
                         dbo.TbTrspTrasportiDet.NoteConsegna, TbTrspTrasportiDetElab.ColCampi
FROM            dbo.TbTrspTrasporti WITH (NOLOCK) INNER JOIN
                         dbo.TbTrspTrasportiDet ON dbo.TbTrspTrasporti.IdTrsp = dbo.TbTrspTrasportiDet.IdTrsp LEFT OUTER JOIN
                         dbo.TbTrspTrasportiDetELab ON dbo.TbTrspTrasportiDet.IdTrspDet = dbo.TbTrspTrasportiDetELab.IdTrspDet LEFT OUTER JOIN
                             (SELECT        IdTrsp, MAX(IdCliFat) AS IdCliFat
                               FROM            dbo.TbCliFatDet WITH (NOLOCK)
                               GROUP BY IdTrsp) AS drvCliFat ON dbo.TbTrspTrasporti.IdTrsp = drvCliFat.IdTrsp LEFT OUTER JOIN
                         dbo.TbTrspTrasportiElab WITH (NOLOCK) ON dbo.TbTrspTrasporti.IdTrsp = dbo.TbTrspTrasportiElab.IdTrsp LEFT OUTER JOIN
                         dbo.TbCntCondPag ON dbo.TbTrspTrasporti.IdCondPag = dbo.TbCntCondPag.IdCondPag LEFT OUTER JOIN
                         dbo.TbClienti AS TbClienti_1 ON dbo.TbTrspTrasporti.IdCliente = TbClienti_1.IdCliente LEFT OUTER JOIN
                         dbo.TbClienti ON dbo.TbTrspTrasporti.IdCliMittente = dbo.TbClienti.IdCliente LEFT OUTER JOIN
                         dbo.TbSpedPorto ON dbo.TbTrspTrasporti.IdPorto = dbo.TbSpedPorto.IdPorto LEFT OUTER JOIN
                         dbo.TbCntIva ON dbo.TbTrspTrasporti.IdIva = dbo.TbCntIva.IdIva LEFT OUTER JOIN
                         dbo.TbCliDest ON dbo.TbTrspTrasporti.IdCliDest = dbo.TbCliDest.IdCliDest LEFT OUTER JOIN
                         dbo.TbTrspAnagCausali ON dbo.TbTrspTrasporti.IdCausaleTrsp = dbo.TbTrspAnagCausali.IdCausaleTrsp

GO

