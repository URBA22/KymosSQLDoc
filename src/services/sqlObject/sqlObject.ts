import * as SqlObjectCore from './core';

export interface ISqlObject {
    definition?: string;
    comments?: string;
    type?: SqlObjectCore.Type;
    parameters?: SqlObjectCore.Parameter[];
    dependecies?: SqlObjectCore.Dependecy[];
    usages?: SqlObjectCore.Dependecy[];
    info?: SqlObjectCore.Info;
    steps?: SqlObjectCore.Step;
}

export class SqlObject implements ISqlObject {
    private rawDefinition: string;

    readonly definition?: string;
    readonly comments?: string;
    readonly type?: SqlObjectCore.Type;
    readonly parameters?: SqlObjectCore.Parameter[];
    readonly dependecies?: SqlObjectCore.Dependecy[];
    readonly usages?: SqlObjectCore.Dependecy[];
    readonly info?: SqlObjectCore.Info;
    readonly steps?: SqlObjectCore.Step;

    constructor(definition: string) {
        this.rawDefinition = definition;
    }

    private async elaborate(): Promise<ISqlObject> {
        return this;
    }
}