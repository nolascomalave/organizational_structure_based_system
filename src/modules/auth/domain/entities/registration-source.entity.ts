import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import SourceType from "../../shared/value-objects/source-type.vo";
import { StartRegistrationDto } from "../../shared/dto/start-registration.dto";

export type RegistrationSourceType = {
    id?: UUID | string;
    sourceType: SourceType | string;
    source: string;
    createdAt?: Date;
    deletedAt?: Date;
}

export default class RegistrationSource {
    readonly id?: UUID;
    readonly sourceType: SourceType;
    readonly source: string;
    readonly createdAt?: Date;
    readonly deletedAt?: Date;

    constructor(props: RegistrationSourceType) {
        props.id = !props.id ? undefined : UUID.parse(props.id);
        props.sourceType = SourceType.parse(props.sourceType);

        Object.assign(this, props);
    }

    public getProperty(property: (keyof RegistrationSourceType)) {
        return this[property];
    }

    public static parse(props: StartRegistrationDto | RegistrationSource) {
        return ((props instanceof RegistrationSource) ? props : (new RegistrationSource({
            sourceType: new SourceType(props.source_type),
            source: props.source
        })))
    }
}