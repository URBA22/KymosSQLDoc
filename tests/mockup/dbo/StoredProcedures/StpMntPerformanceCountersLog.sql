
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[StpMntPerformanceCountersLog] (@FlgMail BIT = 0, @SysUser nvarchar(256) = NULL)
AS
BEGIN
	SET NOCOUNT ON

	-----------------------------------------------
	-- Elabora dimensioni e dati tabelle
	-----------------------------------------------
	CREATE TABLE #TmpPC (
		[SysDateCreate] [datetime] NOT NULL,
		[CounterName] [nvarchar](128) NOT NULL,
		[CounterNameDet] [nvarchar](128) NOT NULL,
		[DbName] [sysname] NULL,
		[CounterValueProgr] [real] NOT NULL
		)

    Declare @DimData as decimal(18,2)
    Declare @DimLog as decimal(18,2)
    DECLARE @DbName AS NVARCHAR(200)
    
    SET @DbName = DB_NAME()

    SELECT @DimData = size/1024./100.  
    FROM sys.database_files
    where type = 0

    SELECT @DimLog = size /1024./100.
    FROM sys.database_files
    where type = 1

    -- DataFile

    INSERT INTO #TmpPC  (SysDateCreate,  CounterName, CounterNameDet,  DbName, CounterValueProgr)
    VALUES
    (Getdate(), 'DbDimension/Gb', 'Data', '' + @DbName + '', @DimData)

    -- LogFile

    INSERT INTO #TmpPC  (SysDateCreate,  CounterName, CounterNameDet, DbName, CounterValueProgr)
    VALUES
    (Getdate(), 'DbDimension/Gb', 'Log', '' + @DbName + '', @DimLog)

        
    -- TbUteMsg

    INSERT INTO #TmpPC  (SysDateCreate,  CounterName, CounterNameDet, DbName, CounterValueProgr)
    SELECT GETDATE() SysDateCreate, 
        'TbUteMsg/Record' CounterName,
        ISNULL(IdUtente,'--') CounterNameDet,
        '' + @DbName + '' AS DbName,
        COUNT(1) as CounterValueProgr
    FROM dbo.TbUteMsg WITH (NOLOCK)
    GROUP BY
        IdUtente
 
    -- TbUteMsgErr
  
    INSERT INTO #TmpPC  (SysDateCreate,  CounterName, CounterNameDet, DbName, CounterValueProgr)
    SELECT GETDATE() SysDateCreate, 
        'TbUteMsgErr/Record' CounterName,
        ISNULL(IdUtente,'--') CounterNameDet,
        '' + @DbName + '' AS DbName,
        COUNT(1) as CounterValueProgr
    FROM dbo.TbUteMsg WITH (NOLOCK)
    WHERE Messaggio1 = 'Errore Stp'
    GROUP BY
        IdUtente
            
    -- TbUtentiLogAccessi

    INSERT INTO #TmpPC  (SysDateCreate,  CounterName, CounterNameDet, DbName, CounterValueProgr)
    SELECT GETDATE() SysDateCreate, 
        'TbUtentiLogAccessi/Record' CounterName,
        ISNULL(IdUtente,'--') CounterNameDet,
        '' + @DbName + '' AS DbName,
        COUNT(1) as CounterValueProgr
    FROM dbo.TbUtentiLogAccessi WITH (NOLOCK)
    GROUP BY
        IdUtente
           
    -- Tabelle record

    INSERT INTO #TmpPC  (SysDateCreate,  CounterName, CounterNameDet, DbName, CounterValueProgr)
    SELECT 
        GETDATE() AS SysDateCreate,
        'Table/Record' as CounterName,
        s.name + '.' + t.name  AS CounterNameDet,
        '' + @DbName + '' AS DbName,
        p.rows as CounterValueProgr
    FROM 
        sys.tables t
    INNER JOIN 
        sys.partitions p ON t.object_id = p.object_id AND t.object_id = p.object_id
    LEFT OUTER JOIN 
        sys.schemas s ON t.schema_id = s.schema_id
    WHERE 
        p.index_id in (1,0)

    -- Tabelle dimensione

    INSERT INTO #TmpPC  (SysDateCreate,  CounterName, CounterNameDet, DbName, CounterValueProgr)
    SELECT 
        GETDATE() AS SysDateCreate,
        'Table/TotalSpaceMB' as CounterName,
        s.name + '.' + t.name  AS CounterNameDet,
        '' + @DbName + '' AS DbName,
        CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS  CounterValueProgr
    FROM 
        sys.tables t
    INNER JOIN      
        sys.partitions p ON t.object_id = p.object_id AND t.object_id = p.object_id
    INNER JOIN 
        sys.allocation_units a ON p.partition_id = a.container_id
    LEFT OUTER JOIN 
        sys.schemas s ON t.schema_id = s.schema_id
    WHERE 
        p.index_id in (1,0)
    GROUP BY
        s.name + '.' + t.name

	-----------------------------------------------
	-- Registra log transizioni
	-----------------------------------------------

	INSERT INTO #TmpPC (
		SysDateCreate,
		CounterName,
		CounterNameDet,
		DbName,
		CounterValueProgr
		)
	SELECT GETDATE() AS SysDateCreate,
		RTRIM(counter_name) CounterName,
		'' CounterNameDet,
        RTRIM(instance_name) AS DbName,
		dm_os_performance_counters.cntr_value CounterValueProgr
	FROM sys.dm_os_performance_counters
	-- INNER JOIN sys.databases
	-- 	ON dm_os_performance_counters.instance_name = databases.physical_database_name
	WHERE  
        instance_name = @DbName AND
        counter_name = 'Transactions/sec'

	-----------------------------------------------
	-- Elabora valori assoluti
	-----------------------------------------------
	SELECT TbMntPerformanceCountersLog.DbName,
		TbMntPerformanceCountersLog.CounterName,
		TbMntPerformanceCountersLog.CounterNameDet,
		TbMntPerformanceCountersLog.CounterValueProgr
	INTO #TmpPCMax
	FROM TbMntPerformanceCountersLog
	INNER JOIN (
		SELECT
			CounterName,
			CounterNameDet,
			Max(IdLog) IdLog
		FROM TbMntPerformanceCountersLog
		GROUP BY 
			CounterName,
			CounterNameDet
		) drvMax
		ON drvMax.IdLog = TbMntPerformanceCountersLog.IdLog

	-----------------------------------------------
	-- Logga
	-----------------------------------------------
	INSERT INTO TbMntPerformanceCountersLog (
		SysDateCreate,
		CounterName,
		CounterNameDet,
		DbName,
		CounterValueProgr,
		CounterValue
		)
	SELECT TmpPc.SysDateCreate,
		TmpPc.CounterName,
		TmpPc.CounterNameDet,
		TmpPc.DbName,
		TmpPc.CounterValueProgr,
		isnull(TmpPc.CounterValueProgr - TmpPcMax.CounterValueProgr, TmpPc.CounterValueProgr)
	FROM #TmpPC TmpPc
	LEFT OUTER JOIN #TmpPCMax TmpPcMax
		ON 
			TmpPc.CounterName = TmpPcMax.CounterName
			AND TmpPc.CounterNameDet = TmpPcMax.CounterNameDet
    WHERE 
        isnull(TmpPc.CounterValueProgr - TmpPcMax.CounterValueProgr, TmpPc.CounterValueProgr) <> 0


/*
    -- monitoarer dimensioni db
    -- monitorare tempi di esecuzione procedure select * , executiontime/60/60/60. from TbCmdLog order by ProcedureName,sysdate desc
    -- monitoarre log utenti
    -- uniformarmare utenti servizi, gesitone psw e cosa possono fare
    -- monitorare numeo documenti creati
    -- verificare DboDecortex select * from TbUtentiLogAccessi where IDutente ='mila'
    -- monitoarre data aggiornamento select * from TbSettingKey where idkey ='datadbagg'
    -- monitoarre data elab select * from TbSettingKey where idkey ='DataElabDb'
   
    -- analisi
        select * from TbMntPerformanceCountersLog  order by dbname, idlog desc

    -- analisi media
        select DbName, CounterName, Sum(CounterValue), Max(CounterValueProgr) from TbMntPerformanceCountersLog  
        where countername ='TbUtentiLogAccessi/Record'
        group by DbName, CounterName
        order by dbname, countername

    -- analisi per dettaglio
        select DbName, CounterName,CounterNameDet, Sum(CounterValue), Max(CounterValueProgr) from TbMntPerformanceCountersLog  
        where countername ='TbUtentiLogAccessi/Record' AND counternamedet not in ('cybe','DboConnector','service01','DboServizio','CybeConnector','service','dbocvelo01','DboCServer')
        group by DbName, CounterName,CounterNameDet
        order by Max(CounterValueProgr) desc, dbname, countername,CounterNameDet

   */




			/*
    select count(*) LogRowDay, count(*)/60. LogRowMin, datepart(HOUR, SysDateCreate) AS Ora from DBOEXPERT.dbo.tblog with (nolock)
        where convert(date ,SysDateCreate)= convert(date,getdate())
        group by  datepart(HOUR, SysDateCreate) 

select count(*) LogRowDay, count(*)/60. LogRowMin, datepart(HOUR, SysDateCreate) AS Ora, TipoLog, DescLog from DBOEXPERT.dbo.tblog with (nolock)
        where convert(date ,SysDateCreate)= convert(date,getdate())
        group by  datepart(HOUR, SysDateCreate) , TipoLog, DescLog

        SELECT
  t.object_id,
  OBJECT_NAME(t.object_id) ObjectName,
  sum(u.total_pages) * 8 Total_Reserved_kb,
  sum(u.used_pages) * 8 Used_Space_kb,
  u.type_desc,
  max(p.rows) RowsCount
FROM
  sys.allocation_units u
  JOIN sys.partitions p on u.container_id = p.hobt_id

  JOIN sys.tables t on p.object_id = t.object_id

GROUP BY
  t.object_id,
  OBJECT_NAME(t.object_id),
  u.type_desc
ORDER BY
  Used_Space_kb desc,
  ObjectName;

        */
END

GO

