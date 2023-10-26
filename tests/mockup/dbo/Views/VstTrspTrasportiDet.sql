



        
-- ==========================================================================================
-- Entity Name:   VstTrspTrasportiDet
-- Author:        dav
-- Create date:   160519
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- fab  19.05.16	aggiunto FlgEseguito
-- vale 06.06.16 aggiunta DataTrasportoElab
-- vale 12.10.16 messo priorita di dettaglio
-- vale 20.10.16 messo campi in più per pizeta
-- fab  29.10.16 messo UpperCase su TipoTrsp
-- vale 06.11.16 aggiunta campi raggruppamento e sistemazione filtri,  colore riga
-- fab	25.11.16 aggiunta campo Categoria
-- dav  30.12.16 nolock e modifica fatturato (ottimizzazione)
-- fab	11.01.17 aggiunti IdUteAutista2, FlgEseguitoD, FlgVisibileWebD
-- vale 25.02.17 standard pz
-- dav  15.04.17 nolock su elab
-- dav  25.04.17 correzione sem1
-- dav  27.04.17 standardizazione sem4
-- vale 03.05.17 messo anche controllo sul colore pagamento nullo o a consegna 
-- vale 28.07.17 protezione dagli spazi e non solo nulli cond pag
-- vale 07.03.19 messo CodFnzStatoTipoTrsp per controllo filtro trasporti 
-- fab	21.03.19 Aggiunto NColliDet e PesoKgDet
-- fab	25.03.19 sistemato CodFnzStatoTipoTrsp
-- fab	25.03.19 Aggiunto  NoteConsegna
-- fab	28.06.19 aggiunto ColCampi esempio: N'<fileds>' + N'<field name="IdProvinciaRitiro" style="color: ' + CASE WHEN ISNULL(IdProvinciaRitiro, '')  <> 'AN' THEN '#1E90FF' ELSE '' END + N';"/>' + N'<field name="RagSocRitiro" style="color: ' + CASE WHEN ISNULL(IdProvinciaRitiro, '') <> 'AN' THEN '#1E90FF' ELSE '' END + N';"/>' + N'</fileds>'
-- vale 200624 cambio colore controllo pagamenti
-- vale 201013 Aggiunta Tracking
-- dav 220326 Gestione IdCliFat su elab
-- ==========================================================================================

CREATE VIEW [dbo].[VstTrspTrasportiDet]
AS
				SELECT TbTrspTrasportiDet.IdTrspDet, TbTrspTrasporti.IdTrsp, 
				
				CASE WHEN TbTrspTrasportiElab.IdCliFat IS NULL THEN 0 ELSE 1 END AS FlgTrspFatturato, 
				
				TbTrspTrasporti.DataPrenotazione, TbTrspTrasporti.IdCausaleTrsp, 
				TbTrspTrasporti.IdCliente, TbTrspTrasporti.Destinatario, TbTrspTrasporti.IdCliDest, TbTrspTrasporti.IdProvinciaDestinazione, TbTrspTrasporti.IdZonaDestinazione, TbTrspTrasporti.IdCliMittente, TbTrspTrasporti.Mittente, 
				TbTrspTrasporti.IdProvinciaMittente, TbTrspTrasporti.IdZonaMittente, TbTrspTrasporti.DescMerce, TbTrspTrasporti.NoteTrsp, TbTrspTrasporti.PesoKg, TbTrspTrasporti.NColli, TbTrspTrasporti.NPallet, TbTrspTrasporti.MC, 
				TbTrspTrasporti.IdIva, TbTrspTrasporti.IdPorto, TbTrspTrasportiDet.FlgBloccoFat, TbTrspTrasporti.DescFattura, TbTrspTrasporti.IdValuta, TbTrspTrasporti.Cambio, TbTrspTrasporti.IdLingua, TbTrspTrasporti.ImportoVlt, 
				TbTrspTrasporti.Sconto, TbTrspTrasporti.Sconto1, TbTrspTrasporti.Sconto2, TbTrspTrasporti.Sconto3, TbTrspTrasporti.ImportoTotVlt, TbTrspTrasporti.BlocDoc, TbTrspTrasporti.IdCondPag, TbTrspTrasporti.CodFnzStato, 
				TbTrspTrasporti.ImportoTot, TbTrspTrasporti.FlgAssicurato, TbTrspTrasporti.FlgContrassegno, TbTrspTrasporti.FlgSpondaIdraulica, TbTrspTrasportiDet.FlgAnnullato, TbTrspTrasporti.FlgCompensazione, 
				TbTrspTrasporti.ImportoAssicurato, TbTrspTrasporti.ImportoContrassegno, TbTrspTrasportiDet.Priorita, TbTrspAnagCausali.DescCausaleTrsp, TbTrspAnagCausali.FlgAdeguamento, TbClienti_1.RagSoc, TbCliDest.DescDest, 
				TbClienti.RagSoc AS RagSocMittente, TbCntIva.DescIva, TbCntIva.Aliquota, TbSpedPorto.DescPorto, TbCntCondPag.DescPag, TbTrspTrasporti.FlgNoDdt, TbClienti_1.Disabilita, TbTrspTrasporti.MittenteOrigine, 
				TbTrspTrasporti.DimH, TbTrspTrasporti.DimL, TbTrspTrasporti.DimP, TbTrspTrasporti.UnitM, TbTrspTrasporti.IdListino, TbTrspTrasporti.NoteCalcolo, TbTrspTrasporti.ImportoVltCalcolato, TbTrspTrasporti.DataCalcolo, 
				TbTrspTrasporti.QtaEquivalente, TbTrspTrasporti.ImportoCtrlData, TbTrspTrasporti.ImportoCtrlNote, TbTrspTrasporti.ImportoCtrlUser, TbTrspTrasporti.FlgImportoCtrl, TbTrspTrasporti.FlgMerceSede, 
				TbTrspTrasportiElab.FlgWarnings, TbTrspTrasportiElab.FlgAllert, TbTrspTrasportiElab.AllertDesc, TbTrspTrasportiElab.WarningsDesc, TbTrspTrasportiElab.FlgMerceSedeSped, 
				
				CONVERT(smallint, 
							CASE WHEN ImportoCtrlData IS NOT NULL AND ImportoVlt IS NOT NULL AND TbTrspTrasportiDet.FlgBloccoFat = 0 AND TbTrspTrasporti.FlgBloccoFat = 0 THEN 1 
								 WHEN ImportoCtrlData IS NOT NULL AND ImportoVlt IS NOT NULL AND (TbTrspTrasportiDet.FlgBloccoFat = 1 OR TbTrspTrasporti.FlgBloccoFat = 1) THEN 2 
								 WHEN TbTrspTrasportiDet.FlgBloccoFat = 0 AND TbTrspTrasporti.FlgBloccoFat = 0 THEN 4 
								 ELSE NULL END) AS Sem1, 
				
				CONVERT(smallint, 
							CASE WHEN TbTrspTrasportiElab.IdCliFat IS NOT NULL THEN 1 WHEN TbTrspTrasportiDet.FlgBloccoFat = 0 THEN 4 
								 ELSE 0 END) AS Sem2, 
							
				CONVERT(smallint, 
							CASE WHEN TbTrspTrasportiDet.IdUteAutista IS NULL AND ISNULL(TipoTrsp, '--') <> 'R' THEN 2 
								 WHEN TbTrspTrasportiDet.IdUteAutista1 IS NULL THEN 3 
								 ELSE 0 END) AS Sem3, 
							
				CONVERT(smallint, 
							CASE WHEN TbTrspTrasporti.IdCondPag IS NULL THEN 3 
								 WHEN dbo.TbCntCondPag.FlgPagConsegna = 1 THEN 2 
								 ELSE 1 END) AS Sem4, 
				
				UPPER(TbTrspTrasportiDet.TipoTrsp) AS TipoTrsp, TbTrspTrasportiDet.IdMezzo, TbTrspTrasportiDet.NoteTrspDet, 
				TbTrspTrasportiDet.CostoVettore, TbTrspTrasportiDet.NoteVettore, TbTrspTrasportiDet.IdVettore, TbTrspTrasportiDet.RagSocVettore, TbTrspTrasportiDet.NFatVettore, TbTrspTrasportiDet.SysDateCreate, 
				TbTrspTrasportiDet.SysUserCreate, TbTrspTrasportiDet.SysDateUpdate, TbTrspTrasportiDet.SysUserUpdate, TbTrspTrasportiDet.SysRowVersion, TbTrspTrasportiElab.NoteElab, TbTrspTrasportiDet.NFoglio, 
				TbTrspTrasportiDet.NoteAutista, TbTrspTrasportiDet.CostoCtrlData, TbTrspTrasportiDet.CostoCtrlUser, TbTrspTrasportiDet.FlgCostoCtrl, CASE WHEN NOT (TbTrspTrasportiDetElab.ColRiga IS NULL) 
				THEN TbTrspTrasportiDetElab.ColRiga ELSE CONVERT(nvarchar(7), CASE WHEN dbo.TbCntCondPag.FlgPagConsegna = 1 OR
				isnull(TbTrspTrasporti.IdCondPag, '') = '' THEN '#DCDCDC' ELSE NULL END) END AS ColRiga, TbTrspTrasportiDet.IdCliRitiro, TbTrspTrasportiDet.RagSocRitiro, TbTrspTrasportiDet.IdProvinciaRitiro, 
				TbTrspTrasportiDet.IdZonaRitiro, TbTrspTrasportiDet.IdCliConsegna, TbTrspTrasportiDet.RagSocConsegna, TbTrspTrasportiDet.IdProvinciaConsegna, TbTrspTrasportiDet.IdZonaConsegna, TbTrspTrasportiDet.Km, 
				TbTrspTrasportiDet.ImportoVltKm, TbTrspTrasportiDet.ImportoVltKmTot, TbTrspTrasportiDet.IdUteAutista, TbTrspTrasporti.Km AS KmMaster, TbTrspTrasporti.ImportoVltKm AS ImportoVltKmMaster, 
				TbTrspTrasporti.ImportoVltKmTot AS ImportoVltKmTotMaster, TbTrspTrasporti.FlgAnnullato AS FlgAnnullatoMaster, TbTrspTrasportiDet.ColRiga AS ColRigaMaster, TbTrspTrasporti.Destinazione, 
				TbTrspTrasportiDet.DataTrasporto, TbTrspTrasporti.ML, TbTrspTrasporti.ImportoExtra, TbTrspTrasporti.ImportoExtraNote, TbTrspTrasporti.Ore AS OreMaster, TbTrspTrasporti.ImportoVltOre AS ImportoVltOreMaster, 
				TbTrspTrasportiDet.FlgEseguito, ISNULL(TbTrspTrasportiDet.DataTrasporto, CONVERT(date, GETDATE())) AS DataTrasportoElab, TbTrspTrasportiDet.IdUteAutista1, TbTrspTrasportiDet.FlgVibileWebC, 
				TbTrspTrasportiDet.FlgVibileWebR, TbTrspTrasportiDet.FlgEseguitoC, TbTrspTrasportiDet.FlgEseguitoR, TbTrspTrasportiDet.FlgClonato, 
				--drvCliFat.IdCliFat, 
				TbTrspTrasportiElab.IdCliFat,
				TbTrspTrasportiDet.IdRaggCliFatTrsp, 
				TbTrspTrasportiDet.DescRaggCliFatTrsp, TbClienti_1.FlgRaggCliFatTrsp, 0 AS OrdIns, CONVERT(nvarchar(50), ISNULL(TbTrspTrasportiDet.DataTrasporto, GETDATE()), 112) + ISNULL(UPPER(TbTrspTrasportiDet.TipoTrsp), N'A') 
				+ ISNULL(TbTrspTrasporti.Destinatario, N'') AS Ord, CONVERT(nvarchar(MAX), CASE WHEN TbTrspTrasporti.IdCliente IS NULL THEN 'Cliente non codificato' WHEN FlgImportoCtrl = 0 AND isnull(ImportoVlt, 0) 
				> 0 THEN 'Importo Verificato' WHEN TbTrspTrasporti.IdCondPag IS NULL THEN 'Attenzione non ci sono le condizioni di pagamento' ELSE NULL END) AS DescInfo, 
						 
						 
				CASE WHEN NOT (TbTrspTrasportiDetElab.ColInfo IS NULL) 
				THEN TbTrspTrasportiDetElab.ColInfo ELSE CONVERT(nvarchar(MAX),
						 
				CASE WHEN TbTrspTrasporti.IdCliente IS NULL THEN '#FF0000' WHEN FlgImportoCtrl = 0 AND isnull(ImportoVlt, 0) 
				> 0 THEN '#00FF00' WHEN TbTrspTrasporti.IdCondPag IS NULL THEN '#FFD700'
				when (len(TbClienti_1.TipoListino)>2)  then '#0000CD'
						 
				ELSE NULL END) END AS ColInfo,
						 
				TbClienti_1.Categoria, TbTrspTrasportiDet.IdUteAutista2, TbTrspTrasportiDet.FlgVibileWebD, 
				TbTrspTrasportiDet.FlgEseguitoD, TbTrspTrasporti.CmpOpz01, TbTrspTrasporti.CmpOpz02, TbTrspTrasporti.CmpOpz03, TbTrspTrasporti.CmpOpz04, CONVERT(nvarchar(20), CASE WHEN RIGHT(TbTrspTrasporti.IdTrsp, 4) 
				= 0000 AND FlgEseguito = 0 THEN 'DD' WHEN RIGHT(TbTrspTrasporti.IdTrsp, 4) <> 0000 AND FlgEseguito = 0 THEN 'AP' WHEN RIGHT(TbTrspTrasporti.IdTrsp, 4) = 0000 AND 
				FlgEseguito = 1 THEN 'CS' ELSE NULL END) AS CodFnzTipoTrsp, TbTrspTrasportiDet.IdForRitiro, TbTrspTrasportiDet.IdForConsegna, TbTrspTrasporti.IdVettore AS IdVettoreMaster, TbTrspTrasporti.RagSocVettore AS RagSocVettoreMaster,
				PesoKgDet, NColliDet, TbTrspTrasportiDet.NoteConsegna, TbTrspTrasportiDetElab.ColCampi,
				dbo.TbTrspTrasportiDet.FlgTrspPremium, NULL AS ColNav,
				case when TbClienti.TipoListino ='PLT' then 1 else 0 end as FlgVisInsPlt, dbo.TbTrspTrasportiDet.FlgTrspEconomy ,
				TbTrspTrasportiDet.Tracking 
			
				FROM            TbTrspTrasporti WITH (NOLOCK) INNER JOIN
				TbTrspTrasportiDet ON TbTrspTrasporti.IdTrsp = TbTrspTrasportiDet.IdTrsp LEFT OUTER JOIN
				TbTrspTrasportiDetElab ON TbTrspTrasportiDet.IdTrspDet = TbTrspTrasportiDetElab.IdTrspDet LEFT OUTER JOIN
				--(
				--	SELECT IdTrsp, MAX(IdCliFat) AS IdCliFat
				--	FROM TbCliFatDet WITH (NOLOCK)
				--	GROUP BY IdTrsp
				--) AS drvCliFat ON TbTrspTrasporti.IdTrsp = drvCliFat.IdTrsp LEFT OUTER JOIN
				TbTrspTrasportiElab WITH (NOLOCK) ON TbTrspTrasporti.IdTrsp = TbTrspTrasportiElab.IdTrsp LEFT OUTER JOIN
				TbCntCondPag ON TbTrspTrasporti.IdCondPag = TbCntCondPag.IdCondPag LEFT OUTER JOIN
				TbClienti AS TbClienti_1 ON TbTrspTrasporti.IdCliente = TbClienti_1.IdCliente LEFT OUTER JOIN
				TbClienti ON TbTrspTrasporti.IdCliMittente = TbClienti.IdCliente LEFT OUTER JOIN
				TbSpedPorto ON TbTrspTrasporti.IdPorto = TbSpedPorto.IdPorto LEFT OUTER JOIN
				TbCntIva ON TbTrspTrasporti.IdIva = TbCntIva.IdIva LEFT OUTER JOIN
				TbCliDest ON TbTrspTrasporti.IdCliDest = TbCliDest.IdCliDest LEFT OUTER JOIN
				TbTrspAnagCausali ON TbTrspTrasporti.IdCausaleTrsp = TbTrspAnagCausali.IdCausaleTrsp

GO

