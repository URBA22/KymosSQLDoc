class Version {
    public author: string;
    public version: string;
    public description: string;

    constructor(author: string, version: string, description: string) {
        this.author = author;
        this.description = description;
        this.version = version;
    }
}

export class Info {
    public summary?: string;
    public author?: string;
    public custom?: boolean;
    public standard?: boolean;
    public versions?: Version[];
}