import { Type } from './type';


export class Dependecy {
    public name: string;
    public type: Type;

    constructor(name: string, type: Type) {
        this.name = name;
        this.type = type;
    }
}