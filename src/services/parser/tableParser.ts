import { IParser } from './parser';

export class TableParser implements IParser {
    private definition: string;

    public constructor(definition: string) {
        this.definition = definition;
    }
    public async parseAsync() {
        return this.definition;
    }
}