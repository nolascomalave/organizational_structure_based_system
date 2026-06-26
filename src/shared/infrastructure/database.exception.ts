export default class DatabaseException extends Error {
    readonly error: any;

    constructor(props: {
        message: string;
        error: any
    }) {
        super(props.message);

        this.error = props.error;
    }
}