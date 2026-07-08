import { Module } from '@nestjs/common';
import { AppService } from './app.service';
import { DrizzleModule } from './lib/drizzle.module';
import { AuthModule } from './modules/auth/auth.module';
import { TransactionManagerModule } from './shared/infrastructure/transaction-manager.module';
import { PhoneNumberModule } from './shared/infrastructure/phone-number.module';
import { MailerModule } from './shared/infrastructure/mailer.module';

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
  providers: [
    AppService
  ],
})
export class AppModule {}
