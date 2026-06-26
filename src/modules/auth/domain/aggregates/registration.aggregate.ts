import { UUID } from "../../../../shared/domain/value-objects/uuid.vo";
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
    readonly id: RegistrationType["id"];
    readonly registrationSource: RegistrationType["registrationSource"];
    readonly ipAddress: RegistrationType["ipAddress"];
    readonly confirmRegistrationAt: RegistrationType["confirmRegistrationAt"];
    readonly createdAt: RegistrationType["createdAt"];
    readonly expiredAt: RegistrationType["expiredAt"];
    readonly deletedAt: RegistrationType["deletedAt"];

    // private __setted: RegistrationType["__setted"] = false;

    constructor(props: RegistrationType/* { [key in (keyof Registration)]: Registration[keyof Registration] } */) {
        Object.assign(this, props);
    }

    public getProperty(property: (keyof Registration)) {
        return (this[property] as Registration[keyof Registration]);
    }

    public isIdSetted(): boolean {
        return !!this.id;
    }

    public setProperty(property: (keyof Registration), value: Registration[keyof Registration]): Registration[keyof Registration] {
        return ((this[property] as Registration[keyof Registration]) = value);
    }

    /* public setRegistration(props: Omit<Registration, 'registrationSource' | 'ipAddress'>) {
        Object.assign(this, props);
        this.__setted = true;
    } */

    /* public getRegistrationSource(): RegistrationSource {
        return this.registrationSource;
    } */
}