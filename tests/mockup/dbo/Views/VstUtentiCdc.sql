CREATE VIEW dbo.VstUtentiCdc
AS
SELECT        IdUtente, IdCdc, PercCdc, NoteUtenteCdc, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
FROM            dbo.TbUtentiCdc

GO

