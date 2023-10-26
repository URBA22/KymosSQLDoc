-- ==========================================================================================
-- Entity Name:	FncVstrTransiti
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
CREATE FUNCTION [dbo].[FncVstrTransiti](
	@SysUser NVARCHAR(256) = NULL,
	@DataTransito DATE = NULL,
	@IdCliDest INT = NULL,
	@IdCliente INT = NULL
)
	RETURNS
		@VstrTransiti TABLE
		              (
			              IdTransito        [INT],
			              IdCliente         [INT],
			              IdCliDest         [INT],
			              IdGuidToken       [UNIQUEIDENTIFIER],
			              OraElabToken      [DATETIME],
			              IdVstr            [INT],
			              OraTransito       [DATETIME],
			              IdUtenteRef       [NVARCHAR](256),
			              Provenienza       [NVARCHAR](50),
			              DescUtenteRef     [NVARCHAR](50),
			              Badge             [NVARCHAR](50),
			              Nome              [NVARCHAR](100),
			              Cognome           [NVARCHAR](100),
			              CognomeNome       [NVARCHAR](100),
			              Societa           [NVARCHAR](100),
			              Cell              [NVARCHAR](50),
			              EMail             [NVARCHAR](256),
			              SysDateCreate     [DATETIME],
			              SysUserCreate     [NVARCHAR](256),
			              SysDateUpdate     [DATETIME],
			              SysUserUpdate     [NVARCHAR](256),
			              SysRowVersion     [VARBINARY](8)  NULL,
			              FlgPrivacy        [BIT]           NOT NULL,
			              IndirizzoCompleto [NVARCHAR](MAX) NULL
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

	INSERT INTO @VstrTransiti(IdTransito, IdCliente, IdCliDest, IdGuidToken, OraElabToken, IdVstr, OraTransito,
	                          IdUtenteRef, Provenienza, DescUtenteRef, Badge, Nome, Cognome, CognomeNome, Societa, Cell,
	                          EMail, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion,
	                          FlgPrivacy, IndirizzoCompleto)
	SELECT
		TbVstrTransiti.IdTransito, TbVstrTransiti.IdCliente, TbVstrTransiti.IdCliDest, TbVstrTransiti.IdGuidToken,
		TbVstrTransiti.OraElabToken, TbVstrTransiti.IdVstr, TbVstrTransiti.OraTransito, TbVstrTransiti.IdUtenteRef,
		TbVstrTransiti.Provenienza, TbVstrTransiti.DescUtenteRef, TbVstrTransiti.Badge, TbVstrTransiti.Nome,
		TbVstrTransiti.Cognome, TbVstrTransiti.CognomeNome, TbVstrTransiti.Societa, TbVstrTransiti.Cell,
		TbVstrTransiti.EMail, TbVstrTransiti.SysDateCreate, TbVstrTransiti.SysUserCreate, TbVstrTransiti.SysDateUpdate,
		TbVstrTransiti.SysUserUpdate, TbVstrTransiti.SysRowVersion, TbVstrTransiti.FlgPrivacy,
		TbCliDest.IndirizzoCompleto
	FROM
		dbo.TbVstrTransiti TbVstrTransiti
			LEFT OUTER JOIN
			dbo.TbCliDest  TbCliDest
				on TbVstrTransiti.IdCliDest = TbCliDest.IdCliDest
	WHERE (ISNULL(@IdCliente, 0) = 0
		OR TbVstrTransiti.IdCliente = @IdCliente)
	  AND (ISNULL(@DataTransito, '') = ''
		OR CONVERT(DATE, TbVstrTransiti.OraTransito) = @DataTransito)
	  AND (ISNULL(@IdCliDest, 0) = 0
		OR TbVstrTransiti.IdCliDest = @IdCliDest)

	RETURN
END

GO

