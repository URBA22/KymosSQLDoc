-- ==========================================================================================
-- Entity Name:   StpMntObj_Analisi 
-- Author:        dav
-- Create date:   210420
-- Custom_Dbo:    NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Elaborazione dati dei database T1, oppure di un database specifico.
-- History:       
-- Simone 210420 Creazione
-- ==========================================================================================

CREATE Procedure [dbo].[StpMntObj_Analisi]
(
	@DataBaseName NVARCHAR(50) -- IN @DataBaseName IMMETTERE IL NOME DAL DATABASE DA ANALIZZARE, SE NON SI VUOLE UN DATABASE IN PARTICOLARE, LASCIARE SOLO T1
)

AS
BEGIN

-------------------------------------
-- Esegue il comando
-------------------------------------

-- USE master !!!! DA LANCIARE SOLO IN MASTER

-- RISULTATI (Tempo di esecuzione per elaborare tutti i DataBase 'T1': ~ 60 minuti):

-- LA PRIMA QUERY (DETTAGLIO) E' COSI' COMPOSTA:
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DbName               :   Nome del DataBase
-- Year                 :   Anno dell'inserimento del record
-- TableName            :   Nome della tabella (vengono considerate solo le tabelle che iniziano con 'Tb' e hanno la colonna SysDateCreate. Le tabelle Elab vengono quindi escluse)
-- RowNumber            :   Numero di righe della tablla [TableName] create nell'anno [Year]
-- Total_Mb             :   Mb totali dell'intera tabella (tutti i record)
-- Total_Mb_Ponderati   :   Mb della tabella ponderati in base a [RowNumber]
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- LA SECONNDA QUERY (RIASSUNTO) E' COSI' COMPOSTA:
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DbName               :   Nome del DataBase
-- Year                 :   Anno dell'inserimento del record
-- TotalRows            :   Numero di record inseriti nel database [DbName], nelle tabelle elaborate nella query di dettaglio, creati nell'anno [Year]
-- Total_Size_Mb        :   Somma delle dimensioni totali (tutti i record) SOLO delle tabelle elaborate nella query di dettaglio
-- Total_Mb_Ponderati    :   Mb totali del database (SOLO delle tabelle elaborate nella query di dettaglio), ponderati in base a [TotalRows]
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- IN @DataBaseName IMMETTERE IL NOME DAL DATABASE DA ANALIZZARE, SE NON SI VUOLE UN DATABASE IN PARTICOLARE, LASCIARE SOLO T1
SET @DataBaseName = ISNULL(@DataBaseName, 'T1')


DECLARE @Sql_Before NVARCHAR(2000) -- MAX 2000!!!
DECLARE @Sql NVARCHAR(2000) -- MAX 2000!!!
DECLARE @Sql_After NVARCHAR(2000) -- MAX 2000!!!

SET @Sql_Before = '
IF ''?'' LIKE ''%' + @DataBaseName + '''
    PRINT ''Inizio Elaborazione ... ?''
'

SET @Sql = '
IF ''?'' LIKE ''%' + @DataBaseName + '''
BEGIN
USE [?]
DECLARE @Sql NVARCHAR(MAX)
DROP TABLE IF EXISTS RisultatoELaborazioneSimone
DECLARE @QueryResult1 TABLE ( object_id int, Year SMALLINT NULL, RowNumber BIGINT)
CREATE TABLE RisultatoELaborazioneSimone (
    DbName SYSNAME NULL, 
    Year SMALLINT NULL, 
    TableName SYSNAME, 
    RowNumber BIGINT, 
    Total_Mb NUMERIC(36, 2),
    Total_Mb_Ponderati NUMERIC(36, 2) NULL)
SET @Sql = ''
IF ''''#'''' LIKE ''''\[dbo\].\[Tb%'''' {escape ''''\''''} AND EXISTS (SELECT * FROM sys.columns WHERE object_id = object_id(''''#'''') AND name = ''''SysDateCreate'''')
BEGIN EXEC (''''SELECT OBJECT_ID(N''''''''#''''''''), YEAR(SysDateCreate), COUNT(*) FROM # GROUP BY YEAR(SysDateCreate) HAVING YEAR(SysDateCreate) IN (2018, 2019, 2020)'''')
END''
INSERT INTO @QueryResult1
EXEC sp_MSforeachtable @sql, ''#''
INSERT INTO RisultatoELaborazioneSimone
SELECT ''?'' AS DbName, [@QueryResult1].[Year] AS Year, sys.tables.name AS TableName, ISNULL([@QueryResult1].[RowNumber], 0) AS RowNumber,CAST(ROUND((SUM(sys.allocation_units.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_Mb, NULL AS Total_Mb_Ponderati
FROM sys.tables
INNER JOIN sys.indexes ON sys.tables.object_id = sys.indexes.object_id
INNER JOIN sys.partitions ON sys.indexes.object_id = sys.partitions.object_id AND sys.indexes.index_id = sys.partitions.index_id
INNER JOIN sys.allocation_units ON sys.partitions.partition_id = sys.allocation_units.container_id
LEFT OUTER JOIN @QueryResult1 ON sys.tables.object_id = [@QueryResult1].object_id
WHERE sys.tables.name LIKE ''Tb%''
GROUP BY sys.tables.name, [@QueryResult1].[Year], [@QueryResult1].[RowNumber]
ORDER BY sys.tables.name, [@QueryResult1].[Year]
END'

SET @Sql_After = '
IF ''?'' LIKE ''%' + @DataBaseName + '''
BEGIN
USE [?]
UPDATE RisultatoELaborazioneSimone
SET Total_Mb_Ponderati = ((RisultatoELaborazioneSimone.Total_Mb / drvTot.TotRow) * RisultatoELaborazioneSimone.RowNumber)
FROM RisultatoELaborazioneSimone
INNER JOIN (
    SELECT DbName, 
    SUM(RowNumber) AS TotRow, 
    TableName FROM RisultatoELaborazioneSimone GROUP BY DbName, 
    TableName HAVING SUM(RowNumber) > 0) AS drvTot ON drvTot.DbName = RisultatoELaborazioneSimone.DbName AND drvTot.TableName = RisultatoELaborazioneSimone.TableName 
PRINT ''Fine Elaborazione ... ?''
END'

DROP TABLE IF EXISTS [Dbo].dbo.TbXDettaglioElaborazioneDb;
DROP TABLE IF EXISTS [Dbo].dbo.TbXRiassuntoElaborazioneDb;

CREATE TABLE [Dbo].dbo.TbXDettaglioElaborazioneDb (
    DbName SYSNAME NULL,
    Year SMALLINT NULL,
    TableName SYSNAME,
    RowNumber BIGINT,
    -- Used_Mb NUMERIC(36, 2),
    -- Unused_Mb NUMERIC(36, 2),
    Total_Mb NUMERIC(36, 2),
    Total_Mb_Ponderati NUMERIC(36, 2) NULL
)

EXEC sp_MSforeachdb @Sql_Before, '?', @Sql, @Sql_After

SET @Sql_Before = '
IF ''?'' LIKE ''%' + @DataBaseName + '''
    PRINT ''Inizio Inserimento ... ?''
'

SET @Sql = '
IF ''?'' LIKE ''%' + @DataBaseName + '''
BEGIN
    USE [?]
    SELECT * FROM RisultatoELaborazioneSimone
END'

SET @Sql_After = '
IF ''?'' LIKE ''%' + @DataBaseName + '''
BEGIN  
    USE [?]
    DROP TABLE IF EXISTS RisultatoELaborazioneSimone;
    PRINT ''Fine Inserimento ... ?''
END
'

INSERT INTO [Dbo].dbo.TbXDettaglioElaborazioneDb
EXEC sp_MSforeachdb @Sql_Before, '?', @Sql, @Sql_After

SELECT * FROM [Dbo].dbo.TbXDettaglioElaborazioneDb

SELECT [Dbo].dbo.TbXDettaglioElaborazioneDb.DbName, Year, SUM(RowNumber) AS TotalRows, SUM(Total_Mb) AS Total_Size_Mb, ((SUM(Total_Mb) / CASE WHEN ISNULL(drvTot.TotRow, 0) = 0 THEN 1 ELSE drvTot.TotRow END) * SUM(RowNumber)) AS Total_Mb_Ponderati INTO [Dbo].dbo.TbXRiassuntoElaborazioneDb
FROM [Dbo].dbo.TbXDettaglioElaborazioneDb
LEFT JOIN (SELECT DbName, SUM(RowNumber) AS TotRow FROM [Dbo].dbo.TbXDettaglioElaborazioneDb GROUP BY DbName HAVING SUM(RowNumber) > 0) AS drvTot ON drvTot.DbName = [Dbo].dbo.TbXDettaglioElaborazioneDb.DbName
GROUP BY [Dbo].dbo.TbXDettaglioElaborazioneDb.DbName, Year, drvTot.TotRow
ORDER BY [Dbo].dbo.TbXDettaglioElaborazioneDb.DbName, [Year]

RETURN
END

GO

