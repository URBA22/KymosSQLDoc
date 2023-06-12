#! /usr/bin/env node

import { argv } from 'process';
import { CommandBuilder, FsManagerBuilder, ProgramBuilder } from './core';
import { Directory } from './core/fsmanager/fsmanager';
import ParserBuilder from './services/parser/builder';

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

const fsManager = FsManagerBuilder
    .createFsManager()
    .build();

const parser = ParserBuilder
    .createParser()
    .withFsManager(fsManager)
    .build();

const program = ProgramBuilder
    .createProgram()
    .withCommand(command)
    .withParser(parser)
    .build();

program.executeAsync(process.argv);