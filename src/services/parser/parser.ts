
export interface IParser {
    parseAsync(definition: string): Promise<string>;
}

export class Parser implements IParser {
    public async parseAsync(definition: string) {
        return definition;
    }
}