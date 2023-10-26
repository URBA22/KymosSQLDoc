import { Guard } from '../guardClauses';
import { ISqlObject } from '../sqlObject';
import { StoredSqlObject, IStoredSqlObject } from './storedSqlObject';
import { IDirectory } from 'src/core/fsmanager/core/Directory';


interface IStoredSqlObjectBuilder_Step0 {
    fromDirectory(directory: IDirectory): IStoredSqlObjectBuilder_Step1;
}

interface IStoredSqlObjectBuilder_Step1 {
    withSqlObject(sqlObject: ISqlObject): IStoredSqlObjectBuilder_Step2;
}

interface IStoredSqlObjectBuilder_Step2{
    build(): IStoredSqlObject;
}

// step 0 : modalità md / html
// step 1 : ISqlObject[]
// step 2 : Directory


export default class StoredSqlObjectBuilder implements IStoredSqlObjectBuilder_Step0, IStoredSqlObjectBuilder_Step1, IStoredSqlObjectBuilder_Step2 {
    private _sqlObject?: ISqlObject;
    private _directory?: IDirectory;
    
    private constructor() { }
    build() {
        return new StoredSqlObject(this._directory!, this._sqlObject!);
    }

    withSqlObject(sqlObject: ISqlObject): IStoredSqlObjectBuilder_Step2 {
        Guard.Against.Null(sqlObject, 'sqlObject');
        this._sqlObject = sqlObject;
        return this;
    }
    fromDirectory(directory: IDirectory): IStoredSqlObjectBuilder_Step1 {
        Guard.Against.Null(directory, 'directory');
        this._directory = directory;
        return this;
    }

    static createStoredSqlObject():IStoredSqlObjectBuilder_Step0 {
        return new StoredSqlObjectBuilder();
    }

}