import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import StartRegistrationCommand from './command';
import Registration from 'src/modules/auth/domain/aggregates/registration.aggregate';
import RegistrationSource from 'src/modules/auth/domain/entities/registration-source.entity';
import { IpAddress } from 'src/modules/auth/shared/value-objects/ip-address.vo';
import { Inject } from '@nestjs/common';
import type RegistrationRepository from 'src/modules/auth/domain/repositories/registration.repository';
import type RegistrationSourceRepository from 'src/modules/auth/domain/repositories/registration-source.repository';

@CommandHandler(StartRegistrationCommand)
export default class StartRegistrationHandler implements ICommandHandler<StartRegistrationCommand> {
    constructor(
        @Inject('RegistrationRepository')
        private readonly registrationRepository: RegistrationRepository,
        @Inject('RegistrationSourceRepository')
        private readonly registrationSourceRepository: RegistrationSourceRepository
    ) {}

    async execute(command: StartRegistrationCommand) {
        /* let registrationSource = await this.registrationSourceRepository.findBySource({
            source_type: command.source_type,
            source: command.source
        });

        if(!registrationSource) { */
            let registrationSource = await this.registrationSourceRepository.save({
                sourceType: command.source_type,
                source: command.source
            });
        /* } */

        console.error(registrationSource);

        return registrationSource.id;

        /* const registration = new Registration({
            registrationSource: RegistrationSource.parse({
                source_type: command.source_type,
                source: command.source
            }),
            ipAddress: new IpAddress(command.ip_address)
        });

        return (await this.registrationRepository.save(registration)); */
        // Implement the logic to registrate system subscription here
    }
}