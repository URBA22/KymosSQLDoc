
export class Parameter {
    public name: string;
    public type: string;
    public nullable = false;
    public output = false;
    public default?: string;
    public description?: string;

    constructor(name: string, type: string) {
        this.name = name;
        this.type = type;
    }
}