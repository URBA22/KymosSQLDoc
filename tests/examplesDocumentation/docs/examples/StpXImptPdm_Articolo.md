# StpXImptPdm_Articolo
Importa macchina o articolo da tabelle di interscambio di Dbo ad articoli e distinte
- Autore : simone
- Custom : YES
- Standard : NO

## Versioni
Autore | Versione | Descrizione
--- | --- | --- 
sim | 230417 | Creazione
dav | 230517 | Aggiornamento

## Parametri
Nome | Tipo | Null | Output | Descrizione
--- | --- | --- | --- | --- 
@IdArticolo | NVARCHAR(50)  | YES| YES | descrizione? 
@SysUser | NVARCHAR(256) | NO | YES | descrizione? 
@KYStato | INT  | YES| YES | descrizione? 
@KYMsg | NVARCHAR(MAX)  | YES| YES | descrizione? 
@KYRes | INT  | YES| NO | descrizione? 
@KYRequest | UNIQUEIDENTIFIER  | YES| YES | descrizione? 
@Debug | BIT  | NO| NO | descrizione? 

### Nessuno Stato
Step di esecuzione che vengono eseguiti indipendentemente dallo stato della procedura

### Stato 0
 Domanda Iniziale

	1. Creo controlli per fascia
	2. Crea XML per fascia


### Stato 1
 @Res 1 Esecuzione procedura

	1. Esplode articolo PDM
	2. inserimento finiture
	3. Prendo Id di Dbo da descrizioni
<details>
		<summary>Creazione articoli</summary>

		4.1. Log nuovo articolo
		4.2. Aggiorno statistiche
		4.3. Inserimento articoli
		4.4. Inserimento unità di misura
</details>

<details>
		<summary>UPDATE anagrafiche articolo</summary>

		5.1. Log cambio descrizione
		5.2. Log cambio peso
		5.3. Log cambio trattamento
		5.4. Log cambio finitura
		5.5. Log cambio categoria merceologica
		5.6. Log cambio categoria
		5.7. Log cambio fonritore
		5.8. Log cambio disegno
		5.9. Log cambio materiale
		5.10. Log cambio percorso file
		5.11. log modifica intera
		5.12. Aggiorno statistiche
		5.13. Update anagrafiche articoli
</details>

<details>
		<summary>UPDATE anagrafiche articolo</summary>

		6.1. Carico la sitinta dell'articolo
			6.2.0IF  Se la distinta ha almeno un record
				6.2.1.0IF  Controllo che ci siano modifche di versione
				6.2.1.1. calcolo nuova versione di distinta
				6.2.1.2. tolgo lo standard dalle altre distinte
				6.2.1.3. Colora di rosso se PDM ha codici doppi in distinta o versioni diverse per stesso articolo
				6.2.1.4. Log modifche
</details>

<details>
		<summary>Operazioni finali</summary>

		7.1. esplode distinta articolo
		7.2. Aggiorna descrizione estesa degli assiemi BUY
		7.3. Aggiorna NoteTec con figlio dell'articolo
		7.4. dav 230315 Setta a Fantasma per distinte articoli BUY
		7.5. Aggiorna distinta in listini fornitori
</details>



### Stato 1
 @Res 0 Annullamento operazione

