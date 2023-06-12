import { IParser } from '..';
import { Parser } from './parser';


interface IParserBuilder_Step0 {
    build(): IParser;
}

export default class ParserBuilder implements IParserBuilder_Step0 {
    private constructor() { }

    public static createParser(): IParserBuilder_Step0 {
        return new ParserBuilder();
    }

    public build(): IParser {
        return new Parser();
    }
}