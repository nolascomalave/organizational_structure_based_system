import { Module } from '@nestjs/common';
import { DrizzleModule } from './lib/drizzle.module';
import { AuthModule } from './modules/auth/auth.module';
import { TransactionManagerModule } from './shared/infrastructure/transaction-manager.module';
import { PhoneNumberModule } from './shared/infrastructure/phone-number.module';
import { MailerModule } from './shared/infrastructure/mailer.module';
import { DebugService } from './debug.service';
import { DebugController } from './debug.controller';

@Module({
  imports: [
    // ORMs:
    DrizzleModule,

    // Modules:
    AuthModule,

    // Application Modules:
    TransactionManagerModule,
    PhoneNumberModule,
    MailerModule
  ],
  controllers: [
    DebugController
  ],
  providers: [
    DebugService
  ],
})
export class AppModule {}
