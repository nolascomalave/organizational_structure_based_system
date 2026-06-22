import { DomainException } from "../../../../shared/domain/exceptions/domain.exception";

export class InvalidEmailFormatException extends DomainException {
    readonly code = 'INVALID_EMAIL_FORMAT';
    readonly status = 401;

    constructor(email) {
        super(`Invalid email format: ${email}.`);
    }
}