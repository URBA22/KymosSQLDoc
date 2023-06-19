import { ICommand } from '../command';
import { IParser, ParserBuilder } from 'src/services';
import { FsManagerBuilder } from '../fsmanager';
import { FsManager } from '../fsmanager/fsmanager';
import { Readline } from 'readline/promises';
import { Root } from '../fsmanager/core/Root';
import { Directory } from '../fsmanager/core/Directory';
import { Documentation } from '../../services/parser/core/Documentation';
import fs, { readFileSync } from 'fs';
import { InvalidPathError } from 'src/services/guardClauses/errors';


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
        const fsManager = new FsManager();
        await fsManager.writeDirectoryAsync(dest, dir.name);

        await this.CreateDocumentation(dir,dest+'/'+dir.name);

        const createDocFolderThreads: Promise<void>[]=[];

        for(const child of dir.children)
            createDocFolderThreads.push(this.CreateDocFolders(child, dest + '/' + dir.name));
        Promise.all(createDocFolderThreads);
    }

    /**
     * 
     * @param dir 
     * @param dest 
     */
    //crea il file di documentazionenel percorso passato come dest(destinazione)
    public async CreateDocumentation(dir: Directory, dest: string): Promise<void> {
        const fsManager = new FsManager();
        for (const file of dir.files) {
            const content = await fsManager.readFileAsync(dir.directory, file);
            const parser = ParserBuilder
                .createParser()
                .withDefinition(content)
                .build();
            const parsedDocumentation = await parser.parseAsync();
            fsManager.writeFileAsync(dest + '/', file + '.md', content);
        }

    }

/**
 * 
 * @param path 
 * @param file 
 * @returns
 */
    public async ParsingFile(path:string, file: string): Promise<string> {
        const fsManager = new FsManager();
        const doc = new Documentation();
        //conterrà il contenuto del file
        const content = await fsManager.readFileAsync(path,file);
        //array che contiene i parametri fissi da controllare
        const titlesArr: string[] = ['@summary', '@author', '@custom', '@standard', '@version'];
        //descrizione delle @
        const titlesDescriptionArr = await doc.titlesDescription(content, titlesArr);

        //nome procedura
        const procedureName = await doc.getProcedureName(content);

        //contiene i parametri
        const parameters = await doc.getParameters(content, procedureName);

        

        return content;
    }





    public async executeAsync(argv: string[]): Promise<void> {
        const programOptions = await this.command.parseAsync(argv);



        const fsManager = FsManagerBuilder
            .createFsManager()
            .build();



        const source = programOptions.source ?? './';
        const destination = programOptions.destination ?? './';

        


        
        if (!fs.existsSync(source) || !fs.lstatSync(source).isDirectory()){
            throw new InvalidPathError(source);
        }
        if (!fs.existsSync(destination) && !fs.lstatSync(destination).isDirectory()) {
            throw new InvalidPathError(destination);
        }


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