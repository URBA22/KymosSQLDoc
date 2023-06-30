import { ICommand } from '../command';
import { ParserBuilder } from '../../services';
import { FsManager, IFsManager } from '../fsmanager/fsmanager';
import { Root } from '../fsmanager/core/Root';
import { Directory } from '../fsmanager/core/Directory';
import { Utilities } from '../../services/parser/core/utilities';
import fs, { existsSync, mkdir } from 'fs';
import { InvalidPathError } from '../../services/guardClauses/errors';
import { StoredProcedureParser } from '../../services/parser/storedProcedureParser';


export interface IProgram {
    executeAsync(argv: string[]): Promise<void>;
}

export class Program implements IProgram {
    private command: ICommand;
    private fsManager: IFsManager;

    constructor(command: ICommand, fsManager: IFsManager) {
        this.command = command;
        this.fsManager = fsManager;
    }

    public async createDocFolders(dir: Directory, dest: string) {
        const fsManager = new FsManager();

        await fsManager.writeDirectoryAsync(dest, dir.name);

        await this.createDocumentation(dir, dest + '/' + dir.name);

        const createDocFolderThreads: Promise<void>[] = [];

        for (const child of dir.children)
            createDocFolderThreads.push(this.createDocFolders(child, dest + '/' + dir.name));
        Promise.all(createDocFolderThreads);
    }

    /**
     * crea il file di documentazionenel percorso passato come dest(destinazione)
     * @param dir 
     * @param dest 
     */
    public async createDocumentation(dir: Directory, dest: string): Promise<void> {
        dir.files = dir.files.filter(file => file.substring(file.indexOf('.')) == '.sql');
        for (const file of dir.files) {
            const content = await this.fsManager.readFileAsync(dir.directory, file);
            const parser = ParserBuilder
                .createParser()
                .withDefinition(content)
                .build();
            const parsedDocumentation = await parser?.parseAsync();
            this.ifNotEmptyWriteFile(dest, file, parsedDocumentation as string);
        }

    }

    public async ifNotEmptyWriteFile(dest:string, file:string, parsedDocumentation:string): Promise<void>{
        if (parsedDocumentation.replace(/((\n)|(\t)|(\r)|[ ]|-)+/g, ' ')!='')
            this.fsManager.writeFileAsync(dest + '/', file.substring(0, file.indexOf('.sql')) + '.md', parsedDocumentation);

    }





    public async executeAsync(argv: string[]): Promise<void> {
        const programOptions = await this.command.parseAsync(argv);



        const source = programOptions.source ?? './';
        const destination = programOptions.out ?? './';





        if (!fs.existsSync(source) || !fs.lstatSync(source).isDirectory()) {
            throw new InvalidPathError(source);
        }
        if (!fs.existsSync(destination) && !fs.lstatSync(destination).isDirectory()) {
            throw new InvalidPathError(destination);
        }


        const sourcePaths: Root = await this.fsManager.readDirectoryAsync(source);

        if (!existsSync(destination + 'docs /'))
            await this.fsManager.writeDirectoryAsync(destination, 'docs');
            
        await this.createDocFolders(sourcePaths.directory, destination + '/docs/');

        


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