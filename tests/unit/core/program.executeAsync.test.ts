#! /usr/bin / env node

import { CommandBuilder, ProgramBuilder } from '../../core';
import ParserBuilder from '../../services/parser/builder';

describe('FsManager ReadFileAsync', () => {

    const version = '0.0.1';

    const command = CommandBuilder
        .createCommand()
        .withTitle('Kymos SQL Docs')
        .withVersion(version)
        .withDescription('Autmatic SQL Server documentation generator.\nPowered by Kymos Srl Sb.')
        .withOption('-s, --source <value>', 'From specific source directory/file')
        .withOption('-o, --out <value>', 'Write documentation to a specific file/drectory')
        .withOption('-f, --format <value>', 'Chose between html and md, or both. Default is md')
        .build();

    const parser = ParserBuilder
        .createParser()
        .build();

    const program = ProgramBuilder
        .createProgram()
        .withCommand(command)
        .withParser(parser)
        .build();


    
    test('Should work fine', () => {
        //TODO: alla fine implementare questo
        //program.executeAsync(process.argv);
    });


    afterAll(() => {
        // TODO: Controlla se esistono e elimina directories e files creati

    });

});