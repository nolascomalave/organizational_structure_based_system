export default class DatabaseException extends Error {
    readonly cause?: any;

    constructor(message: string, cause?: any) {
        super(message);
        this.cause = cause;
    }
}