// interface/controllers/__tests__/auth.controller.e2e-spec.ts
import { Test } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../../../../../../app.module';

describe('AuthController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const module = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = module.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('POST /auth/start-registration → 201', async () => {
    const response = await request(app.getHttpServer())
      .post('/auth/start-registration')
      .send({ source_type: 'EMAIL', source: 'e2e@test.com' })
      .expect(201);

    expect(response.body.registrationId).toBeDefined();
  });
});