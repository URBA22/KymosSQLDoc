-- ==========================================================================================
-- Entity Name:	 VstTktMsg
-- Author:		 auto
-- Create date:	 230707
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230707 Creazione
-- FRA 230727 Aggiunta campi
-- FRA 230808 Aggiunto FlgChiuso e Sem1
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktMsg]
AS
	SELECT 
        TbTktMsg.IdMsg, 
        TbTktMsg.IdTkt, 
        TbTktMsg.NoteMsg, 
        TbTktMsg.CodFnzTipo, 
        TbTktMsg.IdUtente, 
        TbTktMsg.IdUtenteDest, 
        TbTktMsg.CodFnzPriorita, 
        TbTktMsg.DataMsg, 
        TbTktMsg.DataChiusura, 
        TbTktMsg.CmpOpz, 
        TbTktMsg.SysDateCreate, 
        TbTktMsg.SysUserCreate, 
        TbTktMsg.SysDateUpdate, 
        TbTktMsg.SysUserUpdate,
        TbTktMsg.SysRowVersion,
        VstUtenti_1.DescUtenteElab AS DescUtenteElab,
        VstUtenti_2.DescUtenteElab AS DescUtenteDestElab,
        TbTktMsg.FlgChiuso,

        ---- SEMAFORI

         -- SEMAFORI
        CONVERT(SMALLINT, 
            CASE WHEN 
                TbTktMsg.FlgChiuso = 1 THEN 4
                ELSE 1
                END
        ) AS Sem1

        FROM TbTktMsg
        LEFT OUTER JOIN VstUtenti AS VstUtenti_1 ON VstUtenti_1.IdUtente = TbTktMsg.IdUtente
        LEFT OUtER JOIN VstUtenti AS VstUtenti_2 ON VstUtenti_2.IdUtente = TbTktMsg.IdUtenteDest

    --Acquisito
    --FlgAperta

GO

