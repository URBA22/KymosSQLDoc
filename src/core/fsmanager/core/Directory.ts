export interface IDirectory {
    get name(): string;
    get directory(): string;

    get files(): string[];
    set files(files: string[]);

    get children(): Directory[];
    set children(children: Directory[]);
}

export class Directory implements IDirectory {

    public name: string;       //conterrà il nome del percorso
    public directory: string;   //directory che contiene i file e le altre directory
    public files: string[];             //file presenti nella directory
    public children: Directory[];     //directory presenti nella directory originale

    //costruttore della classe Directory
    constructor(directory: string, name: string, files: string[] = [], children: Directory[] = []) {
        this.name = name;
        this.directory = directory;
        this.files = files;
        this.children = children;
    }
}