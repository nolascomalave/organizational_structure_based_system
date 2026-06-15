// import RegistrationSource from "../../domain/entities/registration-source.entity";
import RegistrationSourceRepository, { SaveReturnType } from "../../../domain/repositories/registration-source.repository";
import { Injectable } from "@nestjs/common";
import { DrizzleService } from "src/lib/drizzle.service";
import { StartRegistrationDto } from "../../../shared/dto/start-registration.dto";
import { SourceType as SourceTypeEnum, registrationSource as registrationSourceTable } from "src/models/schema";
import { and, eq } from "drizzle-orm";
import { DrizzleDBOrTransaction } from "src/lib/drizzle-transaction";

@Injectable()
export class DrizzleRegistrationSourceRepository implements RegistrationSourceRepository {
    constructor(
        private readonly drizzleDB: DrizzleService
    ) {}

    public async save(props: {
        sourceType: string;
        source: string;
    }, tx?: DrizzleDBOrTransaction): Promise<SaveReturnType> {
        return this.drizzleDB.handleTransaction(tx, async (db) => {
            let source = await this.findRecordBySource(props, db);

            if(!source) {
                return (await db.insert(registrationSourceTable)
                    .values({
                        sourceType: props.sourceType as SourceTypeEnum,
                        source: (props.source as string)
                    }).returning())[0];
            }

            return (await db.update(registrationSourceTable)
                .set({ deletedAt: null })
                .where(
                    and(
                        eq(registrationSourceTable.sourceType, props.sourceType as SourceTypeEnum),
                        eq(registrationSourceTable.source, props.source)
                    )
                ).returning())[0];
        })
    }

    private async findRecordBySource(props: {
        sourceType: string;
        source: string;
    }, tx?: DrizzleDBOrTransaction) {
        return this.drizzleDB.handleTransaction(tx, async (db) => {
            return (await db.select()
                .from(registrationSourceTable)
                .where(
                    and(
                        eq(registrationSourceTable.sourceType, props.sourceType as SourceTypeEnum),
                        eq(registrationSourceTable.source, props.source)
                    )
                )
            )[0] ?? null;
        });
    }

    public async findBySource(props: StartRegistrationDto, tx?: DrizzleDBOrTransaction): Promise<SaveReturnType | null> {
        const registrationSource = await this.findRecordBySource({
            sourceType: props.source_type,
            source: props.source
        }, tx);

        if(!registrationSource) {
            return null;
        }

        return {
            id: registrationSource.id,
            sourceType: registrationSource.sourceType,
            source: registrationSource.source,
            createdAt: registrationSource.createdAt,
            deletedAt: registrationSource.deletedAt
        };
    }
}