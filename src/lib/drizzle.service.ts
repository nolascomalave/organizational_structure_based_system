import { Injectable, OnModuleDestroy, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { drizzle, type PostgresJsDatabase } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import schema from '../models';
import { PgTable } from 'drizzle-orm/pg-core';
// import * as schema from './schema'; // Aquí importas todos tus esquemas

@Injectable()
export class DrizzleService implements OnModuleDestroy {
    private readonly logger = new Logger(DrizzleService.name);
    private readonly queryClient: ReturnType<typeof postgres>;
    public readonly db: PostgresJsDatabase;

    constructor(private configService: ConfigService) {
        const connectionString = this.configService.get<string>('DATABASE_URL')// ,process.env.DATABASE_URL;

        const tables: PgTable[] = [];
        let tablesObject = {};

        for(const table in schema) {
            if(!(table in tablesObject) && schema[table] instanceof PgTable) {
                tables.push(schema[table]);
                tablesObject[table] = schema[table];
            }
        }

        if (!connectionString) {
            throw new Error('DATABASE_URL environment variable is not set');
        }

        // Inicializa el cliente de postgres.js (aplica pooling y configuraciones)
        // this.queryClient = postgres(connectionString);
        // Inicializa Drizzle ORM con los esquemas
        this.db = drizzle(connectionString);
    }

    async onModuleDestroy() {
        this.logger.log('Closing database connection...');
        // await this.db.$client.end(); // Cierra la conexión al detener la app
        await this.queryClient.end();
    }
}