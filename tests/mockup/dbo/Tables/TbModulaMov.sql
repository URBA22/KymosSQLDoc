CREATE TABLE [dbo].[TbModulaMov] (
    [IdModulaMov]   INT            IDENTITY (1, 1) NOT NULL,
    [IdArticolo]    NVARCHAR (50)  NULL,
    [IdMage]        NVARCHAR (10)  NULL,
    [IdMage1]       NVARCHAR (10)  NULL,
    [MagePosiz]     NVARCHAR (20)  NULL,
    [MagePosiz1]    NVARCHAR (20)  NULL,
    [IdLotto]       NVARCHAR (20)  NULL,
    [IdColore]      NVARCHAR (20)  NULL,
    [IdVariante]    NVARCHAR (20)  NULL,
    [DimLunghezza]  REAL           NULL,
    [DimLarghezza]  REAL           NULL,
    [DimAltezza]    REAL           NULL,
    [IdMatricola]   INT            NULL,
    [CodFnzTipo]    NVARCHAR (5)   NULL,
    [Qta]           REAL           NULL,
    [UnitM]         NVARCHAR (20)  NULL,
    [UnitMCoeff]    REAL           NULL,
    [SysDateCreate] DATETIME       CONSTRAINT [DF_TbModulaMov_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate] NVARCHAR (256) NULL,
    [SysDateUpdate] DATETIME       NULL,
    [SysUserUpdate] NVARCHAR (256) NULL,
    [SysRowVersion] ROWVERSION     NULL,
    [IdCausaleMov]  NVARCHAR (20)  NULL,
    [CostoUnit]     MONEY          NULL,
    [CostoTot]      AS             ([CostoUnit]*[Qta]),
    [QtaMage]       REAL           NULL,
    [IdBaiaMov]     NVARCHAR (20)  NULL,
    [DataDoc]       DATE           NULL,
    [Id]            INT            NULL,
    CONSTRAINT [PK_TbModulaMov] PRIMARY KEY CLUSTERED ([IdModulaMov] ASC),
    CONSTRAINT [FK_TbModulaMov_TbArtAnagColori] FOREIGN KEY ([IdColore]) REFERENCES [dbo].[TbArtAnagColori] ([IdColore]),
    CONSTRAINT [FK_TbModulaMov_TbArticoli] FOREIGN KEY ([IdArticolo]) REFERENCES [dbo].[TbArticoli] ([IdArticolo]),
    CONSTRAINT [FK_TbModulaMov_TbArtLotti] FOREIGN KEY ([IdLotto]) REFERENCES [dbo].[TbArtLotti] ([IdLotto]),
    CONSTRAINT [FK_TbModulaMov_TbMageAnag] FOREIGN KEY ([IdMage]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbModulaMov_TbMageAnag1] FOREIGN KEY ([IdMage1]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbModulaMov_TbMageAnagMovCausali] FOREIGN KEY ([IdCausaleMov]) REFERENCES [dbo].[TbMageAnagMovCausali] ([IdCausaleMov]),
    CONSTRAINT [FK_TbModulaMov_TbMatricole] FOREIGN KEY ([IdMatricola]) REFERENCES [dbo].[TbMatricole] ([IdMatricola]),
    CONSTRAINT [FK_TbModulaMov_TbUnitM] FOREIGN KEY ([UnitM]) REFERENCES [dbo].[TbUnitM] ([UnitM])
);


GO

CREATE NONCLUSTERED INDEX [IX_TbModulaMov_1]
    ON [dbo].[TbModulaMov]([IdArticolo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbModulaMov]
    ON [dbo].[TbModulaMov]([DataDoc] ASC);


GO

-- ==========================================================================================
-- Entity Name:   TrTbModulaMov_Mage
-- Author:        Dav
-- Create date:   200627
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	  Write custom note here
-- Description:	  Log movimenti mage
-- History
-- dav 200627 Costruzione
-- ==========================================================================================

CREATE TRIGGER [dbo].[TrTbModulaMov_Mage] 
   ON  dbo.TbModulaMov 
   AFTER  INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 -- Note
	 -- Il trigger non può essere controllato con if update(nomecampo) perchè la stp aggiorna tutto
	 -- per evitare aggiornamenti per ogno modifica serve join su inserted e delete su campi critici

	
	/*******************************************************************
	 * Aggiorna i contatori di magazzino Mage (solo inserimenti)
	 *******************************************************************/
	
	BEGIN 

		-- Preleva mage 

		INSERT INTO TbMageMov
		(InfoMov, TipoDoc, IdDoc, IdDocDet, IdArticolo, KeyMage, IdMage, Qta, MagePosiz)
		SELECT     'TrModulaMov_Mage_01' AS Expr1, 'TbModulaMov' AS TipoDoc, inserted.IdModulaMov, inserted.IdModulaMov, inserted.IdArticolo, 
		right ('00000000000000000000'+ IdMage,20) AS KeyMage, 
		inserted.IdMage,  
		- ROUND(ISNULL(inserted.Qta, 0), 4) AS QtaMov,
		inserted.MagePosiz
		FROM inserted 	

		-- Preleva mage vrt
		
		INSERT INTO TbMageVrtMov
		(InfoMov, TipoDoc, IdDoc, IdDocDet, IdArticolo, KeyMage, IdMage, Qta, QtaMageMov , MagePosiz, IdLotto)
		SELECT     'TrModulaMov_Mage_01' AS Expr1, 'TbModulaMov' AS TipoDoc, inserted.IdModulaMov, inserted.IdModulaMov, inserted.IdArticolo, 
		right ('00000000000000000000'+ IdMage,20) AS KeyMage, 
		inserted.IdMage,  
		NULL AS QtaMov, 
		- ROUND(ISNULL(inserted.Qta, 0), 4) AS QtaMageMov,
		Inserted.MagePosiz,
		inserted.IdLotto 
		FROM inserted 
		WHERE   Inserted.IdLotto IS NOT NULL
	END	
		 
	/*******************************************************************
	 * Aggiorna i contatori di magazzino Mage (solo inserimenti)
	 *******************************************************************/
	
	BEGIN 

		-- Versa mage 

		INSERT INTO TbMageMov
		(InfoMov, TipoDoc, IdDoc, IdDocDet, IdArticolo, KeyMage, IdMage, Qta, MagePosiz)
		SELECT     'TrModulaMov_Mage_01' AS Expr1, 'TbModulaMov' AS TipoDoc, inserted.IdModulaMov, inserted.IdModulaMov, inserted.IdArticolo, 
		right ('00000000000000000000'+ IdMage1,20) AS KeyMage, 
		inserted.IdMage1,  
		+ ROUND(ISNULL(inserted.Qta, 0), 4) AS QtaMov,
		inserted.MagePosiz
		FROM inserted 	
		where 
		Inserted.Idmage1 IS NOT NULL

		-- Versa mage vrt
		
		INSERT INTO TbMageVrtMov
		(InfoMov, TipoDoc, IdDoc, IdDocDet, IdArticolo, KeyMage, IdMage, Qta, QtaMageMov , MagePosiz, IdLotto)
		SELECT     'TrModulaMov_Mage_01' AS Expr1, 'TbModulaMov' AS TipoDoc, inserted.IdModulaMov, inserted.IdModulaMov, inserted.IdArticolo, 
		right ('00000000000000000000'+ IdMage1,20) AS KeyMage, 
		inserted.IdMage1,  
		NULL AS QtaMov, 
		+ ROUND(ISNULL(inserted.Qta, 0), 4) AS QtaMageMov,
		Inserted.MagePosiz,
		inserted.IdLotto 
		FROM inserted 
		WHERE   
		Inserted.Idmage1 IS NOT NULL and
		Inserted.IdLotto IS NOT NULL
	END	
	
	
					
END

GO

