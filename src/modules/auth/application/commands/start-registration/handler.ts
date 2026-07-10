import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import StartRegistrationCommand from './command';
import { Inject } from '@nestjs/common';
import type RegistrationRepository from '../../../domain/repositories/registration.repository';
import type TransactionManagerRepository from '../../../../../shared/application/repositories/transaction-manager.repository';
import { REGISTRATION_REPOSITORY } from '../../../domain/repositories/registration.repository';
import { TRANSACTION_MANAGER_REPOSITORY } from '../../../../../shared/application/repositories/transaction-manager.repository';
import DatabaseException from '../../../../../shared/infrastructure/exceptions/database.exception';
import InfrastructureException from '../../../../../shared/infrastructure/exceptions/infrastructure.exception';
import { UUID } from '../../../../../shared/domain/value-objects/uuid.vo';
import { PHONE_NUMBER_REPOSITORY } from 'src/shared/application/repositories/phone-number.repository';
import { PhoneNumberRepository } from 'src/shared/infrastructure/repositories';

@CommandHandler(StartRegistrationCommand)
export default class StartRegistrationHandler implements ICommandHandler<StartRegistrationCommand> {
    constructor(
        @Inject(PHONE_NUMBER_REPOSITORY)
        private readonly phoneNumberRepository: PhoneNumberRepository,
        @Inject(REGISTRATION_REPOSITORY)
        private readonly registrationRepository: RegistrationRepository,
        @Inject(TRANSACTION_MANAGER_REPOSITORY)
        private readonly transactionManagerRepository: TransactionManagerRepository,
    ) {}

    async execute(command: StartRegistrationCommand): Promise<string> {
        try {
            return (await this.transactionManagerRepository.execute(async (tx) => {
                return ((await this.registrationRepository.save({
                    source_type: command.source_type,
                    source: (command.source_type.trim().toUpperCase()) === "PHONE_NUMBER" ? this.phoneNumberRepository.formatAndValidate(command.source).e164Format : command.source,
                    ipAddress: command.ip_address
                }, tx)).id as UUID).toString();
            }));
        } catch(error) {
            if(error instanceof DatabaseException) {
                throw new InfrastructureException("Error saving the registration.");
            }

            throw error;
        }
    }
}