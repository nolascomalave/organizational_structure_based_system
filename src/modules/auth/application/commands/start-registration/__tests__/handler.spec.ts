// application/commands/start-registration/__tests__/handler.spec.ts
import { Test } from '@nestjs/testing';
import StartRegistrationHandler from '../handler';
import StartRegistrationCommand from '../command';
import REGISTRATION_SOURCE_REPOSITORY from '../../../../domain/repositories/registration-source.repository';
import RegistrationSourceRepository from '../../../../domain/repositories/registration-source.repository';
import TransactionManager from '../../../../../../shared/application/repositories/transaction-manager.repository';

describe('StartRegistrationHandler', () => {
  let handler: StartRegistrationHandler;
  let sourceRepo: jest.Mocked<RegistrationSourceRepository>;
  let txManager: jest.Mocked<TransactionManager>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        StartRegistrationHandler,
        {
          provide: REGISTRATION_SOURCE_REPOSITORY,
          useValue: {
            save: jest.fn(),
            findBySource: jest.fn(),
          },
        },
        {
          provide: TransactionManager,
          useValue: {
            runInTransaction: jest.fn((cb) => cb()),
          },
        },
      ],
    }).compile();

    handler = module.get(StartRegistrationHandler);
    sourceRepo = module.get(REGISTRATION_SOURCE_REPOSITORY);
    txManager = module.get(TransactionManager);
  });

  it('debe crear un registro de fuente si no existe', async () => {
    const command = new StartRegistrationCommand({
        source: "new@test.com",
        source_type: 'EMAIL',
        ip_address: '::1'
    });
    sourceRepo.findBySource.mockResolvedValue(null);
    sourceRepo.save.mockResolvedValue({ id: 'uuid', sourceType: 'EMAIL', source: 'new@test.com' });

    const result = await handler.execute(command);

    expect(sourceRepo.save).toHaveBeenCalledWith({
      sourceType: 'EMAIL',
      source: 'new@test.com',
    });
    expect(result.registrationId).toBeDefined();
  });

  /* it('debe lanzar error si el email ya existe', async () => {
    const command = new StartRegistrationCommand('EMAIL', 'existing@test.com', '::1');
    sourceRepo.findBySource.mockResolvedValue({ id: 'uuid', sourceType: 'EMAIL', source: 'existing@test.com' });

    await expect(handler.execute(command)).rejects.toThrow('EmailAlreadyRegisteredError');
  }); */
});