import { ISqlObject } from '../sqlObject';
import { IDirectory } from 'src/core/fsmanager/core/Directory';

export interface IStoredSqlObject {
    sqlObject: ISqlObject;
    directory: IDirectory;

}

export class StoredSqlObject implements IStoredSqlObject{
    private _sqlObject: ISqlObject;
    private _directory: IDirectory;

    get sqlObject(): ISqlObject { return this._sqlObject; }
    get directory(): IDirectory{ return this._directory; }

    constructor(directory: IDirectory, sqlObject: ISqlObject) {
        this._directory = directory;
        this._sqlObject = sqlObject;
    }
}