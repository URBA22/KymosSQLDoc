


-- ==========================================================================================
-- Entity Name:   FncCliFatDetAgentiProv
-- Author:        Lisa
-- Create date:   09.08.22
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Calcolo provvigioni agenti per riga fattura
-- History:
-- lisa 220809 Creazione
-- lisa 220826 Aggiunta vari campi e parametro (#)
-- ==========================================================================================
 

CREATE FUNCTION  [dbo].[zzz_FncCliFatDetAgentiProv]
(	
	@DaData as date,
	@AData as date,
	@IdAgente as nvarchar(20),
	@IdSetting as int
	-- @Stato as nvarchar(20) = 'MTR' -- MTR (manturate), 'PRV' (previste)
)
RETURNS 
@TmpProv TABLE
(
	[Tipo] [varchar](3) NOT NULL,
	[IdCliFat] [nvarchar](20) NOT NULL,
    [IdCliFatDet] [int] NOT NULL,
    [Descrizione] [nvarchar](200) NULL,
	[Stato] [nvarchar](20) NULL,
	[IdAgente] [nvarchar](20) NULL,
	[DescAgente] [nvarchar](200) NULL,
	[ImportoVlt] [money] NULL,
	[ImportoProvvigioneVlt] [money] NULL,
	[Importo] [money] NULL,
	[ImportoProvvigione] [money] NULL,
	[DataCliFat] [date] NULL,
	[RagSoc] [nvarchar](300) NULL,
	[IdValuta] [nvarchar](5) NULL,
	[Provvigione] [real] NULL,
	[ProvvigionePerc] [real] NULL,
	[TipoProvvigione] [nvarchar](5) NOT NULL,
	--[ImportoAperto] [money] NULL,
	--[ImportoVltAperto] [money] NULL,
	--[IdCntPartita] [nvarchar](20) NULL,
	[IdCausaleFat] [nvarchar](20) NULL,
	[TipoElab] [nvarchar](200) NULL,
    [IdSetting] [int] NULL,
    [DescCausaleFat] [nvarchar](200) NULL,
    [IdCliente] [int] NULL,
	[NoteInterne] [nvarchar] (300) NULL,
	[IdArticolo] [nvarchar](50) NULL,
	[Acronimo] [nvarchar](50) NULL,
	[Nome] [nvarchar](200) NULL,
	[Cognome] [nvarchar](200) NULL,
	[NRiga] [int] NULL,
	[NoteCliFatDet] [nvarchar](300) NULL,
	[GenDocTipo] [nvarchar](20) NULL
)
AS
BEGIN
	
	Declare @TipoElab as nvarchar(20)

	SET @TipoElab = IsNull(dbo.FncKeyValue('TipoProvvigioniAgenti',NULL), 'CLIFAT')

	If @TipoElab = 'CLIFAT'
	BEGIN
		---------------------------------------------
		-- Provvigione per fattura
		---------------------------------------------

		Insert Into @TmpProv
		(Tipo, IdCliFat, IdCliFatDet, Descrizione, IdAgente, DescAgente, ImportoVlt, ImportoProvvigioneVlt, Importo, ImportoProvvigione, DataCliFat, RagSoc, IdValuta, Provvigione, ProvvigionePerc, TipoProvvigione, 
        --ImportoAperto, ImportoVltAperto, IdCntPartita, 
        IdCausaleFat, TipoElab, IdSetting, DescCausaleFat, IdCliente, NoteInterne, IdArticolo, Acronimo, Nome, Cognome, NRiga, NoteCliFatDet, GenDocTipo)
	
		SELECT
		Tipo, drvImptorto.IdCliFat, 
        IdCliFatDet, Descrizione, 
        drvImptorto.IdAgente, TbAgenti.DescAgente, ImportoVlt,ImportoProvvigioneVlt, Importo, ImportoProvvigione,
		DataCliFat, TbClienti.RagSoc, TbCliFat.IdValuta, drvImptorto.Provvigione, drvImptorto.Provvigione / 100 as ProvvigionePerc , IsNull(TbAgenti.CodFnzTipoProvvigione,'VND') as TipoProvvigione,
		--drvDet.ImportoAperto, 
		--case when drvImptorto.FlgAccredito = 1 then -1 else 1 end * drvDet.ImportoAperto as ImportoAperto,
		--case when drvImptorto.FlgAccredito = 1 then -1 else 1 end * drvDet.ImportoVltAperto as ImportoVltAperto, 
		--drvDet.IdCntPartita, 
        TbCliFat.IdCausaleFat, 'Calcolo provvigioni su fatturato per riga' as TipoElab, TbCliFat.IdSetting, DescCausaleFat, TbCliFat.IdCliente, TbCliFat.NoteInterne,
		drvImptorto.IdArticolo, TbSetting.Acronimo, TbClienti.Nome, TbClienti.Cognome, NRiga, NoteCliFatDet, drvImptorto.GenDocTipo

		FROM

		(

		-- Calcolo provviggioni su Agente
		-- ## In futuro collegare agente e capoarea su riga con isnull()

		SELECT   'AGN' as Tipo, TbCliFat.IdCliFat, 
        TbCliFatDet.IdCliFatDet, LEFT (TbCliFatDet.Descrizione, 200) AS Descrizione,
        
        TbCliFat.IdAgente,Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione) as Provvigione,

		Round(( case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),2) AS ImportoVlt, 
		Round(( case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt * CONVERT(money,Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione,0)/100.)) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),2) AS ImportoProvvigioneVlt, 

		dbo.FncImporto((case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)) , dbo.TbCliFat.Cambio, 2) AS Importo, 
		dbo.FncImporto((case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt * CONVERT(money,Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione,0)/100.)) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),dbo.TbCliFat.Cambio, 2) AS ImportoProvvigione,
	
		TbCliAnagFatCausali.FlgAccredito,
        TbCliAnagFatCausali.DescCausaleFat,
		TbCliFatDet.IdArticolo,
		TbCliFatDet.NRiga, TbCliFatDet.NoteCliFatDet, TbCliFat.GenDocTipo

		FROM            TbCliFatDet INNER JOIN
		TbCliFat ON TbCliFatDet.IdCliFat = TbCliFat.IdCliFat INNER JOIN
		TbCliAnagFatCausali ON TbCliFat.IdCausaleFat = TbCliAnagFatCausali.IdCausaleFat
		WHERE        
		(TbCliAnagFatCausali.FlgProforma = 0) AND (TbCliAnagFatCausali.FlgAnticipo = 0)
		--AND Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione,0) <>0
		AND TbCliFatDet.IdCliFatDetAnticipo is null
		AND (ISNULL(TbCliFat.IdAgente,'') <> '')

		UNION ALL

		-- Calcolo provviggioni su Agente1

		SELECT   'AG' as Tipo, TbCliFat.IdCliFat, 
         TbCliFatDet.IdCliFatDet, LEFT (TbCliFatDet.Descrizione, 200) AS Descrizione,
        TbCliFat.IdAgente1,Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione) as Provvigione,

		Round(( case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),2) AS ImportoVlt, 
		Round(( case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt * CONVERT(money,Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione,0)/100.)) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),2) AS ImportoProvvigioneVlt, 

		dbo.FncImporto((case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)) , dbo.TbCliFat.Cambio, 2) AS Importo, 
		dbo.FncImporto((case when TbCliAnagFatCausali.FlgAccredito = 1 then -1 else 1 end * TbCliFatDet.PrezzoTotVlt * CONVERT(money,Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione,0)/100.)) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),dbo.TbCliFat.Cambio, 2) AS ImportoProvvigione,
	
		TbCliAnagFatCausali.FlgAccredito, 
        TbCliAnagFatCausali.DescCausaleFat,
		TbCliFatDet.IdArticolo,
		TbCliFatDet.NRiga, TbCliFatDet.NoteCliFatDet, TbCliFat.GenDocTipo

		FROM            TbCliFatDet INNER JOIN
		TbCliFat ON TbCliFatDet.IdCliFat = TbCliFat.IdCliFat INNER JOIN
		TbCliAnagFatCausali ON TbCliFat.IdCausaleFat = TbCliAnagFatCausali.IdCausaleFat
		WHERE        
		(TbCliAnagFatCausali.FlgProforma = 0) AND (TbCliAnagFatCausali.FlgAnticipo = 0)
		--AND Coalesce(TbCliFatDet.Provvigione, TbCliFat.Provvigione,0) <>0
		AND TbCliFatDet.IdCliFatDetAnticipo is null
		AND ISNULL(TbCliFat.IdAgente1,'') <> ''
		
		UNION ALL
		-- Calcolo provviggioni su Capoarea

		SELECT   'CPA' as Tipo, TbCliFat.IdCliFat, 
         TbCliFatDet.IdCliFatDet, LEFT (TbCliFatDet.Descrizione, 200) AS Descrizione,
        TbCliFat.IdAgenteCapoarea as IdAgente,Coalesce(TbCliFatDet.ProvvigioneCapoarea, TbCliFat.ProvvigioneCapoarea) as Provvigione,

		Round((TbCliFatDet.PrezzoTotVlt) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),2) AS ImportoVlt, 
		Round((TbCliFatDet.PrezzoTotVlt * CONVERT(money,Coalesce(TbCliFatDet.ProvvigioneCapoarea, TbCliFat.ProvvigioneCapoarea,0)/100.)) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),2) AS ImportoProvvigioneVlt, 

		dbo.FncImporto((TbCliFatDet.PrezzoTotVlt) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)) , dbo.TbCliFat.Cambio, 2) AS Importo, 
		dbo.FncImporto((TbCliFatDet.PrezzoTotVlt * CONVERT(money,Coalesce(TbCliFatDet.ProvvigioneCapoarea, TbCliFat.ProvvigioneCapoarea,0)/100.)) * CONVERT(money, (1 - ISNULL(TbCliFat.ScontoQta, 0) / 100.) *  (1 - ISNULL(TbCliFat.ScontoFatIncondz, 0) / 100.)),dbo.TbCliFat.Cambio, 2) AS ImportoProvvigione,

		TbCliAnagFatCausali.FlgAccredito,
        TbCliAnagFatCausali.DescCausaleFat,
		TbCliFatDet.IdArticolo,
		TbCliFatDet.NRiga, TbCliFatDet.NoteCliFatDet, TbCliFat.GenDocTipo

		FROM            TbCliFatDet INNER JOIN
		TbCliFat ON TbCliFatDet.IdCliFat = TbCliFat.IdCliFat INNER JOIN
		TbCliAnagFatCausali ON TbCliFat.IdCausaleFat = TbCliAnagFatCausali.IdCausaleFat
		WHERE        
		(TbCliAnagFatCausali.FlgProforma = 0) AND (TbCliAnagFatCausali.FlgAnticipo = 0)
		--AND Coalesce(TbCliFatDet.ProvvigioneCapoarea, TbCliFat.ProvvigioneCapoarea,0) <> 0
		AND TbCliFatDet.IdCliFatDetAnticipo is null
		AND ISNULL(TbCliFat.IdAgenteCapoarea,'') <> ''
		

		) drvImptorto Inner Join
		TbCliFat ON TbCliFat.IdCliFat = drvImptorto.IdCliFat LEFT OUTER JOIN 
		TbAgenti On TbAgenti.IdAgente = drvImptorto.IdAgente LEFT OUTER JOIN 
		TbClienti ON TbClienti.IdCliente = TbCliFat.IdCliente LEFT OUTER JOIN
		TbSetting ON TbCliFat.IdSetting = TbSetting.IdSetting

		WHERE        (TbCliFat.DataCliFat >= @DaData) AND (TbCliFat.DataCliFat <= @AData)
		AND (drvImptorto.IdAgente = @IdAgente OR IsNull(@IdAgente,'') = '')
		AND (TbCliFat.IdSetting = @IdSetting OR IsNull(@IdSetting, 0) = 0)
	END

	ELSE
	BEGIN
		Insert Into @TmpProv
		(Tipo, TipoElab)
		values
		('ERR','Errore chiave TipoProvvigioniAgenti, valori ammessi  CLIFAT, valore attuale ' + isnull(@TipoElab,'--'))
	END
	
	RETURN 
END

GO

