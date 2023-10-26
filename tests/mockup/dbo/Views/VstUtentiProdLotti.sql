

        
-- ==========================================================================================
-- Entity Name:   VstUtentiProdLotti
-- Author:        dav
-- Create date:   11.01.16
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 11.01.16 aggiunto IdOdl
-- dav 24.01.17 aggiunta qta da odldet
-- dav 13.04.17 tolto expr1
-- dav 09.11.17 tolto TbOdlDet.Qta, già presente con alias QtaOdl
-- dav 210601 Gestione colore riga, left join al posto di right
-- ==========================================================================================


CREATE VIEW [dbo].[VstUtentiProdLotti]
AS
SELECT      dbo.TbUtenti.IdUtente, dbo.TbUtenti.CognomeNome, dbo.TbUtentiElab.FlgPresente, dbo.TbProdLotti.IdProdLotto, 
            CASE WHEN TbProdLotti.FlgNonPresidiato = 1 THEN 'NP' WHEN TbProdLotti.FlgPausa = 1 THEN 'PAU' ELSE 'LAV' END AS Stato, dbo.TbProdLotti.IdCdlUnita, dbo.TbProdLottiRegQta.IdArticolo, 
            dbo.TbProdLottiRegQta.Descrizione,dbo.TbOdlDet.IdOdl, dbo.TbOdlDet.Qta AS QtaOdl, drvQtaVersata.QtaVersata, dbo.TbProdLottiRegQta.QtaDaProdurre, dbo.TbProdLotti.Qta AS QtaLotto, '#FFFFFF' AS ColLotto, '#FFFFFF' AS ColUte, 
            dbo.TbUtenti.IdReparto, dbo.TbUtenti.IdReparto AS Ord, 
						 
			CONVERT(smallint, 0) AS Sem1, 
			CONVERT(smallint, 0) AS Sem2, 
			CONVERT(smallint, 0) AS Sem3, 
			CONVERT(smallint, 0) AS Sem4, 
						 
			dbo.TbUtenti.IdCdc,
			drvLotti.ColCausale

FROM        
			dbo.TbUtenti INNER JOIN
			dbo.TbUtentiElab ON dbo.TbUtentiElab.IdUtente = dbo.TbUtenti.IdUtente LEFT OUTER JOIN 
			
			(
				SELECT IdProdLotto, IdUtente, ColCausale
                FROM dbo.TbProdLotti TbProdLotti LEFT OUTER JOIN
				dbo.TbProdCdlCausali TbProdCdlCausali ON TbProdCdlCausali.IdCausaleCdl = TbProdLotti.IdCausaleCdl
                WHERE (FlgLottoChiuso = 0)

                UNION

                SELECT TbProdLottiRegTmp.IdProdLotto, TbProdLottiRegTmp.IdUtente, ColCausale
                FROM dbo.TbProdLottiRegTmp TbProdLottiRegTmp INNER JOIN
				dbo.TbProdLotti TbProdLotti ON TbProdLotti.IdProdLotto = TbProdLottiRegTmp.IdProdLotto LEFT OUTER JOIN
				dbo.TbProdCdlCausali TbProdCdlCausali ON TbProdCdlCausali.IdCausaleCdl = TbProdLotti.IdCausaleCdl
                WHERE (TbProdLottiRegTmp.DataFine IS NULL)
			) AS drvLotti ON drvLotti.IdUtente = dbo.TbUtenti.IdUtente LEFT OUTER JOIN 
           
            dbo.TbProdLotti ON drvLotti.IdProdLotto = dbo.TbProdLotti.IdProdLotto LEFT OUTER JOIN
			dbo.TbProdLottiRegQta ON dbo.TbProdLottiRegQta.IdProdLotto = dbo.TbProdLotti.IdProdLotto LEFT OUTER JOIN
            dbo.TbOdlDetFasi ON dbo.TbProdLottiRegQta.IdOdlDetFase = dbo.TbOdlDetFasi.IdOdlDetFase LEFT OUTER JOIN
            dbo.TbOdlDet ON dbo.TbOdlDetFasi.IdOdlDet = dbo.TbOdlDet.IdOdlDet LEFT OUTER JOIN
            (
				SELECT        IdOdlDetFase, SUM(Qta) AS QtaVersata
                FROM            dbo.TbOdlDetRegTmp
                GROUP BY IdOdlDetFase
			) AS drvQtaVersata ON dbo.TbProdLottiRegQta.IdOdlDetFase = drvQtaVersata.IdOdlDetFase 
              
WHERE        
			(dbo.TbUtenti.FlgProduzione = 1) AND (dbo.TbUtenti.Disabilita = 0)

GO

