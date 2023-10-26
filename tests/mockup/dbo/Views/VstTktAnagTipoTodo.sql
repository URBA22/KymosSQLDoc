-- ==========================================================================================
-- Entity Name:	 VstTktAnagTipoTodo
-- Author:		 auto
-- Create date:	 230724
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230724 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktAnagTipoTodo]
AS
	SELECT IdTipoTodo, DescTipo, Disabilita, Predefinito, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbTktAnagTipoTodo

GO

