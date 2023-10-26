-- ==========================================================================================
-- Entity Name:	 VstTktTodo
-- Author:		 auto
-- Create date:	 230707
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230707 Creazione
-- FRA 230726 Aggiunto GGAperta e altri campi del ticket
-- FRA 230802 Aggiunti semafori
-- FRA 230803 Aggiunto FlgChiuso e IdEsercizio
-- FRA 230808 Modficato IdCliPrjTkt in IdCliPrj
-- FRA 230811 Aggiunta coda ticket per cruscotto
-- FRA 230817 Todo è considerato con semaforo template, anche se fa parte di un progetto template
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktTodo]
AS
	SELECT 
    TbTktTodo.IdTodo, 
    TbTktTodo.IdTodoTemplate, 
    TbTktTodo.IdTkt, 
    TbTktTodo.NFase, 
    TbTktTodo.DataTodo, 
    TbTktTodo.IdArticolo, 
    TbTktTodo.IdTipoTodo, 
    TbTktTodo.DescTodo, 
    TbTktTodo.NoteTodo, 
    TbTktTodo.CodFnzStato, 
    TbTktTodo.CodFnzLuogo, 
    TbTktTodo.CodFnzPriorita, 
    TbTktTodo.IdUtente, 
    TbTktTodo.IdUtenteExec, 
    TbTktTodo.DataAccettato, 
    TbTktTodo.DataProgrammata,
    TbTktTodo.DataScadenza,
    TbTktTodo.DataScadenzaUltima,
    TbTktTodo.DataChiusura,
    TbTktTodo.DurataPrevista,
    TbTktTodo.NoteEsito,
    TbTktTodo.Disabilita,
    TbTktTodo.FlgO365,
    TbTktTodo.CmpOpz01,
    TbTktTodo.CmpOpz02,
    TbTktTodo.CmpOpz03,
    TbTktTodo.CmpOpz04,
    TbTktTodo.CmpOpz05,
    TbTktTodo.CmpOpz,
    TbTktTodo.SysDateCreate,
    TbTktTodo.SysUserCreate,
    TbTktTodo.SysDateUpdate,
    TbTktTodo.SysUserUpdate,
    TbTktTodo.SysRowVersion,
    TbTktTodo.FlgChiuso,
    DATEDIFF(DAY, TbTktTodo.DataTodo, ISNULL(TbTktTodo.DataChiusura, GETDATE())) AS GGAperta,
    CASE WHEN TbTktTodo.DataAccettato IS NULL 
        THEN 0 
        ELSE 1 
        END 
        AS FlgAccettato,
    VstTkt.IdCliPrj AS IdCliPrj,
    VstTkt.DescPrj AS DescPrj,
    VstTkt.DescTkt AS DescTkt,
    VstTkt.RagSocCompleta AS RagSocCompletaTkt,
    VstTkt.RagSocCompletaClienteFinale AS RagSocCompletaClienteFinaleTkt,
    VstTkt.IdEsercizio AS IdEsercizio,
    VstTkt.IdCodaTkt AS IdCodaTkt, 
    
    -- SEMAFORI
    CONVERT(SMALLINT, CASE 
			WHEN VstTkt.FlgTemplate = 1 OR VstCliPrj.FlgTemplate = 1
				THEN 5
			WHEN TbTktTodo.FlgChiuso = 1
				THEN 4
			/*WHEN TbAttivita.DataAcquisita IS NOT NULL
				THEN 2*/
			ELSE 1
			END) AS Sem1,
	
    CONVERT(SMALLINT, CASE 
			WHEN VstCliPrj.DataChiusura IS NULL
				THEN 3
			ELSE 1
			END) AS Sem2,

	CONVERT(SMALLINT, CASE 
			WHEN TbTktTodo.NFase IS NULL
				THEN 1 -- Se senza indicazione allora è primaria
			WHEN drvPrimarie.IdTkt IS NOT NULL
				THEN 1 -- Se numero di fase è pari al minimo per stesse attività collegate al ticket allora primaria
			ELSE 2
			END -- Altrimenti è secondaria
	) AS Sem3,

	CONVERT(SMALLINT, CASE 
			WHEN TbTktTodo.DataAccettato IS NULL
				THEN 2
			WHEN TbTktTodo.DataAccettato IS NOT NULL
				THEN 1
			ELSE 0
			END) AS Sem4

	FROM TbTktTodo
    LEFT OUTER JOIN VstTkt ON VstTkt.IdTkt = TbTktTodo.IdTkt
    LEFT OUTER JOIN VstCliPrj ON VstTkt.IdCliPrj = VstCliPrj.IdCliPrj AND TbTktToDo.IdTkt = VstTkt.IdCliPrj

    -- Calcolo Primari/Secondari
    LEFT OUTER JOIN (SELECT 
        IdTkt,
		MIN(NFase) AS NFase
	FROM TbTktTodo AS TmpTktToDo
	WHERE (NFase IS NOT NULL)
		AND (FlgChiuso = 0)
		AND (IdTkt IS NOT NULL)
	GROUP BY IdTkt
	) drvPrimarie
	ON drvPrimarie.IdTkt = TbTktTodo.IdTkt
		AND TbTktTodo.NFase = drvPrimarie.NFase

GO

