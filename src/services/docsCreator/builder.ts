import { Guard } from '../guardClauses';
import { IStoredSqlObject } from '../storedSqlObject';
import { DocsCreator, IDocsCreator } from './docsCreator';
import { IDirectory } from 'src/core/fsmanager/core/Directory';

export enum Mode{
    md,
    html
}

interface IDocsCreatorBuilder_Step0 {
    withDestination(destination: IDirectory): IDocsCreatorBuilder_Step1;
}

interface IDocsCreatorBuilder_Step1 {
    withStoredSqlObjects(storedSqlObjects: IStoredSqlObject[]): IDocsCreatorBuilder_Step2;
}

interface IDocsCreatorBuilder_Step2{
    withMode(mode: Mode): IDocsCreatorBuilder_Step3;
}


interface IDocsCreatorBuilder_Step3{
    build(): IDocsCreator;
}

// step 0 : modalità md / html
// step 1 : IStoredSqlObject[]
// step 2 : Dir


export default class DocsCreatorBuilder implements IDocsCreatorBuilder_Step0, IDocsCreatorBuilder_Step1, IDocsCreatorBuilder_Step2, IDocsCreatorBuilder_Step3{
    private _mode?: Mode;
    private _storedSqlObjects?: IStoredSqlObject[];
    private _destination?: IDirectory;
    
    private constructor() { }
    build() {
        return new DocsCreator(this._destination!, this._storedSqlObjects!, this._mode!);
    }
    withMode(mode: Mode): IDocsCreatorBuilder_Step3 {
        Guard.Against.Null(mode, 'mode');
        this._mode = mode;
        return this;
    }
    withStoredSqlObjects(storedSqlObjects: IStoredSqlObject[]): IDocsCreatorBuilder_Step2 {
        Guard.Against.Null(storedSqlObjects, 'storedSqlObjects');
        this._storedSqlObjects = storedSqlObjects;
        return this;
    }
    withDestination(destination: IDirectory): IDocsCreatorBuilder_Step1 {
        Guard.Against.Null(destination, 'destination');
        this._destination = destination;
        return this;
    }

    static createDocsCreator():IDocsCreatorBuilder_Step0 {
        return new DocsCreatorBuilder();
    }

}