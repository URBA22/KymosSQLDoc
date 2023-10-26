import { FsManagerBuilder} from 'src/core';
import { IStoredSqlObject } from '../storedSqlObject';
import { Mode } from './builder';
import { ISqlObject } from '../sqlObject';
import { IDirectory } from 'src/core/fsmanager/core/Directory';
import { FsManager } from 'src/core/fsmanager/fsmanager';

export interface IDocsCreator {
    executeAsync(): Promise<void>;
 }

export class DocsCreator implements IDocsCreator{
    private _storedSqlObjects: IStoredSqlObject[];
    private _destination: IDirectory;
    private _mode: Mode;

    constructor(destination: IDirectory, storedSqlObjects: IStoredSqlObject[], mode: Mode) {
        this._destination = destination;
        this._storedSqlObjects = storedSqlObjects;
        this._mode = mode;
    }

    public async executeAsync(){
        this._storedSqlObjects.forEach(async storedSqlObject =>{
            await this.writeDocs(storedSqlObject);
        });
    }

    private async writeDocs(storedSqlObject: IStoredSqlObject){
        //sqlObject.relativePath
        const fsManager = FsManagerBuilder
            .createFsManager()
            .withAbsolutePath(await FsManager.mergePath(this._destination.directory, this._destination.name))
            .build();
        
        if (!await fsManager.isPath(storedSqlObject.directory.name))
            await fsManager.writeDirectoryAsync('', storedSqlObject.directory.name);
        //await this._destination.writeDirectoryAsync('/docs/', storedSqlObject.directory.name);
        if(this._mode == Mode.md){
            const contentFileDocs = this.createDocsMd(storedSqlObject.sqlObject);
            
            //Scrittura del file md 
            fsManager.writeFileAsync(storedSqlObject.directory.name, storedSqlObject.sqlObject.name + '.md', await contentFileDocs);
        }else{
            const contentFileDocs = this.createDocsHtml(storedSqlObject.sqlObject);
        
            //Scrittura del file html
            fsManager.writeFileAsync(storedSqlObject.directory.name, storedSqlObject.sqlObject.name + '.html', await contentFileDocs);
        }
    }

    private async createDocsMd(sqlObject: ISqlObject){
        let docs = '';

        // nome procedura
        docs += ('# ' + sqlObject.name + '\n');
        docs += ('' + 'sqlObject.desc' + '\n\n');

        //Info
        docs += ('# Info \n');
        docs += ('@Summary ' + sqlObject.info?.summary + '\n');
        docs += ('@Author ' + sqlObject.info?.author + '\n');
        docs += ('@Custom ' + sqlObject.info?.custom + '\n');
        docs += ('@Standard ' + sqlObject.info?.standard + '\n');

        //Version
        docs += ('# Versions \n');
        sqlObject.info?.versions?.forEach(version =>{
            docs += ('' + version.version + ' | ' + version.author + ' | ' + version.description + '\n');
        });

        //Dependecy
        docs += ('# Dependecies \n');
        docs += ('\n| ' + 'schema' + '      | ' + 'name' + '      | ' + 'type' + '       | ' + 'desc' + '          |'+'\n'+'| ------ | -------- | -------- | ------ |\n');
        sqlObject.dependecies?.forEach(dependecy =>{
            docs += ('| ' + (dependecy as ISqlObject).schema + ' | ' + (dependecy as ISqlObject).name + ' | ' + (dependecy as ISqlObject).type + ' | ' + '(dependecy as ISqlObject).desc' + ' |\n');
        });

        //Usage
        docs += ('# Usages \n');
        docs += ('\n| ' + 'schema' + '      | ' + 'name' + '      | ' + 'type' + '       | ' + 'desc' + '          |'+'\n'+'| ------ | -------- | -------- | ------ |\n');
        sqlObject.usages?.forEach(usage =>{
            docs += ('| ' + (usage as ISqlObject).schema + ' | ' + (usage as ISqlObject).name + ' | ' + (usage as ISqlObject).type + ' | ' + '(usage as ISqlObject).desc' + ' |' + '\n');
        });

        docs += ('# Parameter\n');
        docs += ('\n| ' + 'name' + '      | ' + 'type' + '      | ' + 'nullable' + '      | ' + 'output' + '       | ' + 'desc' + '          |'+'\n'+'| ------ | -------- | -------- | -------- | ------ |\n');
        sqlObject.parameters?.forEach(parameter =>{
            docs += ('| ' + parameter.name + ' | '   + parameter.type + ' | '  + parameter.nullable + ' | '  + parameter.output + ' | '  + parameter.description + ' |\n');
        });

        return docs;
    }

    private async createDocsHtml(sqlObject: ISqlObject){
        let docs = '';
        docs += '<h1>' + sqlObject.name + '</h1>';
        docs += ('<p>' + 'descrizione' + '</p>');

        //Info
        docs += ('<br/><h2>Info</h2><hr/><br/>');
        docs += ('<p>@Summary ' + sqlObject.info?.summary + '</p>');
        docs += ('<p>@Author ' + sqlObject.info?.author + '</p>');
        docs += ('<p>@Custom ' + sqlObject.info?.custom + '</p>');
        docs += ('<p>@Standard ' + sqlObject.info?.standard + '</p>');

        //Version
        docs += ('<br/><h2>Versions</h2><hr/><br/><ul>');
        sqlObject.info?.versions?.forEach(version =>{
            docs += ('<li>' + version.version + ' | ' + version.author + ' | ' + version.description + '<li>');
        });

        //Dependecy
        docs += ('</ul><br/><h2>Dependecies</h2><hr/><br/><table>');
        docs += ('<tr><th>' + 'schema' + '</th><th>' + 'name' + '</th><th>' + 'type' + '</th><th>' + 'desc' + '</th></tr>');
        sqlObject.dependecies?.forEach(dependecy =>{
            docs += ('<tr><td>' + (dependecy as ISqlObject).schema + '</td><td>' + (dependecy as ISqlObject).name + '</td><td>' + (dependecy as ISqlObject).type + '</td><td>' + '(dependecy as ISqlObject).desc' + '</td></tr>');
        });

        //Usage
        docs += ('</table><br/><h2>Usages</h2><hr/><br/><table>');
        docs += ('<tr><th>' + 'schema' + '</th><th>' + 'name' + '</th><th>' + 'type' + '</th><th>' + 'desc' + '</th></tr>');
        sqlObject.usages?.forEach(usage =>{
            docs += ('<tr><td>' + (usage as ISqlObject).schema + '</td><td>' + (usage as ISqlObject).name + '</td><td>' + (usage as ISqlObject).type + '</td><td>' + '(usage as ISqlObject).desc' + '</td></tr>');
        });

        docs += ('</table><br/><h2>Parameter</h2><hr/><br/><table>');
        docs += ('<tr><th>' + 'name' + '</th><th>' + 'type' + '</th><th>' + 'nullable' + '</th><th>' + 'output' + '</th><th>' + 'desc' + '</th></tr>');
        sqlObject.parameters?.forEach(parameter =>{
            docs += ('<tr><td>' + parameter.name + '</td><td>'   + parameter.type + '</td><td>'  + parameter.nullable + '</td><td>'  + parameter.output + '</td><td>'  + parameter.description + '</td></tr>');
        });
        docs += ('</table>');
        return docs;
    }
}