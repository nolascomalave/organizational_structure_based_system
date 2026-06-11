import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import SourceType from "../../shared/value-objects/source-type.vo";
import { StartRegistrationDto } from "../../shared/dto/start-registration.dto";

type RegistrationSourceType = {
    id?: UUID | string;
    sourceType: SourceType | string;
    source: string;
    createdAt?: Date;
    deletedAt?: Date;
}

export default class RegistrationSource {
    private readonly id?: UUID;
    private readonly sourceType: SourceType;
    private readonly source: string;
    private readonly createdAt?: Date;
    private readonly deletedAt?: Date;

    constructor(props: RegistrationSourceType) {
        props.id = !props.id ? undefined : UUID.parse(props.id);
        props.sourceType = SourceType.parse(props.sourceType);

        Object.assign(this, props);
    }

    public static parse(props: StartRegistrationDto | RegistrationSource) {
        return ((props instanceof RegistrationSource) ? props : (new RegistrationSource({
            sourceType: new SourceType(props.source_type),
            source: props.source
        })))
    }
}