-- ==========================================================================================
-- Entity Name:	 VstUtentiCalendari
-- Author:		 auto
-- Create date:	 230510
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- sim 230510 Creazione
-- sim 230512 Aggiunto ColRiga, Semafori
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiCalendari]
AS
	SELECT 
        IdUtenteCalendario, IdUtente, DescCalendario, NoteCalendario, DataInizio, DataFine, FlgAllDay, Organizer, 
        OnlineMeetingUrl, REPLACE(REPLACE(REPLACE(REPLACE(Attendees, '[', ''), ']', ''), '"', ''), ',',  ' - ') AS Attendees, 
        IdO365, CreatedDateTime, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion,
        DATEDIFF(MINUTE, DataInizio, DataFine) AS Durata,
        CASE
            WHEN CONVERT(DATE, GETDATE()) BETWEEN CONVERT(DATE, DataInizio) AND CONVERT(DATE, DataFine) THEN dbo.FncAdmDhColor('GREEN')
        END AS ColRiga,
        CONVERT(smallint, 
            CASE 
                WHEN GETDATE() BETWEEN DataInizio AND DataFine THEN 1  
                WHEN GETDATE() > DataFine THEN 4
                WHEN GETDATE() < DataInizio THEN 5
            END
        ) AS Sem1,
        CONVERT(smallint, NULL) AS Sem2,
        CONVERT(smallint, NULL) AS Sem3,
        CONVERT(smallint, NULL) AS Sem4
	FROM TbUtentiCalendari

GO

