-- ==========================================================================================
-- Entity Name:	 VstTkt
-- Author:		 auto
-- Create date:	 230707
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- FRA 230707 Creazione
-- FRA 230724 Aggiunti RagSocCliente, FlgAccettato, GGAperta, DescPrj, ClienteFinale
-- FRA 230731 Aggiunti calcoli su ToDo Aperti, CognomeNomeContatto
-- FRA 230802 Aggiunti semafori
-- FRA 230803 Aggiunta gestione FlgChiuso
-- FRA 230808 Aggiunta Categoria al posto di Tipo
-- FRA 230810 Aggiunto IdCliPrjStato
-- FRA 230817 Ticket è considerato con semaforo template, anche se fa parte di un progetto template
-- FRA 230914 Aggiunto join con TbTktCliPrjStato per recepire stati multipli nel progetto con ticket template (compatibile con versione precedenti di SQL Server)
-- ==========================================================================================
CREATE VIEW [dbo].[VstTkt]
AS
	SELECT 
        TbTkt.IdTkt,
        TbTkt.IdTktPrm,
        TbTkt.IdTktTemplate,
        TbCliPrj.IdEsercizio AS IdEsercizio,
        TbTkt.IdCliPrj,
        TbCliPrj.DescPrj,
        TbTkt.IdArticolo,
        TbTkt.IdCliente,
        TbCliPrj.IdClienteFinale,
        drvCliFinale.RagSocCompleta AS RagSocCompletaClienteFinale,
        TbClienti.RagSocCompleta,
        TbTkt.IdCodaTkt,
        TbTkt.IdStatoTkt,
        TbTkt.IdCategoriaTkt,
        TbTkt.IdCausaleTkt,
        TbTkt.DataTkt,
        TbTkt.CodFnzPriorita,
        TbTkt.CodFnzStato,
        TbTkt.DataAccettato,
        CASE WHEN TbTkt.DataAccettato IS NULL 
            THEN 0 
            ELSE 1 
            END 
            AS FlgAccettato,
        TbTkt.DataScadenza,
        TbTkt.DataScadenzaUltima,
        TbTkt.DataChiusura,
        TbTkt.DurataPrevista,
        TbTkt.DurataComunicata,
        TbTkt.IdMail,
        TbTkt.IdModulo,
        TbTkt.Ambito,
        TbTkt.DescTkt,
        TbTkt.NoteTkt,
        TbTkt.NoteExt,
        TbTkt.NoteInt,
        TbTkt.IdContatto,
        TbTkt.IdUtente,
        TbUtenti_1.CognomeNome AS CognomeNomeUtente,
        TbUtenti_2.CognomeNome AS CognomeNomeUtenteDest,
        TbTkt.IdUtenteDest,
        TbTkt.GgWarnings,
        TbTkt.GgAlert,
        TbTkt.NoteEsito,
        TbTkt.FlgTemplate,
        TbTkt.FlgVisibilitaWeb,
        TbTkt.CmpOpz01,
        TbTkt.CmpOpz02,
        TbTkt.CmpOpz03,
        TbTkt.CmpOpz04,
        TbTkt.CmpOpz05,
        TbTkt.CmpOpz,
        TbTkt.SysDateCreate,
        TbTkt.SysUserCreate,
        TbTkt.SysDateUpdate,
        TbTkt.SysUserUpdate,
        TbTkt.SysRowVersion,
        TbTkt.FlgChiuso,
        TbTkt.IdCliPrjStato,
        DATEDIFF(DAY, TbTkt.DataTkt, ISNULL(TbTkt.DataChiusura, GETDATE())) AS GGAperta,
        drvTodo.NumTdo AS NumTdo,
        drvTodo.NumTdoAp AS NumTdoAp,
        drvTodo.NumTdo AS NumToDoTot,
        drvTodo.NumTdo - drvTodo.NumTdoAp AS NumToDoCls,
        CASE 
		WHEN ISNULL(drvTodo.NumTdo, 0) > 0
			THEN 100 - (100 * drvTodo.NumTdoAp / drvTodo.NumTdo)
		ELSE NULL
		END AS PercToDo,
        VstContatti.CognomeNome AS CognomeNomeContatto,

        -- SEMAFORI
        CONVERT(SMALLINT, CASE 
                WHEN TbTkt.FlgTemplate = 1 OR TbCliPrj.FlgTemplate = 1
                    THEN 5
                WHEN TbTkt.FlgChiuso = 1
                    THEN 4
                /*WHEN TbAttivita.DataAcquisita IS NOT NULL
                    THEN 2*/
                ELSE 1
                END) AS Sem1,
        
        CONVERT(SMALLINT, CASE 
                WHEN TbCliPrj.DataChiusura IS NOT NULL
                    THEN 3
                ELSE 1
                END) AS Sem2,

       -- Sem3 non ha senso ora per i Tkt (primarie / secondarie ha senso sui ToDo)

        CONVERT(SMALLINT, CASE 
                WHEN TbTkt.DataAccettato IS NULL
                    THEN 2
                WHEN TbTkt.DataAccettato IS NOT NULL
                    THEN 1
                ELSE 0
                END) AS Sem4,

        drvCliPrjStati.IdCliPrjStati AS IdCliPrjStati

	    FROM TbTkt


        LEFT OUTER JOIN (
        SELECT TbTktTodo.IdTkt,
            SUM(CASE 
                    WHEN TbTktTodo.FlgChiuso = 0
                        THEN 1
                    ELSE 0
                    END) AS NumTdoAp,
            COUNT(TbTktTodo.IdTodo) AS NumTdo
        FROM TbTktTodo
        GROUP BY TbTktTodo.IdTkt
        ) drvTodo
        ON drvTodo.IdTkt = TbTkt.IdTkt

    LEFT OUTER JOIN TbClienti ON TbClienti.IdCliente = TbTkt.IdCliente
    LEFT OUTER JOIN TbUtenti AS TbUtenti_1 ON TbUtenti_1.IdUtente = TbTkt.IdUtente
    LEFT OUTER JOIN TbUtenti AS TbUtenti_2 ON TbUtenti_2.IdUtente = TbTkt.IdUtenteDest
    LEFT OUTER JOIN TbCliPrj ON TbCliPrj.IdCliPrj = TbTkt.IdCliPrj
    LEFT OUTER JOIN (
        SELECT TbCliPrj.IdClienteFinale, TbCliPrj.IdCliPrj, VstClienti.RagSocCompleta FROM TbCliPrj 
        INNER JOIN VstClienti ON TbCliPrj.IdClienteFinale = VstClienti.IdCliente
    ) as drvCliFinale ON drvCliFinale.IdCliPrj = TbCliPrj.IdCliPrj
    LEFT OUTER JOIN VstContatti ON VstContatti.IdContatto = TbTkt.IdContatto
    LEFT OUTER JOIN (
        /*§§V05-16
        SELECT IdTkt AS IdTkt,
        IdCliPrjStati = LEFT(REPLACE(Substring((
			SELECT ';' + IdCliPrjStato AS [data()]
			FROM TbTktCliPrjStato
            WHERE TbTkt.IdTkt = TbTktCliPrjStato.IdTkt
			GROUP BY IdTkt, IdCliPrjStato
			ORDER BY IdCliPrjStato
			FOR XML PATH('')
		), 2, 200), ' ', ''), 200)
        FROM TbTkt
		§§V05-16*/
		--/*§§V17-99
        SELECT 
            IdTkt AS IdTkt,
            STRING_AGG(CONVERT(NVARCHAR(MAX), IdCliPrjStato), ';') AS IdCliPrjStati
        FROM TbTktCliPrjStato
        GROUP BY IdTkt
    --§§V17-99*/
	) drvCliPrjStati 
    ON drvCliPrjStati.IdTkt = TbTkt.IdTkt
    
    
    --TbTktCliPrjStato ON VstTkt.IdTkt = TbTktCliPrjStato.IdTkt

GO

