-- ==========================================================================================
-- Entity Name:   VstUtentiAnagRuoli
-- Author:        sim
-- Create date:   211119
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:
-- Description:
-- History:
-- sim 211119 Creazione
-- dav 220301 Inserito PrezzoOra
-- sim 220503 Tolto PrezzoOra
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiAnagRuoli]
AS
SELECT
	IdRuolo, DescRuolo, Disabilita, NoteRuolo, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate,
	SysRowVersion, CodFnzTipo, FlgPrimario
FROM
	dbo.TbUtentiAnagRuoli TbUtentiAnagRuoli

GO

