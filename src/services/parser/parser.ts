import { IFsManager } from '../../core';

export interface IParser {
    parseAsync(definition: string): Promise<string>;
}

export class Parser implements IParser {
    private fsManager: IFsManager;

    constructor(fsManager: IFsManager) {
        this.fsManager = fsManager;
    }

    public async parseAsync(definition: string) {
        return definition;
    }
}