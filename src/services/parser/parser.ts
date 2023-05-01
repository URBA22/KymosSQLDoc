export interface IParser {
    parse(definition: string): Promise<string>;
}

export class Parser implements IParser {

    public async parse(definition: string) {

        return definition;
    }
}