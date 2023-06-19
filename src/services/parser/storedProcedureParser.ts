import { IParser } from './parser';

export class StoredProcedureParser implements IParser {
    private definition: string;
    public static tokens = ['@summary', '@author', '@custom', '@standard', '@version'];

    public constructor(definition: string) {
        this.definition = definition;
    }
    public async parseAsync() {
        return this.definition;
    }
}