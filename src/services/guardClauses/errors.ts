export class ArgumentNullError implements Error {
    name: string;
    message: string;
    stack?: string | undefined;

    constructor(name: string) {
        this.name = name;
        this.message = `Argument ${name} cannot be null or undefined.`;
    }
}

export class ArgumentNullOrEmptyError implements Error {
    name: string;
    message: string;
    stack?: string | undefined;

    constructor(name: string) {
        this.name = name;
        this.message = `Argument ${name} cannot be null, undefined or an empty string.`;
    }
}