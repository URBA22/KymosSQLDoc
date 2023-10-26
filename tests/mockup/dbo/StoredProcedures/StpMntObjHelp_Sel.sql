

-- ==========================================================================================
-- Entity Name:	StpMntObjHelp_Sel
-- Create date:	07.05.18
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description: Ritorna informazioni sul controllo
-- History:
-- ==========================================================================================
Create Procedure [dbo].[StpMntObjHelp_Sel]
(
	@IdObject nvarchar(256),
	@DescHelp nvarchar(max),
	@SysUser nvarchar(256)
)
As
Begin
	
	SELECT    @DescHelp =  DescHelp + char(13) + Char(10) + left(NoteHelp,200)  + case when len(NoteHelp) > 200 then '...' else '' end
	FROM            TbMntObjHelp
	WHERE        (IdObject = @IdObject)	

End

GO

