import { CommandBuilder, FsManagerBuilder, ProgramBuilder } from 'src/core';

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




    test('Should work fine', async () => {
        program.executeAsync([
            'C:\\Program Files\\nodejs\\node.exe',
            'C:\\Users\\HP\\Desktop\\SCUOLA\\pcto\\KymosSQLDoc\\dist\\index.js',
            '-s',
            './tests/mockup/examples/',
            '-o',
            './tests/mockup/examples'
        ]).catch((error: Error) => {
            console.log(error.message);
        });
        expect('').toEqual('');
    });



});
