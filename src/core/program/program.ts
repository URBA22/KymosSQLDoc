import { ICommand } from '../command';
// import { ParserBuilder } from '../../services';
import { FsManager, IFsManager } from '../fsmanager/fsmanager';
import { Root } from '../fsmanager/core/Root';
import { Directory } from '../fsmanager/core/Directory';
import fs from 'fs';
import { InvalidPathError } from '../../services/guardClauses/errors';
import { ISqlObject } from '../../services/sqlObject/sqlObject';
import SqlObjectBuilder from '../../services/sqlObject/builder';
import { Dependecy } from 'src/services/sqlObject/core';


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

    private async createSqlObjects(dir: Directory) {
        const objectsOperations: Promise<ISqlObject>[] = [];
        const readFileOperations: Promise<string>[] = [];
        const createDocsOperations: Promise<ISqlObject[]>[] = [];

        for (const subDir of dir.children) {
            createDocsOperations.push(this.createSqlObjects(subDir));
        }

        for (const file of dir.files.filter(file => file.substring(file.indexOf('.')) == '.sql')) {
            readFileOperations.push(this.fsManager.readFileAsync(dir.directory, file));
        }

        for (const readFileOperation of await Promise.allSettled(readFileOperations)) {
            const content = readFileOperation.status === 'fulfilled' ? readFileOperation.value : '';
            objectsOperations.push(SqlObjectBuilder.createSqlObject()
                .fromDefinition(content)
                .build()
                .elaborateAsync());
        }

        let objects: ISqlObject[] = (await Promise.allSettled(objectsOperations))
            .map(objectOperation => {
                if (objectOperation.status === 'fulfilled')
                    return objectOperation.value;
            })
            .filter(object => object !== undefined) as ISqlObject[];
        
        const objectsSubFolders = (await Promise.allSettled(createDocsOperations))
            .map(objectOperation => {
                if (objectOperation.status === 'fulfilled')
                    return objectOperation.value;
            })
            .filter(object => object !== undefined && object.length == 0) as ISqlObject[][];
        
        objects = objects.concat(...objectsSubFolders); 
        
        return objects;
    }


    // private async createDocumentation(dir: Directory, dest: string): Promise<void> {
    //     dir.files = dir.files.filter(file => file.substring(file.indexOf('.')) == '.sql');
    //     for (const file of dir.files) {
    //         const content = await this.fsManager.readFileAsync(dir.directory, file);
    //         const parser = ParserBuilder
    //             .createParser()
    //             .withDefinition(content)
    //             .build();
    //         const parsedDocumentation = await parser?.parseAsync();
    //         this.writeFile(dest, file, parsedDocumentation as string);
    //     }

    // }

    // private async writeFile(dest: string, file: string, parsedDocumentation: string): Promise<void> {
    //     if (parsedDocumentation.replace(/((\n)|(\t)|(\r)|[ ]|-)+/g, ' ') != '')
    //         this.fsManager.writeFileAsync(dest + '/', file.replace('.sql', '.md'), parsedDocumentation);
    // }




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

        const objects = await this.createSqlObjects(sourcePaths.directory); //, destination + '/docs/');

        await Dependecy.fromObjects(objects);

        // TODO: wirite .md doc files and directories

        
    }
}