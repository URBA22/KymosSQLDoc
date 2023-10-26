
-- ==========================================================================================
-- Entity Name:	 VstUteMsg
-- Author:		 auto
-- Create date:	 211221
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 211221 Creazione
-- sim 221207 Aggiunto DboHPreview
-- sim 221212 Aggiunto border none per bellezza
-- ==========================================================================================
CREATE VIEW [dbo].[VstUteMsg]
AS
	SELECT 
        IdMsg, IdUtente, IdUtenteMittente, Messaggio, Messaggio1, DataMsg, DataMsgAcq, DataMsgVis, CodFnzTipoMsg, MsgObj, MsgParam, 
        MsgInfoEstese, MsgStato, MsgRes, FlgSempreVis, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, 
        SPID, IdDoc, IdDocDet, TipoDoc, MsgLog, ExecutionTime,

        CONCAT(
            '<div class="ky-message-command-msg" style="width:100%; border:none">',
            '<div class="ky-message-icon" style="background-color: ',
            CASE CodFnzTipoMsg 
                WHEN 'INF' THEN '#AACC40' 
                WHEN 'LOG' THEN '#3983C3' 
                WHEN 'WRN' THEN '#F3A83B' 
                WHEN 'ALR' THEN '#EB443A'   
            ELSE '' END,
            ';">',
            CASE CodFnzTipoMsg 
                WHEN 'INF' THEN '' 
                WHEN 'LOG' THEN '' 
                WHEN 'WRN' THEN '!' 
                WHEN 'ALR' THEN '!'   
            ELSE '' END,
            '</div>',
            '<h4>', Messaggio, '</h4>',
            IIF(ISNULL(MsgParam, '') <> '', CONCAT('<h6 style="font-weight:100;clear: both">', REPLACE(MsgParam, CHAR(10), '<br/>'), '</h6>'), ''),
            IIF(ISNULL(Messaggio1, '') <> '', CONCAT('<h6 style="font-weight:100;clear: both">', REPLACE(Messaggio1, CHAR(10), '<br/>'), '</h6>'), ''),
            IIF(ISNULL(MsgInfoEstese, '') <> '', CONCAT('<details><summary>Dettagli</summary><br>', REPLACE(MsgInfoEstese, CHAR(10), '<br/>'), '</details>'), ''),
            '</div>') AS DboHPreview
	FROM TbUteMsg

GO

