CREATE TYPE [dbo].[TypChart] AS TABLE (
    [Ord]        NVARCHAR (50)   NULL,
    [Serie]      NVARCHAR (50)   NULL,
    [AsseX]      NVARCHAR (50)   NULL,
    [AsseY]      DECIMAL (18, 8) NULL,
    [SerieType]  NVARCHAR (50)   NULL,
    [SerieStack] NVARCHAR (50)   NULL,
    [SerieColor] NVARCHAR (50)   NULL);


GO

