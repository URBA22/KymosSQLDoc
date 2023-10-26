import { ICommand } from '../command';
// import { ParserBuilder } from '../../services';
import { FsManager, IFsManager } from '../fsmanager/fsmanager';
import { Root } from '../fsmanager/core/Root';
import { Directory } from '../fsmanager/core/Directory';
import fs from 'fs';
import { InvalidPathError } from '../../services/guardClauses/errors';
import { ISqlObject, SqlObject } from '../../services/sqlObject/sqlObject';
import SqlObjectBuilder from '../../services/sqlObject/builder';
import { Dependecy } from 'src/services/sqlObject/core';
import { IStoredSqlObject, StoredSqlObjectBuilder } from 'src/services/storedSqlObject';
import { DocsCreatorBuilder } from 'src/services/docsCreator';
import { Mode } from 'src/services/docsCreator/builder';


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

    private async createStoredSqlObjects(dir: Directory) {
        const storedObjectsOperations = [];
        const readFileOperations: string[] = [];
        const createDocsOperations: IStoredSqlObject[][] = [];


        for (const subDir of dir.children) {
            createDocsOperations.push(await this.createStoredSqlObjects(subDir));
        }

        for (const file of dir.files.filter(file => file.substring(file.indexOf('.')) == '.sql')) {
            readFileOperations.push(await this.fsManager.readFileAsync(dir.directory, file));
        }

        for (const readFileOperation of readFileOperations) {
            const content = readFileOperation;
            const sqlObject = SqlObjectBuilder.createSqlObject()
                .fromDefinition(content)
                .build()
                .elaborateAsync();

            try{
                const storedSqlObject = StoredSqlObjectBuilder.createStoredSqlObject()
                    .fromDirectory(dir)
                    .withSqlObject(await sqlObject)
                    .build();
                storedObjectsOperations.push(storedSqlObject);
            }catch(error){
                console.log(error);
            }

        }

        let objects: IStoredSqlObject[] = storedObjectsOperations
            .map(objectOperation => {
                return objectOperation;
            })
            .filter(object => object !== undefined) as IStoredSqlObject[];
        
        const objectsSubFolders = createDocsOperations;
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

        const storedSqlObjects = await this.createStoredSqlObjects(sourcePaths.directory); //, destination + '/docs/');
        
        //Dependecies
        const sqlObjects: ISqlObject[] = [];
        storedSqlObjects.forEach(storedSqlObject =>{
            sqlObjects.push(storedSqlObject.sqlObject);
        });
        await Dependecy.fromObjects(sqlObjects);

        const dest = new Directory(destination, 'docs');

        // TODO: wirite .md doc files and directories
        DocsCreatorBuilder
            .createDocsCreator()
            .withDestination(dest)
            .withStoredSqlObjects(storedSqlObjects)
            .withMode(Mode.md)
            .build()
            .executeAsync();
        
    }
}