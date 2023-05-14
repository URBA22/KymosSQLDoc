import { IFsManager } from '@core';
import { FsManager } from '@core/fsmanager/fsmanager';

interface IFsManagerBuilder_Step0 {
    withAbsolutePath(absolutePath: string): IFsManagerBuilder_Step1;
    build(): IFsManager;
}

interface IFsManagerBuilder_Step1 {
    build(): IFsManager;
}

export class FsManagerBuilder implements IFsManagerBuilder_Step0, IFsManagerBuilder_Step1 {

    private absolutePath?: string;

    private constructor() { }

    static createFsManager(): IFsManagerBuilder_Step0 {
        return new FsManagerBuilder();
    }

    withAbsolutePath(absolutePath: string): IFsManagerBuilder_Step1 {
        this.absolutePath = absolutePath;
        return this;
    }

    build(): IFsManager {
        return new FsManager(this.absolutePath);
    }

}