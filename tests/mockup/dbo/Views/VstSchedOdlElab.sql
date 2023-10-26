


CREATE VIEW [dbo].[VstSchedOdlElab]
AS
SELECT dbo.TbSchedOdlElab.IdSchedOdl, dbo.TbSchedOdlElab.QtaProd,

convert (real,VstSchedOdl.QtaProdPerc) QtaProdPerc ,
convert (real,VstSchedOdl.DurataProdPerc) DurataProdPerc,
VstSchedOdl.ColRigaStato

FROM   dbo.VstSchedOdl INNER JOIN
             dbo.TbSchedOdlElab ON dbo.VstSchedOdl.IdSchedOdl = dbo.TbSchedOdlElab.IdSchedOdl

GO

