// domain/__tests__/registration-source.entity.spec.ts
import RegistrationSource from './registration-source.entity';

describe('RegistrationSource', () => {
  it('debe crear una fuente válida con email', () => {
    const source = new RegistrationSource({
        sourceType: 'EMAIL',
        source: 'test@example.com'
    });
    expect(source.sourceType.toString()).toBe('EMAIL');
    expect(source.source).toBe('test@example.com');
  });

  it('debe lanzar error si el email es inválido', () => {
    expect(() => new RegistrationSource({
        sourceType: 'EMAIL',
        source: '65463513512321'
    })).toThrow();
  });
});