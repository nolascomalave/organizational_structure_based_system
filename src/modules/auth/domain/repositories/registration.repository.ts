import { StartRegistrationDto } from "../../shared/dto/start-registration.dto";
import Registration from "../aggregates/registration.aggregate";
import RegistrationSource from "../entities/registration-source.entity";

export const REGISTRATION_REPOSITORY = Symbol("REGISTRATION_REPOSITORY");

export type SavePropsType = (StartRegistrationDto & { ipAddress: string }) | Registration | ({ ipAddress: string; registrationSource: RegistrationSource });

export default interface RegistrationRepository {
    save(props: SavePropsType): Promise<Registration>
}