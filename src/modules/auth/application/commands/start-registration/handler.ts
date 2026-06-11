import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import StartRegistrationCommand from './command';
import Registration from 'src/modules/auth/domain/aggregates/registration.aggregate';
import RegistrationSource from 'src/modules/auth/domain/entities/registration-source.entity';
import { IpAddress } from 'src/modules/auth/shared/value-objects/ip-address.vo';

@CommandHandler(StartRegistrationCommand)
export default class StartRegistrationHandler implements ICommandHandler<StartRegistrationCommand> {
    constructor() {}

    async execute(command: StartRegistrationCommand) {
        const registration = new Registration({
            registrationSource: RegistrationSource.parse({
                source_type: command.source_type,
                source: command.source
            }),
            ipAddress: new IpAddress(command.ip_address)
        });

        return registration;
        // Implement the logic to registrate system subscription here
    }
}