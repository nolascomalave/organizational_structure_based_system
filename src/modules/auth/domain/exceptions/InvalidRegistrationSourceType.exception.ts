import { DomainException } from "../../../../shared/domain/exceptions/domain.exception";

export class InvalidRegistrationSourceType extends DomainException {
    readonly code = 'INVALID_SOURCE_TYPE';
    readonly status = 401;

    constructor(sourceType: string) {
        super(`Invalid source_type: ${sourceType}.`);
    }
}