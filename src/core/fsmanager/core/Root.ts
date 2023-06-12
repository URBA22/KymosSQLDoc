import { IDirectory } from './Directory';

export interface IRoot {
    get path(): string;
    get directory(): IDirectory;
}

export class Root implements IRoot {
    public path: string;        //conterrà la path originale
    public directory: IDirectory;    //contiene tutti i percorsi successivi

    //costruttore della classse Root
    constructor(path: string, directory: IDirectory) {
        this.path = path;
        this.directory = directory;
    }

}

