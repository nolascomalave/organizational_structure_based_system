import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import RegistrationSource from "../entities/registration-source.entity";
import { IpAddress } from "../../shared/value-objects/ip-address.vo";

type RegistrationType = {
    id?: UUID;
    registrationSource: RegistrationSource;
    ipAddress: IpAddress;
    confirmRegistrationAt?: Date;
    createdAt?: Date;
    expiredAt?: Date;
    deletedAt?: Date;
};

export default class Registration {
    private readonly id?: UUID;
    private readonly registrationSource: RegistrationSource;
    private readonly ipAddress: IpAddress;
    private readonly confirmRegistrationAt?: Date;
    private readonly createdAt: Date;
    private readonly expiredAt: Date;
    private readonly deletedAt?: Date;

    private __setted: boolean = false;

    constructor(props: RegistrationType) {
        Object.assign(this, props);
    }

    set setRegistration(props: Omit<Registration, 'registrationSource' | 'ipAddress'>) {
        Object.assign(this, props);
        this.__setted = true;
    }
}