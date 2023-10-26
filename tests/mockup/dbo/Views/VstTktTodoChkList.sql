-- ==========================================================================================
-- Entity Name:	 VstTktTodoChkList
-- Author:		 auto
-- Create date:	 230707
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230707 Creazione
-- FRA 230802 Aggiunto join con utenti
-- FRA 230811 Aggiunto join con todo e tkt e semafori
-- FRA 230817 Checklist è considerata con semaforo template, anche se fa parte di un progetto template e uso un solo semaforo per chiusi
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktTodoChkList]
AS
	SELECT 
        TbTktTodoChkList.IdChkList, 
        TbTktTodoChkList.IdTodo, 
        TbTktTodoChkList.NChk, 
        TbTktTodoChkList.DescChk, 
        TbTktTodoChkList.NoteChk, 
        TbTktTodoChkList.DataChk, 
        ISNULL(TbTktTodoChkList.IdUtente, VstTktTodo.IdUtente) AS IdUtente, 
        TbTktTodoChkList.SysDateCreate, 
        TbTktTodoChkList.SysUserCreate, 
        TbTktTodoChkList.SysDateUpdate, 
        TbTktTodoChkList.SysUserUpdate, 
        TbTktTodoChkList.SysRowVersion, 
        TbTktTodoChkList.FlgChk,
        VstUtenti.DescUtenteElab AS DescUtenteElab,

        -- SEMAFORI
        CONVERT(SMALLINT, CASE 
			WHEN VstTkt.FlgTemplate = 1 OR TbCliPrj.FlgTemplate = 1
				THEN 5
            WHEN TbTktTodoChkList.FlgChk = 1 OR VstTktTodo.FlgChiuso = 1 OR VstTkt.FlgChiuso = 1
                THEN 4
			ELSE 1
			END) AS Sem1
	FROM TbTktTodoChkList
    INNER JOIN VstTktTodo ON VstTktTodo.IdTodo = TbTktTodoChkList.IdTodo
    INNER JOIN VstTkt ON VstTktTodo.IdTkt = VstTkt.IdTkt
    LEFT OUTER JOIN TbCliPrj ON TbCliPrj.IdCliPrj = VstTkt.IdCliPrj
    LEFT OUTER JOIN VstUtenti ON ISNULL(TbTktTodoChkList.IdUtente, VstTktTodo.IdUtente) = VstUtenti.IdUtente

GO

