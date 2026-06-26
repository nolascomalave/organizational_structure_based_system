import { Injectable } from "@nestjs/common";
import { DrizzleService, CallbackHandlerDB, HandleTransactionProps } from "../../../../lib/drizzle.service";
import TransactionManagerRepository from "../../../application/repositories/transaction-manager.repository";

@Injectable()
export class DrizzleTransactionManagerRepository implements TransactionManagerRepository {
    constructor(
        private readonly drizzleDB: DrizzleService
    ) {}


    // Overload (Public signs)
    async execute<T>(callback: CallbackHandlerDB<T>): Promise<T>
    async execute<T>(opts: HandleTransactionProps, callback: CallbackHandlerDB<T>): Promise<T>
    // Implementation (Intern sign)
    async execute<T>(opts: HandleTransactionProps | CallbackHandlerDB<T>, callback? : CallbackHandlerDB<T>): Promise<T> {
        if(typeof opts === "function") {
            return await this.drizzleDB.handleTransaction({
                beginTransaction: true
            }, opts);
        }

        return this.drizzleDB.handleTransaction({ ...opts, beginTransaction: true }, callback as CallbackHandlerDB<T>);
    }
}