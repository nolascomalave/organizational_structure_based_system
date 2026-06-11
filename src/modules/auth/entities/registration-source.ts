import { UUID } from "src/shared/domain/value-objects/uuid.vo";

type RegistrationSourceType = {
    id?: UUID;
    source_type: string;
    source: string;
    createdAt?: Date;
    deletedAt?: Date;
}

export class RegistrationSource {
    private readonly id?: UUID;
    private readonly source_type: string;
    private readonly source: string;
    private readonly createdAt?: Date;
    private readonly deletedAt?: Date;

    constructor(props: RegistrationSourceType) {
        Object.assign(this, props);
    }
}