import { IParser } from './parser';

export class ViewParser implements IParser {
    private definition: string;

    public constructor(definition: string) {
        this.definition = definition;
    }
    public async parseAsync() {
        return this.definition;
    }
}