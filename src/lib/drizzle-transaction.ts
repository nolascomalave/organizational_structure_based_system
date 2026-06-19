import { ExtractTablesWithRelations } from "drizzle-orm";
import { PgTransaction } from "drizzle-orm/pg-core";
import { PostgresJsDatabase, PostgresJsQueryResultHKT } from "drizzle-orm/postgres-js";

export type DrizzleDB = any; // PostgresJsDatabase<Record<string, never>>;

export type DrizzleTransaction = PgTransaction<PostgresJsQueryResultHKT, Record<string, never>, ExtractTablesWithRelations<Record<string, never>>>;

export type DrizzleDBOrTransaction = DrizzleDB | DrizzleTransaction;

export type DrizzleTransactionFunction<T> = (tx: DrizzleDBOrTransaction) => Promise<T>;