import { FsManagerBuilder} from 'src/core';
import { IStoredSqlObject } from '../storedSqlObject';
import { Mode } from './builder';
import { ISqlObject } from '../sqlObject';
import { IDirectory } from 'src/core/fsmanager/core/Directory';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { Dependecy } from '../sqlObject/core';

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

    private verbatimDocsMd(str: string | undefined){
        if(str == undefined) return '';
        return '````{verbatim, lang = "markdown"}\n' + str + '\n````';
    }

    private spaceDocs( length: number, str: string|undefined = undefined, space = '&ensp;',){
        if(str == undefined) str = '';
        const toAdd  = length - str.length;
        for(let i = 0; i < toAdd; i++) str += space;
        return str;
    }

    private tableDocsMd(header: string[], content:(string|undefined)[][], minWidth = 0){
        let table = '|';
        header.forEach(columnHeader => {
            table += (' ' + this.spaceDocs(minWidth, columnHeader) + '  |');
        });

        table += '\n|';
        header.forEach(p => {
            table += (' ------ |');
        });

        content.forEach(row => {
            table += '\n|';
            row.forEach(column => {
                table += (' ' + column + '  |');
            });
        });
        table += '\n';
        return table;
    }

    private async createDocsMd(sqlObject: ISqlObject){
        let docs = '';

        // nome procedura
        {
            docs += ('# ' + (sqlObject.schema) + ' - ' + (sqlObject.name) + '\n');
            docs += ('' + (sqlObject.type?.toString()) + '\n');
        }

        //Info
        {
            docs += ('## Info \n');
            docs += ('@Summary **' + (sqlObject.info?.summary) + '**  \n');
            docs += ('@Author **' + (sqlObject.info?.author) + '**  \n');
            docs += ('@Custom **' + (sqlObject.info?.custom) + '**  \n');
            docs += ('@Standard **' + (sqlObject.info?.standard) + '**  \n');
        }

        //Version
        {
            docs += ('## Versions \n');
            docs += ('`version `' + this.spaceDocs(2, undefined) + this.spaceDocs(10, '_author_') + this.spaceDocs(2, undefined) + this.spaceDocs(10, '_desc_') + '  \n');
            sqlObject.info?.versions?.forEach(version =>{
                docs += ('`' + version.version + '. `' + this.spaceDocs(2, undefined) + this.spaceDocs(10, version.author) + this.spaceDocs(2, undefined) + this.spaceDocs(10, version.description) + '  \n');
            });
        }

        //Parameters
        {
            docs += ('## Parameter\n');
            const paramHeader = ['name', 'type', 'nullable', 'output'];
            const paramRow:(string|undefined)[][] = [];
            sqlObject.parameters?.forEach(parameter =>{
                paramRow.push([parameter.name, parameter.type, parameter.nullable.toString(), parameter.output.toString()]);
            });
            docs += this.tableDocsMd(paramHeader, paramRow, 20);
        }

        //Dependecy
        {
            docs += ('## Dependecies \n');
            const depenHeader = ['schema', 'name', 'type', 'description'];
            const depenRow:(string|undefined)[][] = [];
            sqlObject.dependecies?.forEach(dependecy =>{
                depenRow.push([(dependecy as ISqlObject).schema, '['+(dependecy as ISqlObject).name+'](./'+(dependecy as ISqlObject).name+'.md)', (dependecy as ISqlObject).type?.toString(), (dependecy as ISqlObject).info?.summary]);
            });
            docs += this.tableDocsMd(depenHeader, depenRow, 20);
        }

        //Usage
        {
            docs += ('## Usages \n');
            const usageHeader = ['schema', 'name', 'type', 'description'];
            const usageRow:(string|undefined)[][] = [];
            sqlObject.usages?.forEach(usage =>{
                usageRow.push([(usage as ISqlObject).schema, '['+(usage as ISqlObject).name+'](./'+(usage as ISqlObject).name+'.md)', (usage as ISqlObject).type?.toString(), (usage as ISqlObject).info?.summary]);
            });
            docs += this.tableDocsMd(usageHeader, usageRow, 20);
        }


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