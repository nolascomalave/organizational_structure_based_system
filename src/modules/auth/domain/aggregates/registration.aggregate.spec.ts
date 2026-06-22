// domain/__tests__/registration-source.entity.spec.ts
import { registrationSource } from 'src/models/schema';
import Registration from './registration.aggregate';
import { IpAddress } from '../../shared/value-objects/ip-address.vo';
import RegistrationSource from '../entities/registration-source.entity';

describe('RegistrationSource', () => {
  it('debe crear una fuente válida con email', () => {
    const registration = new Registration({
        registrationSource: new RegistrationSource({
            sourceType: 'EMAIL',
            source: 'test@example.com'
        }),
        ipAddress: new IpAddress("192.168.2.1")
    });
    expect(registration instanceof Registration).toBe(true);
    expect(registration.registrationSource.source).toBe('test@example.com');
  });

  it('debe lanzar error si el email es inválido', () => {
    expect(() => new Registration({
        registrationSource: new RegistrationSource({
            sourceType: 'EMAIL',
            source: 'test@example.com'
        }),
        ipAddress: new IpAddress("")
    })).toThrow();
  });
});