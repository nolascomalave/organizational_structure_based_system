import { Module } from '@nestjs/common';
import { AppService } from './app.service';
import { DrizzleModule } from './lib/drizzle.module';
import { AuthModule } from './modules/auth/auth.module';

@Module({
  imports: [
    // ORMs:
    DrizzleModule,

    // Modules:
    AuthModule
  ],
  providers: [AppService],
})
export class AppModule {}
