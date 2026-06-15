import { StartRegistrationDto } from "../../shared/dto/start-registration.dto";

export type SaveReturnType = {
    id: string;
    sourceType: string;
    source: string;
    createdAt: string;
    deletedAt: string | null;
}

export default interface RegistrationSourceRepository {
    save(registrationSource: {
        id?: string;
        sourceType: string;
        source: string;
    }, db?: any): Promise<SaveReturnType>
    findBySource(props: StartRegistrationDto, db?: any): Promise<SaveReturnType | null>
}