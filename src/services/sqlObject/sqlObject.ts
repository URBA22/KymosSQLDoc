import { Guard } from '../guardClauses';
import * as SqlObjectCore from './core';
import { FsManager } from 'src/core/fsmanager/fsmanager';

export interface ISqlObject {
    definition?: string;
    comments?: string;
    schema: string;
    name?: string;
    type?: SqlObjectCore.Type;
    parameters?: SqlObjectCore.Parameter[];
    dependecies?: SqlObjectCore.Dependecy[];
    usages?: SqlObjectCore.Dependecy[];
    info?: SqlObjectCore.Info;
    steps?: SqlObjectCore.Step;

    elaborateAsync(): Promise<ISqlObject>;
}

export class SqlObject implements ISqlObject {
    private _rawDefinition: string;

    private _definition?: string;
    private _comments?: string;
    private _name?: string;
    private _schema = 'dbo';
    private _type?: SqlObjectCore.Type;
    private _parameters?: SqlObjectCore.Parameter[]; // TODO - to test
    private _dependecies?: ISqlObject[]; // TODO
    private _usages?: ISqlObject[]; // TODO
    private _info?: SqlObjectCore.Info;
    private _steps?: SqlObjectCore.Step; // TODO 

    get definition(): string | undefined { return this._definition; }
    get comments(): string | undefined { return this._comments; }
    get schema(): string { return this._schema; }
    get name(): string | undefined { return this._name; }
    get type(): SqlObjectCore.Type | undefined { return this._type; }
    get parameters(): SqlObjectCore.Parameter[] | undefined { return this._parameters; }
    get dependecies(): SqlObjectCore.Dependecy[] | undefined { return this._dependecies; }
    get usages(): SqlObjectCore.Dependecy[] | undefined { return this._usages; }
    get info(): SqlObjectCore.Info | undefined { return this._info; }
    get steps(): SqlObjectCore.Step | undefined { return this._steps; }

    constructor(definition: string) {
        this._rawDefinition = definition;
    }

    public async elaborateAsync(): Promise<ISqlObject> {
        await this.splitDefinition();
        await this.getName();
        await this.getSchema();

        const parametersPromise = this.getParameter();
        const infoPromise = SqlObjectCore.Info.fromComments(this._comments ?? '');

        this._parameters = await parametersPromise;
        this._info = await infoPromise;

        return this;
    }

    private async getParameter() {
        Guard.Against.NullOrEmpty(await this._definition, 'definition');
        // Verify this._type = undefined
        // Guard.Against.NullOrEmpty(await this._type, 'type');
        // if (!((await this._type) == SqlObjectCore.Type.STORED_PROCEDURE || (await this._type) == SqlObjectCore.Type.FUNCTION))  return;
        return SqlObjectCore.Parameter.fromDefinition(await this._definition as string);
        
    }

    private async getName() {
        if (this._definition == undefined || this._definition == '') {
            return;
        }

        const indexAlter = this._definition
            .toUpperCase()
            .indexOf('ALTER');

        const indexCreate = this._definition
            .toUpperCase()
            .indexOf('CREATE');

        if (indexAlter <= 0 && indexCreate <= 0) {
            return;
        }

        let start = indexCreate + 'CREATE'.length;
        if (indexAlter >= 0) {
            start = indexAlter + 'ALTER'.length;
        }
        const precStart = start;
        start = this._definition.indexOf(' ', start + 2);

        const typeString = this.definition?.substring(
            start + 1,
            Math.min(precStart + 1, start)
        ).trim();
        
        this._type = await this.getType(typeString);
        let endSpace = this._definition.indexOf(' ', start + 2);
        if (endSpace <= 0) endSpace = Number.POSITIVE_INFINITY;

        let endBraket = this._definition.indexOf('(', start + 2);
        if (endBraket <= 0) endBraket = Number.POSITIVE_INFINITY;

        this._name = this.definition?.substring(
            start + 1,
            Math.min(endSpace, endBraket)
        );

        this._name = this._name
            ?.replace(/\[|\]/gm, '');
    }

    private async getSchema() {
        if (this._name == undefined || this._name == '') {
            return;
        }

        const split = this._name.split('.');

        if (split.length < 2) {
            return;
        }

        this._schema = split[0];
        this._name = split[1];
    }

    private async getType(type?: string): Promise<SqlObjectCore.Type | undefined> {
        if (type == undefined || type == '') {
            return;
        }

        type = type.toUpperCase();

        if (type == 'PROCEDURE' || type == 'PROC') return SqlObjectCore.Type.STORED_PROCEDURE;
        if (type == 'VIEW') return SqlObjectCore.Type.VIEW;
        if (type == 'TABLE') return SqlObjectCore.Type.TABLE;
        if (type == 'TRIGGER') return SqlObjectCore.Type.TRIGGER;
        if (type == 'FUNCTION') return SqlObjectCore.Type.FUNCTION;
    }

    private async splitDefinition() {
        this._definition = this._rawDefinition;
        this._comments = '';
        let comment = '';

        while (this._definition.includes('--') || this._definition.includes('/*')) {
            const { start, end } = await this.getCommentEdges();

            comment = this._definition.substring(start, end);
            this._comments += comment + '\n';
            this._definition = this._definition.replace(comment, '');
        }

        this._definition = this._definition
            .replace(/(\t|\n|\r)+/g, ' ')
            .replace(/[ ]+/g, ' ')
            .trim();

        this._comments = this._comments?.trim();
    }

    private async getCommentEdges() {
        const definition = this._definition as string;

        const indexMulti = definition.indexOf('/*');
        const indexSingle = definition.indexOf('--');
        let start = -1;
        let end = -1;
        let increment = 0;

        if (indexMulti == -1 && indexSingle >= 0)
            start = indexSingle;

        if (indexSingle == -1 && indexMulti >= 0)
            start = indexMulti;

        if (indexSingle >= 0 && indexMulti >= 0)
            start = Math.min(indexMulti, indexSingle);

        if (start == indexSingle) {
            end = definition.indexOf('\n', start + 1);
            increment = 1;
        }

        if (start == indexMulti) {
            end = definition.indexOf('*/', start + 1);
            increment = 2;
        }

        if (end <= 0) {
            end = definition.length - 1;
            increment = 0;
        }

        return { start, end: end + increment };
    }
}