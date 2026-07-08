import { UUID } from "../../../../shared/domain/value-objects/uuid.vo";
import SourceType from "../../shared/value-objects/source-type.vo";
import { StartRegistrationDto } from "../../shared/dto/start-registration.dto";
import { InvalidEmailFormatException } from "../exceptions/InvalidEmailFormatException.exception";
import { InvalidPhoneNumberFormatException } from "../exceptions/InvalidPhoneNumberFormatException.exception";
import { InvalidRegistrationSourceType } from "../exceptions/InvalidRegistrationSourceType.exception";

enum SourceTypeEnum {
    PHONE_NUMBER = 'PHONE_NUMBER',
    EMAIL = 'EMAIL',
};

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

        this.validate();
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

    private validate(): boolean {
        if(!(Object.values(SourceTypeEnum).includes(this.sourceType.toString() as SourceTypeEnum))) {
            throw new InvalidRegistrationSourceType(this.sourceType.toString());
            // throw new Error(`Invalid source type: ${this.sourceType}`);
        }

        if(this.sourceType.toString() === SourceTypeEnum.EMAIL && !((/^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/i).test(this.source))) {
            // throw new Error(`Invalid email format: ${this.source}`);
            throw new InvalidEmailFormatException(this.source);
        }

        if(this.sourceType.toString() === SourceTypeEnum.PHONE_NUMBER && !((/^\+[1-9]\d{1,14}$/).test(this.source))) {
            // throw new Error(`Invalid phone number format: ${this.source}`);
            throw new InvalidPhoneNumberFormatException(this.source);
        }

        return true;
    }
}