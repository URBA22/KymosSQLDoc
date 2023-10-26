
-- ==========================================================================================
-- Entity Name:	 VstSegnalatori
-- Author:		 auto
-- Create date:	 230413
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- fab 230413 Creazione
-- dav 230414 Gestrione relazioni
-- ==========================================================================================
CREATE VIEW [dbo].[VstSegnalatori]
AS
SELECT IdSegnalatore,
	DescSegnalatore,
    COALESCE (TbSegnalatori.DescSegnalatore, CONCAT( TbContatti.CognomeNome, '-', TbFornitori.Acronimo)) as DescSegnalatoreElab,
	TbSegnalatori.NoteSegnalatore,
	TbContatti.Tel,
	TbContatti.Tel1,
	TbContatti.Cell,
	TbContatti.Fax,
	TbContatti.EMail,
    TbContatti.CognomeNome,
    TbFornitori.RagSoc,
	TbSegnalatori.IdFornitore,
    TbSegnalatori.IdContatto,
	TbSegnalatori.Disabilita,
	TbSegnalatori.SysDateCreate,
	TbSegnalatori.SysUserCreate,
	TbSegnalatori.SysDateUpdate,
	TbSegnalatori.SysUserUpdate,
	TbSegnalatori.SysRowVersion
FROM TbSegnalatori LEFT OUTER JOIN
    TbContatti ON TbContatti.IdContatto = TbSegnalatori.IdContatto LEFT OUTER JOIN
    TbFornitori ON TbFornitori.IdFornitore = TbSegnalatori.IdFornitore

GO

