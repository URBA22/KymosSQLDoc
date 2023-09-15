import { ArgumentNullError, ArgumentNullOrEmptyError, InvalidPathError } from './errors';
import fs from 'fs';

export namespace Guard {
    export class Against {
        private constructor() { }

        static Null(object: unknown, name: string) {
            if (object === null || object === undefined) {
                throw new ArgumentNullError(name);
            }
        }

        static NullOrEmpty(object: unknown, name: string) {
            if (object === null || object === undefined || object === '') {
                throw new ArgumentNullOrEmptyError(name);
            }
        }

        static NullOrWhiteSpace(object: unknown, name: string) {
            if (object === null || object === undefined || object === '' || object === ' ') {
                throw new ArgumentNullOrEmptyError(name);
            }
        }

        static InvalidPath(path: string) {
            this.NullOrEmpty(path, 'path');

            if (!fs.existsSync(path)) {
                throw new InvalidPathError(path);
            }

        }
    }
}