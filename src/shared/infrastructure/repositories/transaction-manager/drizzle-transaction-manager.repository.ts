import { Injectable } from "@nestjs/common";
import { DrizzleTransaction } from "src/lib/drizzle-transaction";
import { DrizzleService } from "src/lib/drizzle.service";
import TransactionManagerRepository from "src/shared/application/repositories/transaction-manager.repository";

@Injectable()
export class DrizzleTransactionManagerRepository implements TransactionManagerRepository {
    constructor(
        private readonly drizzleDB: DrizzleService
    ) {}

    public async execute<T>(callback: (tx: DrizzleTransaction) => Promise<T>): Promise<T> {
        return await this.drizzleDB.db.transaction(callback);
    }
}