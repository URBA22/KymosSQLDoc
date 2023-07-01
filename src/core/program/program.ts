import { ICommand } from '../command';
import { ParserBuilder } from '../../services';
import { FsManager, IFsManager } from '../fsmanager/fsmanager';
import { Root } from '../fsmanager/core/Root';
import { Directory } from '../fsmanager/core/Directory';
import fs from 'fs';
import { InvalidPathError } from '../../services/guardClauses/errors';


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

    private async createDocFolders(dir: Directory, dest: string) {
        // TODO: use an object to store definitions (IParser) and locations, then writes file and directories
        // { name: '', location '', definition: IParser,  documentation: '' } []
        // For dependecies, use IParser.contains(objName: string);
        // First, push all the definition
        // After, parse all
        // Then create files

        const fsManager = new FsManager();

        await fsManager.writeDirectoryAsync(dest, dir.name);

        await this.createDocumentation(dir, dest + '/' + dir.name);

        const createDocFolderThreads: Promise<void>[] = [];

        for (const child of dir.children)
            createDocFolderThreads.push(this.createDocFolders(child, dest + '/' + dir.name));

        Promise.all(createDocFolderThreads);
    }


    private async createDocumentation(dir: Directory, dest: string): Promise<void> {
        dir.files = dir.files.filter(file => file.substring(file.indexOf('.')) == '.sql');
        for (const file of dir.files) {
            const content = await this.fsManager.readFileAsync(dir.directory, file);
            const parser = ParserBuilder
                .createParser()
                .withDefinition(content)
                .build();
            const parsedDocumentation = await parser?.parseAsync();
            this.writeFile(dest, file, parsedDocumentation as string);
        }

    }

    private async writeFile(dest: string, file: string, parsedDocumentation: string): Promise<void> {
        if (parsedDocumentation.replace(/((\n)|(\t)|(\r)|[ ]|-)+/g, ' ') != '')
            this.fsManager.writeFileAsync(dest + '/', file.replace('.sql', '.md'), parsedDocumentation);
    }




    /**
     * Start program execution. 
     * @param argv Process arguments
     * @returns void
     */
    public async executeAsync(argv: string[]): Promise<void> {
        const programOptions = await this.command.parseAsync(argv);

        const source = programOptions.source ?? './';
        const destination = programOptions.out ?? './';

        // TODO: change fs with this.fsManager
        if (!fs.existsSync(source) || !fs.lstatSync(source).isDirectory()) {
            throw new InvalidPathError(source);
        }
        if (!fs.existsSync(destination) && !fs.lstatSync(destination).isDirectory()) {
            throw new InvalidPathError(destination);
        }

        const sourcePaths: Root = await this.fsManager.readDirectoryAsync(source);

        // TODO: change fs with this.fsManager
        if (!fs.existsSync(await FsManager.mergePath(destination, 'docs/')))
            await this.fsManager.writeDirectoryAsync(destination, 'docs');

        return this.createDocFolders(sourcePaths.directory, destination + '/docs/');
    }
}