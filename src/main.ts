import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { GlobalExceptionFilter } from './shared/filters/global-exception.filter';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule),
    config = new DocumentBuilder()
      .setTitle('Organizational Structure Based System')
      .setDescription('API documentation for the Organizational Structure Based System.')
      .setVersion('1.0')
      .addTag('OrganizationalStructureBasedSystem')
      .addTag('OSBS')
      .build(),
    documentFactory = () => SwaggerModule.createDocument(app, config);

  SwaggerModule.setup('api', app, documentFactory);

  app.useGlobalFilters(new GlobalExceptionFilter(new Logger()));


  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
