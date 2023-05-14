import { IFsManager } from '@core';
import { Guard, IParser } from '@services';
import { Parser } from '@services/parser/parser';

interface IParserBuilder_Step0 {
    withFsManager(fsManager: IFsManager): IParserBuilder_Step1;
}

interface IParserBuilder_Step1 {
    build(): IParser;
}

export default class ParserBuilder implements IParserBuilder_Step0, IParserBuilder_Step1 {
    private fsManager?: IFsManager;

    private constructor() { }

    public static createParser(): IParserBuilder_Step0 {
        return new ParserBuilder();
    }

    withFsManager(fsManager: IFsManager): IParserBuilder_Step1 {
        Guard.Against.Null(fsManager, 'fsManager');

        this.fsManager = fsManager;
        return this;
    }

    public build(): IParser {
        return new Parser(this.fsManager as IFsManager);
    }
}