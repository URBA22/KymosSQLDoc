



--History:
-- MIK 210416: Aggiunto campi TbTrspAnagCausali.IdCausaleFat e TbCliAnagFatCausali.PrefDoc
--				Indicazioni di Dav: ##aggiungere in vista TbTrspAnagCausali.IdCausaleFat, TbCliAnagFatCausali.PrefDoc
--				Aggiunto Cambio
--				Aggiunto NoteCliFat e EMailFattura
--				Aggiunbto TrspDescrizioneDiritti e TrspImportoDiritti
CREATE VIEW [dbo].[VstTrspTrasportiCliFat]
AS
	SELECT        dbo.TbTrspTrasporti.IdTrsp, dbo.TbTrspTrasporti.IdCliente, dbo.TbTrspTrasporti.IdValuta, dbo.TbTrspTrasporti.FlgAnnullato, dbo.TbTrspTrasporti.ImportoCtrlData, dbo.TbTrspTrasporti.ImportoVlt, 
	dbo.TbTrspTrasporti.FlgBloccoFat, dbo.TbTrspTrasporti.IdCausaleTrsp, dbo.TbTrspTrasporti.IdIva, dbo.TbClienti.RagSoc, dbo.TbClienti.IdCondPag, ISNULL(drvTrspDetMin.NumTrsp, 0) AS NumTrsp, 
	drvTrspDetMin.FlgBloccoFatDet, drvTrspDetMin.IdTrspDet, drvTrspDet.Descrizione, drvTrspDet.DataTrasporto, drvTrspDet.IdRaggCliFatTrsp, drvTrspDet.TipoTrsp, drvTrspFat.IdCliFat,
	DrvCausali.IdCausaleFat, DrvCausali.PrefDoc, VstCntValuteCambiAttuali.Cambio, TbClienti.NoteCliFat, TbClienti.EMailFattura, (CASE WHEN DrvDiritti.IdTrsp IS NULL THEN 0 ELSE 1 END) as FlgDiritti, DrvDiritti.TrspDescrizioneDiritti, DrvDiritti.TrspImportoDiritti
	
	FROM            dbo.TbTrspTrasporti LEFT OUTER JOIN
	dbo.TbClienti ON dbo.TbTrspTrasporti.IdCliente = dbo.TbClienti.IdCliente LEFT OUTER JOIN
	
	(SELECT        IdTrsp, MIN(IdCliFat) AS IdCliFat
	FROM            dbo.TbCliFatDet
	GROUP BY IdTrsp) AS drvTrspFat ON dbo.TbTrspTrasporti.IdTrsp = drvTrspFat.IdTrsp LEFT OUTER JOIN
	
	(SELECT        IdTrsp, SUM(CASE WHEN FlgBloccoFat = 0 THEN 1 ELSE 0 END) AS NumTrsp, MIN(CONVERT(int, FlgBloccoFat)) AS FlgBloccoFatDet, 
	MAX(CASE WHEN FlgBloccoFat = 0 THEN IdTrspDet ELSE - 1 END) AS IdTrspDet
	FROM            dbo.TbTrspTrasportiDet
	GROUP BY IdTrsp) AS drvTrspDetMin ON dbo.TbTrspTrasporti.IdTrsp = drvTrspDetMin.IdTrsp LEFT OUTER JOIN

	(SELECT        
	
		TbTrspTrasportiDet_1.TipoTrsp, 
		TbTrspTrasportiDet_1.IdTrspDet, 
		TbTrspTrasportiDet_1.DataTrasporto, 
		TbTrspTrasportiDet_1.IdRaggCliFatTrsp, 
		TbTrspTrasportiDet_1.IdTrsp,
		ISNULL(dbo.TbTrspAnagCausali.DescCausaleTrsp, N'') + ' ' + 
		RTRIM(LTRIM('Mitt: ' + CASE WHEN ISNULL(TbClienti_2.RagSoc, '') = '' THEN RagSocRitiro ELSE ISNULL(TbClienti_2.RagSoc, '') + ' ' + 
		ISNULL(TbClienti_2.Citta, '') END)) + ' ' + 
		RTRIM('Dest.: ' + ISNULL(TbTrspTrasportiDet_1.RagSocConsegna, N'')) + ' (' + ISNULL(TbTrspTrasportiDet_1.IdProvinciaConsegna, N'') 
                                                         + ')'  + CHAR(13) + 
		ISNULL(TbTrspTrasporti_1.DescFattura, N'') + ' ' + 
		CASE WHEN ISNULL(TbTrspTrasporti_1.PesoKg, 0) <> 0 THEN 'Kg:' + ' ' + CONVERT(nvarchar(MAX), PesoKg)  ELSE '' END + ' ' + 
		CASE WHEN ISNULL(TbTrspTrasporti_1.MC, 0) <> 0 THEN 'MC:' + ' ' + CONVERT(nvarchar(MAX), MC) ELSE '' END + ' ' + 
		CASE WHEN ISNULL(TbTrspTrasporti_1.NColli, 0) <> 0 THEN 'Colli:' + ' ' + 
		CONVERT(nvarchar(MAX), NColli) ELSE '' END AS Descrizione
		
	FROM            dbo.TbTrspTrasportiDet AS TbTrspTrasportiDet_1 INNER JOIN
	dbo.TbTrspTrasporti AS TbTrspTrasporti_1 ON TbTrspTrasportiDet_1.IdTrsp = TbTrspTrasporti_1.IdTrsp LEFT OUTER JOIN
	dbo.TbClienti AS TbClienti_2 ON TbTrspTrasportiDet_1.IdCliRitiro = TbClienti_2.IdCliente LEFT OUTER JOIN
	dbo.TbClienti AS TbClienti_1 ON TbTrspTrasportiDet_1.IdCliConsegna = TbClienti_1.IdCliente LEFT OUTER JOIN
	dbo.TbTrspAnagCausali ON TbTrspTrasporti_1.IdCausaleTrsp = dbo.TbTrspAnagCausali.IdCausaleTrsp 
	
	WHERE        (TbTrspTrasportiDet_1.FlgBloccoFat = 0)) AS drvTrspDet ON drvTrspDet.IdTrspDet = drvTrspDetMin.IdTrspDet
	LEFT OUTER JOIN
	(
		SELECT   IdTrsp,   TbTrspAnagCausali.IdCausaleFat, TbCliAnagFatCausali.PrefDoc
		FROM         TbTrspTrasporti INNER JOIN
		TbTrspAnagCausali ON TbTrspTrasporti.IdCausaleTrsp = TbTrspAnagCausali.IdCausaleTrsp INNER JOIN
		TbCliAnagFatCausali ON TbTrspAnagCausali.IdCausaleFat = TbCliAnagFatCausali.IdCausaleFat
	) as DrvCausali
	ON TbTrspTrasporti.IdTrsp = DrvCausali.IdTrsp

	LEFT OUTER JOIN 
	VstCntValuteCambiAttuali ON TbTrspTrasporti.IdValuta = VstCntValuteCambiAttuali.IdValuta
	LEFT OUTER JOIN
	(
		SELECT IdTrsp, TrspDescrizioneDiritti, TrspImportoDiritti
		FROM TbTrspTrasporti INNER JOIN
		TbClienti ON TbTrspTrasporti.IdCliente = TbClienti.IdCliente INNER JOIN
		TbTrspAnagCausali ON TbTrspTrasporti.IdCausaleTrsp = TbTrspAnagCausali.IdCausaleTrsp
		WHERE (TbClienti.TrspImportoDiritti > 0) AND (TbTrspAnagCausali.FlgAdeguamento = 1)
	) as DrvDiritti
	ON TbTrspTrasporti.IdTrsp = DrvDiritti.IdTrsp

GO

