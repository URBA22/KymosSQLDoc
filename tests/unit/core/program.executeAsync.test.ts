import { CommandBuilder, FsManagerBuilder, ProgramBuilder } from 'src/core';
import fs, { rmSync, unlinkSync }from 'fs';

describe('ExecuteAsync', () => {


    const version = '0.0.1';

    const command = CommandBuilder
        .createCommand()
        .withTitle('Kymos SQL Docs')
        .withVersion(version)
        .withDescription('Autmatic SQL Server documentation generator.\nPowered by Kymos Srl Sb.')
        .withOption('-s, --source <value>', 'From specific source directory/file')
        .withOption('-o, --out <value>', 'Write documentation to a specific file/drectory')
        // .withOption('-f, --format <value>', 'Chose between html and md, or both. Default is md')
        .build();


    const fsManager = FsManagerBuilder
        .createFsManager()
        .build();


    const program = ProgramBuilder
        .createProgram()
        .withCommand(command)
        .withFsManager(fsManager)
        .build();

    beforeAll(() => {
        fsManager.writeDirectoryAsync('./tests/','examplesDocumentation');
    });


    test('Should work fine', async () => {
        await program.executeAsync([
            'C:\\Program Files\\nodejs\\node.exe',
            'C:\\Users\\HP\\Desktop\\SCUOLA\\pcto\\KymosSQLDoc\\dist\\index.js',
            '-s',
            './tests/mockup/examples',
            '-o',
            './tests/examplesDocumentation'
        ]).catch((error: Error) => {
            console.log(error.message);
        });
        const res = await fsManager.readFileAsync('./tests/examplesDocumentation/docs/examples/', 'StpXImptPdm_Articolo.md');
        const expected ='# StpXImptPdm_Articolo\nImporta macchina o articolo da tabelle di interscambio di Dbo ad articoli e distinte\n- Autore : simone\n- Custom : YES\n- Standard : NO\n\n## Versioni\nAutore | Versione | Descrizione\n--- | --- | --- \nsim | 230417 | Creazione\ndav | 230517 | Aggiornamento\n\n## Parametri\nNome | Tipo | Null | Output | Descrizione\n--- | --- | --- | --- | --- \n@IdArticolo | NVARCHAR(50)  | YES| YES | descrizione? \n@SysUser | NVARCHAR(256) | NO | YES | descrizione? \n@KYStato | INT  | YES| YES | descrizione? \n@KYMsg | NVARCHAR(MAX)  | YES| YES | descrizione? \n@KYRes | INT  | YES| NO | descrizione? \n@KYRequest | UNIQUEIDENTIFIER  | YES| YES | descrizione? \n@Debug | BIT  | NO| NO | descrizione? \n';
        expect(res).toEqual(expected);
    });
 

    afterAll(() => {

        fs.rmSync('tests/examplesDocumentation', { recursive: true, force: true}); 
    });

});
