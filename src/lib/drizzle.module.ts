import { Global, Module } from '@nestjs/common';
import { DrizzleService } from './drizzle.service';
import { ConfigModule } from '@nestjs/config';

@Global() // Hace que el módulo sea global para no tener que importarlo en cada módulo
@Module({
    imports: [ConfigModule.forRoot()],
    providers: [DrizzleService],
    exports: [DrizzleService],
})
export class DrizzleModule {}