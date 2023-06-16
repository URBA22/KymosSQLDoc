import { ICommand } from '../command';
import { IParser } from 'src/services';
import { FsManagerBuilder } from '../fsmanager';
import { FsManager } from '../fsmanager/fsmanager';
import { Readline } from 'readline/promises';
import { Root } from '../fsmanager/core/Root';
import { Directory } from '../fsmanager/core/Directory';
import { Docs } from '../fsmanager/core/Docs';
import fs, { readFileSync } from 'fs';


export interface IProgram {
    executeAsync(argv: string[]): Promise<void>;
}

export class Program implements IProgram {
    private command: ICommand;
    private parser: IParser;

    constructor(command: ICommand, parser: IParser) {
        this.command = command;
        this.parser = parser;
    }

    public async CreateDocFolders(dir: Directory, dest: string){
        const destPath: string = dest + '/' + dir.name;
        fs.mkdirSync(destPath);
        this.CreateDocumentation(dir,destPath);
        for(const child of dir.children)
            await this.CreateDocFolders(child, destPath);
    }

    public async CreateDocumentation(dir: Directory, dest: string): Promise<void> {
        const docs = new Docs;
        for (const file of dir.files) {
            const content = await this.ParsingFile(dir.directory, file);
            docs.FileNameGuard(file);
            fs.writeFileSync(dest + '/' + file + '.md', content);
        }

    }

    public async ParsingFile(path:string, file: string): Promise<string> {
        const fsManager = new FsManager();
        const docs = new Docs();
        let content = '';
        content = await fsManager.readFileAsync(path,file);
        const titlesArr: string[] = ['@summary', '@author', '@custom', '@standard', '@version'];
        const titlesDescriptionArr = await docs.titlesDescription(content, titlesArr);
        return content;
    }





    public async executeAsync(argv: string[]): Promise<void> {
        const programOptions = await this.command.parseAsync(argv);


        let command = '';

        for (let i = 2; i < argv.length; i++) {
            command+=argv[i];
        }

        console.log(command);


        const fsManager = FsManagerBuilder
            .createFsManager()
            .build();



        let source = './';
        let destination = './';

        if (command.includes('-s'))
            if (command.includes('-o')) {
                source = (command.substring(command.indexOf('-s') + 2, command.indexOf('-o'))).trim();
                destination = (command.substring(command.indexOf('-o') + 2)).trim();
            }
            else {
                source = (command.substring(command.indexOf('-s') + 2)).trim();
            }
        else
        if (command.includes('-o'))
            destination = (command.substring(command.indexOf('-o') + 2)).trim();

        if (!fs.existsSync(source) || !fs.lstatSync(source).isDirectory()){
            console.log('invalid source path');
            return;
        }
            
        if (!fs.existsSync(destination) && !fs.lstatSync(destination).isDirectory()) {
            console.log('invalid destination path');
            return;
        }


        console.log(source);
        console.log(destination);

        const sourcePaths: Root = await fsManager.readDirectoryAsync(source);


        // 1. prende argomento -s oppure ./ -> source
        // 2. prende argomento -o oppure ./ -> destination

        // 3. contrtolla che source e destination sia una directory

        // 4. legge la directory source
        // 5. guarda la cartella restituita
        // 6. per ogni file nella cartella:
        //      6.1. esegue il parsing della documentazione
        //      6.2. crea una cartella speculare in destination
        //      6.3. crea un file .md con stesso nome e con documentazione
        // 7. ripete punto 6 per tutte le sotto directory 

        console.log(programOptions);
    }
}