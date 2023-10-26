
-- ==========================================================================================
-- Entity Name:   VstUtenti
-- Author:        
-- Create date:   
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 27.10.14  inserito luogonascita
-- dav 20.11.14  inseriti campi opz
-- dav 19.02.15  responsabile
-- fab 21.09.16  EMailNome
-- fab 25.10.16	 FlgProduzione
-- fab 02.12.16	 DescMansione
-- fab 19.12.16	 Aggiunto IdCdc
-- fab 03.05.17	 aggiunto PowerBIToken
-- fab 24.01.18	 aggiunto PswdSmtp
-- fab 29.03.19	 aggiunto UserNameSmtp
-- dav 211225 DescUtenteElab
-- dav 211030 Gestione FlgAccesso
-- dav 211030 Semafori e nuova gesitone accesso
-- dav 211105 Gestione DescUtenteElab da tabella
-- sim 211220 Aggiunto PrezzoOra
-- sim 220420 Aggiunto IdCdlUnita
-- dav 220430 Gestione DescRuolo
-- sim 220614 Aggiunto IdZona, IdPaese, DescPaese
-- fab 230315 Aggiunto FlgDisabilitaMailCcn
-- dav 230316 Aggiunto UteAcronimo
-- fab 230317 Corretto errore di conversione
-- dav 230419 Corretto UteAcronimo
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtenti]
AS
SELECT TbUtenti.IdUtente,
	TbUtenti.IdSocieta,
	TbUtenti.IdGruppo,
	TbUtenti.DescUtente,
	TbUtenti.Cognome,
	TbUtenti.Nome,
	TbUtenti.CognomeNome,
	TbUtenti.EMail,
	TbUtenti.EMailFirma,
	TbUtenti.NoteUtente,
	TbUtenti.Disabilita,
	TbUtenti.IdReparto,
	TbUtenti.IdRFID,
	TbUtenti.Matricola,
	TbUtenti.IdTurnoDef,
	TbUtenti.DataInizioRapporto,
	TbUtenti.DataFineRapporto,
	TbUtenti.IdGruppoMenu,
	TbUtenti.SysDateCreate,
	TbUtenti.SysUserCreate,
	TbUtenti.SysDateUpdate,
	TbUtenti.SysUserUpdate,
	TbUtenti.SysRowVersion,
	TbUtenti.IdLingua,
	TbUtenti.FlgComm,
	TbUtenti.CodFnzSincroCal,
	TbUtenti.UserSincroCal,
	TbUtenti.PswSincroCal,
	TbUtenti.UriSincroCal,
	TbUtenti.IPFilter,
	TbProdReparti.DescReparto,
	TbRlvTurniDef.DescTurno,
	TbRlvSocieta.RagSoc,
	TbUtenti.CostoKm,
	TbUtenti.CostoOra,
	TbUtenti.CostoOraStr,
	TbUtenti.DataCostoOra,
	TbUtenti.CodFnzTipoAccesso,
	TbUtenti.GASecretKey,
	TbUtenti.GAFlgTwoAuthentication,
	TbUtenti.FlgMaster,
	TbUtenti.IdUtenteMaster,
	TbUtenti.FlgDisabilitaRileva,
	TbUtenti.FlgAmministrazione,
	TbUtenti.Indirizzo,
	TbUtenti.Citta,
	TbUtenti.Cap,
	TbUtenti.Provincia,
	TbUtenti.Sesso,
	TbUtenti.Tel,
	TbUtenti.NoteTel,
	TbUtenti.Tel1,
	TbUtenti.NoteTel1,
	TbUtenti.DataNascita,
	TbUtenti.CodFiscale,
	TbUtenti.KeyExtUte,
	TbUtenti.DataModRapporto,
	TbUtenti.Contratto,
	TbUtenti.Qualifica,
	TbUtenti.Livello,
	TbUtenti.FlgAssegniFam,
	TbUtenti.LuogoNascita,
	TbUtenti.CodFnzSindacato,
	TbUtenti.CodFnzFondoPensione,
	CONVERT(SMALLINT, CASE 
			WHEN AspNetUsers.UserName IS NULL
				THEN 1
			ELSE 4
			END) AS Sem1,
	CONVERT(SMALLINT, CASE 
			WHEN IsNull(dbo.TbUtenti.Disabilita, 0) = 0
				THEN 1
			ELSE 2
			END) AS Sem2,
	CONVERT(SMALLINT, 0) AS Sem3,
	CONVERT(SMALLINT, CASE 
			WHEN isnull(TbUtentiElab.FlgAllert, 0) = 1
				THEN 3
			WHEN isnull(TbUtentiElab.FlgWarnings, 0) = 1
				THEN 2
			ELSE 1
			END) AS Sem4,
	CONVERT(NVARCHAR(MAX), NULL) AS Ord,
	CASE 
		WHEN AspNetUsers.UserName IS NULL
			THEN NULL
		ELSE dbo.FncAdmDhColor('BLUE')
		END AS ColRiga,
	TbUtenti.IdUtenteResp,
	TbUtenti.FlgResponsabile,
	TbUtenti.FlgSolaLettura,
	TbUtenti.IdRuolo,
	TbUtenti.IdMansione,
	TbUtenti.DataMansione,
	TbUtenti.Infortuni,
	TbUtenti.DataVisitaMedica,
	TbUtenti.FlgUsoCarrelloSollevatore,
	TbUtenti.DataVisitaMedicaProssima,
	TbUtenti.EsamiMediciPrevisti,
	TbUtenti.EMailNome,
	TbUtenti.FlgProduzione,
	DescMansione,
	IdCdc,
	PowerBIToken,
	TbUtenti.PswdSmtp,
	TbUtenti.UserNameSmtp,
	CONVERT(BIT, CASE 
			WHEN AspNetUsers.UserName IS NULL
				THEN 0
			ELSE 1
			END) AS FlgAccesso,
	TbUtenti.DescUtenteElab,
	TbUtenti.PrezzoOra,
	TbUtenti.IdCdlUnita,
	drvRuolli.DescRuolo,
	TbUtenti.IdZona,
	TbUtenti.IdPaese,
	TbPaesi.DescPaese,
	TbUtenti.FlgDisabilitaMailCcn,
    CONVERT(nvarchar(50), COALESCE (LEFT(TbUtenti.DescUtente,50), ISNULL((LEFT(TbUtenti.Cognome,1) + LEFT(TbUtenti.Nome,1)),''))) as UteAcronimo
FROM TbUtenti
LEFT OUTER JOIN TbUtentiElab
	ON TbUtentiElab.IdUtente = TbUtenti.IdUtente
LEFT OUTER JOIN TbRlvSocieta
	ON TbUtenti.IdSocieta = TbRlvSocieta.IdSocieta
LEFT OUTER JOIN TbRlvTurniDef
	ON TbUtenti.IdTurnoDef = TbRlvTurniDef.IdTurnoDef
LEFT OUTER JOIN TbProdReparti
	ON TbUtenti.IdReparto = TbProdReparti.IdReparto
LEFT OUTER JOIN TbUtentiAnagMansioni
	ON TbUtenti.IdMansione = TbUtentiAnagMansioni.IdMansione
LEFT OUTER JOIN dbo.AspNetUsers AspNetUsers
	ON TbUtenti.IdUtente = AspNetUsers.UserName
LEFT OUTER JOIN (
	SELECT t1.IdUtente,
		LEFT(REPLACE(Substring((
						SELECT '#' + IdRuolo AS [data()]
						FROM TbUtentiRuoli t2
						WHERE t2.IdUtente = t1.IdUtente
							AND (
								t2.DataRuoloDa IS NULL
								OR t2.DataRuoloDa < GETDATE()
								)
							AND (
								t2.DataRuoloA IS NULL
								OR t2.DataRuoloA >= GETDATE()
								)
						GROUP BY IdRuolo
						ORDER BY IdRuolo
						FOR XML PATH('')
						), 2, 200), '#', ' '), 200) AS DescRuolo
	FROM TbUtenti t1
	) drvRuolli
	ON drvRuolli.IdUtente = TbUtenti.IdUtente
LEFT OUTER JOIN TbPaesi
	ON TbUtenti.IdPaese = TbPaesi.IdPaese

GO

