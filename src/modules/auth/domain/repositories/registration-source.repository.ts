import { StartRegistrationDto } from "../../shared/dto/start-registration.dto";
import RegistrationSource from "../entities/registration-source.entity";

export const REGISTRATION_SOURCE_REPOSITORY = Symbol("REGISTRATION_SOURCE_REPOSITORY");

export type SaveReturnType = {
    id: string;
    sourceType: string;
    source: string;
    createdAt: string;
    deletedAt: string | null;
}

export default interface RegistrationSourceRepository {
    save(props: {
        sourceType: string;
        source: string;
    } | RegistrationSource, db?: any): Promise<RegistrationSource>
    findBySource(props: StartRegistrationDto, db?: any): Promise<RegistrationSource | null>
}