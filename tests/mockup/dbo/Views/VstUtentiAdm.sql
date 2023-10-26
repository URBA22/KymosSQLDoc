-- ==========================================================================================
-- Entity Name:   VstUtentiAdm
-- Author:        Dav
-- Create date:   03/11/2014
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- Custoe:	
-- Description:	
-- History
-- dav 140103 Aggiunta campi
-- dav 140120 Inseriti campi opz
-- dav 150219 Responsabile
-- dav 150225 Responsabile  bit
-- dav 150821 Aggiunto FlgSolaLettura
-- fab 150901 Aggiunti campi nuovi TbUtenti.IdRuolo, TbUtenti.IdMansione, TbUtenti.DataMansione, TbUtenti.Infortuni, TbUtenti.DataVisitaMedica, TbUtenti.FlgUsoCarrelloSollevatore, TbUtenti.DataVisitaMedicaProssima, TbUtenti.EsamiMediciPrevisti
-- fab 150921 Aggiunto EMailNome
-- fab 160025 Aggiunto FlgProduzione
-- fab 160219 Aggiunto IdCdc
-- dav 170128 Aggiunto DescRuolo
-- fab 170503 Aggiunto PowerBIToken
-- dav 170823 Aggiunto isnull su flag per individuare utenti solo aspnet
-- fab 180124 Aggiunto PswdSmtp
-- fab 190329 Aggiunto UserNameSmtp
-- dav 190728 Aggiunto sem3 con allarmi
-- simone 210518 Aggiunto Sem2
-- fab 211029 Aggiunto Flg per determinare se l'utente è stato creato
-- sim 211220 Aggiunto PrezzoOra
-- sim 220509 Aggiunto IdCdlUnita
-- sim 220614 Aggiunto IdZona, IdPaese, DescPaese
-- fab 230315 Aggiunto FlgDisabilitaMailCcn
-- sim 230719 Protezione da FlgDisabilitaMailCcn NULL, se utente non esiste ma c'è un accesso
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiAdm]
AS
SELECT
	ISNULL(dbo.TbUtenti.IdUtente, N'') + N':' + ISNULL(dbo.aspnet_Applications.ApplicationName, N'') + ':' +
	ISNULL(dbo.aspnet_Users.UserName, N'') AS IdUtenteAdm, dbo.aspnet_Applications.ApplicationName,
	ISNULL(dbo.TbUtenti.IdUtente, dbo.aspnet_Users.UserName) AS IdUtente, dbo.TbUtenti.IdSocieta,
	dbo.TbUtenti.IdGruppo, dbo.TbUtenti.DescUtente, 
			 
	case when dbo.TbUtenti.IdUtente is null then '#ERRCONF#' else dbo.TbUtenti.Cognome end as Cognome, 
	case when dbo.TbUtenti.IdUtente is null then '#ASPNET#' else dbo.TbUtenti.Nome end as Nome,
    
	dbo.TbUtenti.CognomeNome, dbo.TbUtenti.EMail, dbo.TbUtenti.EMailFirma, dbo.TbUtenti.NoteUtente,
	IsNull(dbo.TbUtenti.Disabilita, 0) as Disabilita, dbo.TbUtenti.IdReparto, dbo.TbUtenti.IdRFID,
	dbo.TbUtenti.Matricola, dbo.TbUtenti.IdTurnoDef, dbo.TbUtenti.DataInizioRapporto, dbo.TbUtenti.DataFineRapporto,
	dbo.TbUtenti.IdGruppoMenu, dbo.TbUtenti.IdLingua, IsNull(dbo.TbUtenti.FlgComm, 0) as FlgComm,
	dbo.TbUtenti.CodFnzSincroCal, dbo.TbUtenti.UserSincroCal, dbo.TbUtenti.PswSincroCal, dbo.TbUtenti.UriSincroCal,
	dbo.TbUtenti.IPFilter, dbo.TbUtenti.CostoKm, dbo.TbUtenti.CostoOra, dbo.TbUtenti.CostoOraStr,
	dbo.TbUtenti.DataCostoOra, dbo.TbUtenti.CodFnzTipoAccesso, dbo.TbUtenti.SysDateCreate, dbo.TbUtenti.SysUserCreate,
	dbo.TbUtenti.SysDateUpdate, dbo.TbUtenti.SysUserUpdate, dbo.TbUtenti.SysRowVersion, 
	
	CONVERT(nvarchar(MAX), NULL) AS Ord,  
	
	CONVERT(Smallint, case when dbo.aspnet_Users.UserName is null then 2 else 4 end  ) AS Sem1, 
	CONVERT(Smallint, case when IsNull(dbo.TbUtenti.Disabilita,0) = 0 THEN 1 ELSE 2 END ) AS Sem2, 
	CONVERT(Smallint, 0 ) AS Sem3, 
	CONVERT(smallint, CASE WHEN isnull(FlgAllert, 0) = 1 OR  dbo.TbUtenti.IdUtente is null then 3  WHEN isnull(FlgWarnings, 0) = 1 THEN 2 ELSE 1 END ) AS Sem4,
	
    dbo.TbRlvSocieta.RagSoc, dbo.TbRlvTurniDef.DescTurno, dbo.TbProdReparti.DescReparto, dbo.TbUtenti.GASecretKey,
	isNull(dbo.TbUtenti.GAFlgTwoAuthentication, 0) as GAFlgTwoAuthentication,
	IsNull(dbo.TbUtenti.FlgMaster, 0) as FlgMaster, dbo.TbUtenti.IdUtenteMaster,
	IsNull(dbo.TbUtenti.FlgDisabilitaRileva, 0) as FlgDisabilitaRileva,
	IsNull(dbo.TbUtenti.FlgAmministrazione, 0) as FlgAmministrazione, dbo.TbUtenti.Indirizzo, dbo.TbUtenti.Citta,
	dbo.TbUtenti.Cap, dbo.TbUtenti.Provincia, dbo.TbUtenti.Sesso, dbo.TbUtenti.Tel, dbo.TbUtenti.NoteTel,
	dbo.TbUtenti.Tel1, dbo.TbUtenti.NoteTel1, dbo.TbUtenti.DataNascita, dbo.TbUtenti.CodFiscale, dbo.TbUtenti.KeyExtUte,
	dbo.TbUtenti.DataModRapporto, dbo.TbUtenti.Contratto, dbo.TbUtenti.Qualifica, dbo.TbUtenti.Livello,
	IsNull(dbo.TbUtenti.FlgAssegniFam, 0) as FlgAssegniFam, dbo.TbUtenti.LuogoNascita, dbo.TbUtenti.CodFnzSindacato,
	dbo.TbUtenti.CodFnzFondoPensione, dbo.TbUtenti.IdUtenteResp,
	CONVERT(bit, ISNULL(dbo.TbUtenti.FlgResponsabile, 0)) AS FlgResponsabile,
	IsNull(TbUtenti.FlgSolaLettura, 0) as FlgSolaLettura, TbUtenti.IdRuolo, TbUtenti.IdMansione, TbUtenti.DataMansione,
	TbUtenti.Infortuni, TbUtenti.DataVisitaMedica,
	IsNull(TbUtenti.FlgUsoCarrelloSollevatore, 0) as FlgUsoCarrelloSollevatore, TbUtenti.DataVisitaMedicaProssima,
	TbUtenti.EsamiMediciPrevisti, TbUtenti.EMailNome, IsNull(TbUtenti.FlgProduzione, 0) as FlgProduzione, IdCdc,
	VstUtentiAdm_DescRole.DescRole, PowerBIToken, TbUtenti.PswdSmtp, TbUtenti.UserNameSmtp,
	CONVERT(bit, CASE WHEN dbo.AspNetUsers.LockoutEnabled IS NULL THEN 0 ELSE 1 END) AS FlgAspNetIns, TbUtenti.PrezzoOra,
	TbUtenti.IdCdlUnita, TbUtenti.IdZona, TbUtenti.IdPaese, TbPaesi.DescPaese, ISNULL(TbUtenti.FlgDisabilitaMailCcn, 0) AS FlgDisabilitaMailCcn
FROM
	dbo.TbProdReparti
		RIGHT OUTER JOIN
		dbo.TbUtenti
			ON dbo.TbProdReparti.IdReparto = dbo.TbUtenti.IdReparto
		LEFT OUTER JOIN
		dbo.TbRlvTurniDef
			ON dbo.TbUtenti.IdTurnoDef = dbo.TbRlvTurniDef.IdTurnoDef
		LEFT OUTER JOIN
		dbo.TbUtentiElab
			ON dbo.TbUtentiElab.IdUtente = dbo.TbUtenti.IdUtente
		LEFT OUTER JOIN
		dbo.TbRlvSocieta
			ON dbo.TbUtenti.IdSocieta = dbo.TbRlvSocieta.IdSocieta
		FULL OUTER JOIN
		dbo.aspnet_Applications
		INNER JOIN
		dbo.aspnet_Users
			ON dbo.aspnet_Applications.ApplicationId = dbo.aspnet_Users.ApplicationId
		INNER JOIN
		dbo.aspnet_Membership
			ON dbo.aspnet_Users.UserId = dbo.aspnet_Membership.UserId
			ON dbo.TbUtenti.IdUtente = dbo.aspnet_Users.UserName
		LEFT OUTER JOIN
		dbo.VstUtentiAdm_DescRole
			ON TbUtenti.IdUtente = VstUtentiAdm_DescRole.IdUtente
		LEFT OUTER JOIN
		dbo.AspNetUsers
			ON dbo.AspNetUsers.UserName = TbUtenti.IdUtente
        LEFT OUTER JOIN
        TbPaesi
            ON TbUtenti.IdPaese = TbPaesi.IdPaese

GO

