import { DomainException } from "../../../../shared/domain/exceptions/domain.exception";

export class InvalidPhoneNumberFormatException extends DomainException {
    readonly code = 'INVALID_PHONE_NUMBER_FORMAT';
    readonly status = 401;

    constructor(phone) {
        super(`Invalid phone number format: ${phone}.`);
    }
}