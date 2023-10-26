
/*
 * History
 * fab 29.11.16 creazione
 */

CREATE VIEW [dbo].[VstTrspListini]
AS
SELECT        IdListino, DescListino, DataInizioValidita, DataFineValidita, FlgStandard, NotePopUp, NoteListino, CodFnzTipo, UnitM, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion,
                          CodFnzTipologia, TipoListino, CONVERT(smallint,0) AS Sem1,  CONVERT(smallint,0) AS Sem2,  CONVERT(smallint,0) AS Sem3,  CONVERT(smallint,0) AS Sem4, CONVERT(nvarchar(max), NULL) AS Ord, CONVERT(nvarchar(max), NULL) AS ColRiga
FROM            dbo.TbTrspListini

GO

