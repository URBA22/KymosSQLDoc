
-- ==========================================================================================
-- Entity Name:	StpMntObjLog
-- Author:	Dav
-- Create date:	21.10.15
-- AutoCreate:	NO
-- Custom:	NO
-- Generator:	01.00.00
-- CustomNote:	Write custom note here
-- Description:	Esegue il log degli oggetti o il controllo
-- ==========================================================================================

CREATE Procedure [dbo].[StpMntObjLog]
(
	@SysUser nvarchar(256),
	@KYStato int = NULL output,
	@KYMsg nvarchar(max) = NULL output,
	@KYRes int = NULL
)

AS
BEGIN

	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera;	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @Msg nvarchar(300)
	Declare @Msg1 nvarchar(300)
	Declare @MsgObj nvarchar(300)
	Declare @MsgExt nvarchar(300)

	SET @Msg= 'ObjLog'
	SET @MsgObj='StpMntObjLog'

	Declare @Version as nvarchar(20)

	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = ''
	
	/****************************************************************
	--@State 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @KYStato = 1
		Declare @KyInfoEst as nvarchar(max)
		Declare @CodFnzTipoMsg as nvarchar(20)

		Set @CodFnzTipoMsg = 'QST'

		IF dbo.FncOggettoPrs('STP','StpXMntObjCustom')=1
			BEGIN
				Set @CodFnzTipoMsg = 'WRN'
				Set @KyInfoEst = 'Attenzione ci sono oggetti std personalizzati, in fase di verifica verranno storicizzati.'
			END
		
		SET @Msg1= 'Controllo oggetti DB per aggiornamento'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,@CodFnzTipoMsg,@SysUser,
				@KYStato,@KYRes,@KyInfoEst, '(1):Verifica;2:Storicizza;0:Cancel',@KYMsg out
		
		RETURN
	END
	
	/****************************************************************
	--@State 1 @Res 2 - risposta affermativa
	****************************************************************/
	IF (@KYStato = 1 and @KYRes = 2)
	BEGIN

			Set @Version = CONVERT(nvarchar(50), GETDATE(), 120) 
	
			--@ inserisce tutti gli oggetti
			INSERT INTO TbMntObjLog
			(IdObj, Definition, Version, NoteLog, SysUserCreate, SysDateCreate, SysDateUpdate)
			SELECT  sys.objects.name as IdObj, Null as  Definition, @Version, '' AS NoteLog, @SysUser AS SysUserCreate, sys.objects.create_date,  sys.objects.modify_date
			FROM sys.objects

			-- storicizza sql
			UPDATE       TbMntObjLog
			SET                Definition = sys.sql_modules.definition
			FROM            sys.sql_modules INNER JOIN
			TbMntObjLog ON OBJECT_NAME(sys.sql_modules.object_id) = TbMntObjLog.IdObj
			WHERE        (TbMntObjLog.Version = @Version)

			--		SELECT
			--      [name]
			--      ,create_date
			--      ,modify_date
			--		FROM
			--      sys.procedures

			-- tiene solo le ultime 4 versioni

			DELETE FROM TbMntObjLog
			FROM            (SELECT        TOP (4) Version
			FROM            TbMntObjLog AS TbMntObjLog_1
			GROUP BY Version
			ORDER BY Version DESC) AS drvVrs RIGHT OUTER JOIN
			TbMntObjLog ON drvVrs.Version = TbMntObjLog.Version
			WHERE        (drvVrs.Version IS NULL)


			/****************************************************************
			* Uscita
			****************************************************************/
				
			SET @Msg1= 'Operazione completata versione ' + @Version
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUser,
					@KYStato,0,'', NULL,@KYMsg out

			SET @KYStato = -1

		RETURN
	END

	/****************************************************************
	--@State 1 @Res 1 - risposta verifica
	****************************************************************/
	IF (@KYStato = 1 and @KYRes = 1)
	BEGIN

			Set @Version = (Select max (Version) from TbMntObjLog)
	
			/* 
			 * Controllo 
			 *
			
			SELECT        TbMntObjLog.IdLog, TbMntObjLog.Version, TbMntObjLog.IdObj, 
			CASE WHEN drvObj.IdObj IS NOT NULL THEN 'X' ELSE '' END AS Stato, Definition,
			TbMntObjLog.SysDateCreate, TbMntObjLog.SysDateUpdate, 
			drvObj.create_date, drvObj.modify_date

			FROM            TbMntObjLog FULL OUTER JOIN
			(SELECT [name] as IdObj ,create_date,modify_date FROM sys.objects
			) AS drvObj ON TbMntObjLog.IdObj = drvObj.IdObj

			WHERE        (LEFT(TbMntObjLog.IdObj, 3) = 'tbx') OR
			(LEFT(TbMntObjLog.IdObj, 4) = 'vstx') OR
			(LEFT(TbMntObjLog.IdObj, 4) = 'stpx')
			and
			TbMntObjLog.Version= @Version
			
			*/

			IF dbo.FncOggettoPrs('STP','StpXMntObjCustom')=1
			BEGIN
				EXECUTE StpXMntObjCustom @SysUser 

			END

			Declare @Congruenti as int
			Declare @NonCongruenti as int
			Declare @Oggetti as int


			SELECT  

			@Congruenti= Sum(CASE WHEN drvObj.IdObj IS NOT NULL THEN 1 ELSE 0 END),
			@NonCongruenti=Sum(CASE WHEN drvObj.IdObj IS NOT NULL THEN 0 ELSE 1 END),
			@Oggetti=Count (TbMntObjLog.IdObj)

			FROM  TbMntObjLog LEFT OUTER JOIN
			(
			SELECT [name] as IdObj ,create_date,modify_date FROM sys.objects
			) AS drvObj 
			ON TbMntObjLog.IdObj = drvObj.IdObj
			WHERE     (   (LEFT(TbMntObjLog.IdObj, 3) = 'tbx') OR
			(LEFT(TbMntObjLog.IdObj, 4) = 'vstx') OR
			(LEFT(TbMntObjLog.IdObj, 4) = 'stpx')) and
			TbMntObjLog.Version= @Version


			Declare @Eliminati as int
			Declare @Creati as int
			Declare @Modificati as int

			Select 
			@Eliminati= Sum(CASE WHEN drvObj.IdObj IS  NULL AND  tbMntObjLog.IdObj IS NOT NULL THEN 1 ELSE 0 END),
			@Creati= Sum(CASE WHEN drvObj.IdObj IS NOT NULL AND  tbMntObjLog.IdObj IS NULL THEN 1 ELSE 0 END),
			@Modificati= Sum(CASE WHEN SysDateUpdate <> modify_date THEN 1 ELSE 0 END) 
			FROM            TbMntObjLog FULL OUTER JOIN
			(SELECT [name] as IdObj ,create_date,modify_date FROM sys.objects
			) AS drvObj ON TbMntObjLog.IdObj = drvObj.IdObj
			WHERE        (TbMntObjLog.Version = @Version)
			

			/****************************************************************
			* Uscita
			****************************************************************/
			
			Declare @TypeMsg as nvarchar(20)
			If @NonCongruenti <> 0 or @Oggetti=0
				BEGIN	
					SET @Msg1= 'Operazione completata versione ' + @Version
					SET @Msg1= dbo.FncStr (@Msg1,'-----------------------------------')
					SET @Msg1= dbo.FncStr (@Msg1,'Congruenti: ' + convert (nvarchar(20), @Congruenti))
					SET @Msg1= dbo.FncStr (@Msg1,'Non Congruenti: ' + convert (nvarchar(20), @NonCongruenti))
					SET @Msg1= dbo.FncStr (@Msg1,'Totali X: ' + convert (nvarchar(20), @Oggetti))
					SET @Msg1= dbo.FncStr (@Msg1,'-----------------------------------')
					SET @Msg1= dbo.FncStr (@Msg1,'Eliminati: ' + convert (nvarchar(20), @Eliminati))
					SET @Msg1= dbo.FncStr (@Msg1,'Creati: ' + convert (nvarchar(20), @Creati))
					SET @Msg1= dbo.FncStr (@Msg1,'Modificati: ' + convert (nvarchar(20), @Modificati))

					Set @TypeMsg = 'WRN'
				END
			ELSE
				BEGIN
					SET @Msg1=  'Operazione completata versione ' + @Version
					SET @Msg1= dbo.FncStr (@Msg1,'-----------------------------------')
					SET @Msg1= dbo.FncStr (@Msg1,'Congruenti: ' + convert (nvarchar(20), @Congruenti))
					SET @Msg1= dbo.FncStr (@Msg1,'Non Congruenti: ' + convert (nvarchar(20), @NonCongruenti))
					SET @Msg1= dbo.FncStr (@Msg1,'Totali X: ' + convert (nvarchar(20), @Oggetti))
					SET @Msg1= dbo.FncStr (@Msg1,'-----------------------------------')
					SET @Msg1= dbo.FncStr (@Msg1,'Eliminati: ' + convert (nvarchar(20), @Eliminati))
					SET @Msg1= dbo.FncStr (@Msg1,'Creati: ' + convert (nvarchar(20), @Creati))
					SET @Msg1= dbo.FncStr (@Msg1,'Modificati: ' + convert (nvarchar(20), @Modificati))

					Set @TypeMsg = 'INF'
				END

			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,@TypeMsg,@SysUser,
					@KYStato,0,'', NULL,@KYMsg out

			SET @KYStato = -1

		RETURN
	END
	
	
	
	/****************************************************************
	--@State 999 @Res 0 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato,999) = 1 and @KYRes = 0
	BEGIN

		/****************************************************************
		* Uscita
		****************************************************************/

		SET @Msg1= 'Operazione annullata'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END
	
END

GO

