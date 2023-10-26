-- ==========================================================================================
-- Entity Name:	FncVstr
-- Author:      sim
-- Create date: 211028
-- AutoCreate:	YES
-- Custom:	    NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:
-- History:
-- sim 211028 Creazione
-- sim 211108 Fix selezione IdCliente
-- ==========================================================================================
CREATE FUNCTION [dbo].[FncVstr](
	@SysUser NVARCHAR(256) = NULL,
	@IdCliente INT = NULL
)
	RETURNS
		@Vstr TABLE
		      (
			      IdVstr        [INT],
			      IdGuidVstr    [NVARCHAR](256) NOT NULL,
			      Nome          [NVARCHAR](100) NOT NULL,
			      Cognome       [NVARCHAR](100) NOT NULL,
			      CognomeNome   [NVARCHAR](100) NOT NULL,
			      Societa       [NVARCHAR](100),
			      Cell          [NVARCHAR](50),
			      EMail         [NVARCHAR](256),
			      SysDateCreate [DATETIME],
			      SysUserCreate [NVARCHAR](256),
			      SysDateUpdate [DATETIME],
			      SysUserUpdate [NVARCHAR](256),
			      SysRowVersion [VARBINARY](8)  NULL,
			      IdCliente     [INT],
			      FlgPrivacy    [BIT]           NOT NULL
		      )
AS
BEGIN

	IF (ISNULL(@SysUser, '') <> '' AND ISNULL(@IdCliente, 0) = 0)
		BEGIN
			SELECT @IdCliente = VstContatti.IdCliente
			FROM
				dbo.AspNetUsers     AspNetUsers
					INNER JOIN
					dbo.VstContatti VstContatti
						on AspNetUsers.UserName = VstContatti.EMail
			WHERE AspNetUsers.UserName = @SysUser
		END


	INSERT INTO @Vstr(IdVstr, IdGuidVstr, Nome, Cognome, CognomeNome, Societa, Cell, EMail, SysDateCreate,
	                  SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, IdCliente, FlgPrivacy)
	SELECT
		TbVstr.IdVstr, TbVstr.IdGuidVstr, TbVstr.Nome, TbVstr.Cognome, TbVstr.CognomeNome, TbVstr.Societa, TbVstr.Cell,
		TbVstr.EMail, TbVstr.SysDateCreate, TbVstr.SysUserCreate, TbVstr.SysDateUpdate, TbVstr.SysUserUpdate,
		TbVstr.SysRowVersion, TbVstr.IdCliente, TbVstr.FlgPrivacy
	FROM
		dbo.TbVstr TbVstr
	WHERE ISNULL(@IdCliente, 0) = 0
	   OR TbVstr.IdCliente = @IdCliente

	RETURN
END

GO

