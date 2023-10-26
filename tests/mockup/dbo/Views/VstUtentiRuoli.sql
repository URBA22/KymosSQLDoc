
-- ==========================================================================================
-- Entity Name:   VstUtentiRuoli
-- Author:        simone
-- Create date:   210216
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- simone 210216 Creazione
-- ==========================================================================================


CREATE VIEW [dbo].[VstUtentiRuoli]
AS
SELECT	TbUtentiRuoli.IdUtenteRuolo, 
        TbUtentiRuoli.IdUtente, 
        TbUtentiRuoli.IdRuolo,
        TbUtentiRuoli.DescRuolo, 
        TbUtentiRuoli.NoteRuolo, 
        TbUtentiRuoli.DataRuoloDa, 
        TbUtentiRuoli.DataScadFormazione,
        TbUtentiRuoli.DataRuoloA,
        CONVERT(SMALLINT, 0) AS Sem1, 
        CONVERT(SMALLINT, 0) AS Sem2, 
        CONVERT(SMALLINT, 0) AS Sem3, 
        CONVERT(SMALLINT, 0) AS Sem4,
        CONVERT(NVARCHAR(7), NULL) AS ColRiga,
        CONVERT(NVARCHAR(50), NULL) AS Ord,
        TbUtentiRuoli.SysDateCreate, 
        TbUtentiRuoli.SysUserCreate, 
        TbUtentiRuoli.SysDateUpdate, 
        TbUtentiRuoli.SysUserUpdate, 
        TbUtentiRuoli.SysRowVersion,
        drvFormazioniUte.DataScadenza

FROM		
    dbo.TbUtentiRuoli TbUtentiRuoli LEFT OUTER JOIN
    (
        SELECT IdUtente, IdRuolo, MAX(COALESCE(TbQaFormazioniUte.DataScadenza, TbQaFormazioni.DataScadenza)) AS DataScadenza
        FROM  TbQaFormazioniUte 
        LEFT OUTER JOIN TbQaFormazioni ON TbQaFormazioniUte.IdFormazione = TbQaFormazioni.IdFormazione
        WHERE (COALESCE(TbQaFormazioniUte.DataScadenza, TbQaFormazioni.DataScadenza ) IS NOT NULL) AND (IdRuolo IS NOT NULL) AND 
        -- Considera solo master e non Bozze
        (IdFormazioneMaster = TbQaFormazioni.IdFormazione OR IdFormazioneMaster IS NULL) AND (ISNULL(TbQaFormazioni.CodFnzTipo, '') <> 'BZ')
        GROUP BY IdUtente, IdRuolo
    ) drvFormazioniUte ON drvFormazioniUte.IdUtente = TbUtentiRuoli.IdUtente AND drvFormazioniUte.IdRuolo = TbUtentiRuoli.IdRuolo

GO

