
-- ==========================================================================================
-- Entity Name:   
-- Author:        
-- Create date:   
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- vale 210302 Gestione Note Pop 
-- dav 221227 Formattazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstVettori]
AS
SELECT dbo.TbFornitori.IdFornitore AS IdVettore,
	dbo.TbFornitori.RagSoc AS RagSocVettore,
	dbo.TbFornitori.IndirizzoCompleto,
	dbo.TbFornitori.IscrizioneAlbo,
	dbo.TbFornitori.SysRowVersion,
	dbo.TbFornitori.SysDateCreate,
	dbo.TbFornitori.SysUserCreate,
	dbo.TbFornitori.SysDateUpdate,
	dbo.TbFornitori.SysUserUpdate,
	dbo.TbFornitori.Disabilita,
	NotePopUp
FROM dbo.TbFornitori
INNER JOIN dbo.TbForAnagTipo
	ON dbo.TbFornitori.IdForTipo = dbo.TbForAnagTipo.IdForTipo
WHERE (dbo.TbForAnagTipo.CodFnz = N'VT')

GO

