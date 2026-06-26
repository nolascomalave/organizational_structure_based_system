import { Injectable, OnModuleDestroy, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import { DrizzleDBOrTransaction, DrizzleTransaction } from './drizzle-transaction';
import * as schemas from '../models/schema';
import * as relations from '../models/relations';

export type CallbackHandlerDB<T> = (db: DrizzleDBOrTransaction) => Promise<T>;
export type HandleTransactionProps = DrizzleDBOrTransaction | undefined | ({ tx: DrizzleDBOrTransaction } | { beginTransaction: boolean } | { tx: DrizzleDBOrTransaction, beginTransaction: boolean } & { commit?: boolean });

class DrizzleNoCommitableResult<T> {
    constructor (readonly value: T) {}

    getResult() {
        return this.value;
    }
}

@Injectable()
export class DrizzleService implements OnModuleDestroy {
    private readonly logger = new Logger(DrizzleService.name);
    private readonly queryClient: ReturnType<typeof postgres>;
    public readonly db;

    constructor(private configService: ConfigService) {
        const connectionString = this.configService.get<string>('DATABASE_URL')// ,process.env.DATABASE_URL;

        /* const tables: PgTable[] = [];
        let tablesObject = {};

        for(const table in schema) {
            if(!(table in tablesObject) && schema[table] instanceof PgTable) {
                tables.push(schema[table]);
                tablesObject[table] = schema[table];
            }
        } */

        if (!connectionString) {
            throw new Error('DATABASE_URL environment variable is not set');
        }

        // Inicializa el cliente de postgres.js (aplica pooling y configuraciones)
        // this.queryClient = postgres(connectionString);
        // Inicializa Drizzle ORM con los esquemas
        this.db = drizzle(connectionString, {
            schema: {
                ...schemas,
                ...relations
            }
        });
        this.db.isTransaction = false;
    }

    async onModuleDestroy() {
        this.logger.log('Closing database connection...');
        // await this.db.$client.end(); // Cierra la conexión al detener la app
        await this.queryClient.end();
    }

    async handleTransaction<T>(props: HandleTransactionProps, callback: CallbackHandlerDB<T>): Promise<T> {
        let commit = true;

        if(!!props && (typeof props === 'object')) {
            commit = props.commit ?? true;

            if(('beginTransaction' in props) || ('tx' in props)) {
                if(props.beginTransaction && (!props.tx || !props.tx.isTransaction)) {
                    return (await (!!props.tx ? props.tx : this).transaction(async (tx) => await callback(tx), !props.tx ? commit : undefined));
                }

                return (await callback(props.tx ? this.db : props.tx));
            }
        }

        return (await callback(!props ? this.db : props));
    }

    private async transaction<T>(callback: (txProp: DrizzleTransaction) => Promise<T>, commit: boolean = true): Promise<T> {
        let result: T;

        // If NODE_ENV == "test", the transaction must not be submitted.
        commit = commit === true && (process.env.NODE_ENV !== "test");

        try {
            result = await this.db.transaction(async (tx) => {
                tx.isTransaction = true; // Marca la transacción para que los repositorios puedan detectarla
                return await callback(tx);
            });

            if(!commit) {
                throw new DrizzleNoCommitableResult<T>(result);
            }

            return result;
        } catch(e) {
            if(e instanceof DrizzleNoCommitableResult) {
                return e.getResult();
            }

            throw e;
        }
    }
}