import { StartRegistrationDto } from "../../../shared/dto/start-registration.dto";

class StartRegistrationCommandProps extends StartRegistrationDto {
    ip_address: string;
}

export default class StartRegistrationCommand {
    source_type: string;
    source: string;
    ip_address: string;

    constructor(props: StartRegistrationCommandProps) {
        Object.assign(this, props);
    }
}