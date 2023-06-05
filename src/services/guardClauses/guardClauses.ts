import { ArgumentNullError, ArgumentNullOrEmptyError } from './errors';

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
    }
}