// import RegistrationSource from "../../domain/entities/registration-source.entity";
import RegistrationSourceRepository, { SaveReturnType } from "../../../domain/repositories/registration-source.repository";
import { Injectable } from "@nestjs/common";
import { DrizzleService } from "src/lib/drizzle.service";
import { StartRegistrationDto } from "../../../shared/dto/start-registration.dto";
import { SourceType as SourceTypeEnum, registrationSource as registrationSourceTable } from "src/models/schema";
import { and, eq } from "drizzle-orm";
import { DrizzleDBOrTransaction } from "src/lib/drizzle-transaction";
import RegistrationSource from "src/modules/auth/domain/entities/registration-source.entity";
import DatabaseException from "src/shared/infrastructure/exceptions/database.exception";

@Injectable()
export class DrizzleRegistrationSourceRepository implements RegistrationSourceRepository {
    constructor(
        private readonly drizzleDB: DrizzleService
    ) {}

    public async save(props: {
        sourceType: string;
        source: string;
    } | RegistrationSource, tx?: DrizzleDBOrTransaction): Promise<RegistrationSource> {
        try {
            return this.drizzleDB.handleTransaction({ tx, beginTransaction: true }, async (db) => {
                let source = await this.findRecordBySource(props, db);

                if(!source) {
                    // Validate Source Here!
                    const newSource = (await db.insert(registrationSourceTable)
                        .values({
                            sourceType: props.sourceType,
                            source: props.source
                        }).returning())[0];

                    return new RegistrationSource({
                        id: newSource.id,
                        sourceType: newSource.sourceType,
                        source: newSource.source,
                        createdAt: newSource.createdAt,
                        deletedAt: newSource.deletedAt
                    });
                }

                const updatedSource = (await db.update(registrationSourceTable)
                    .set({ deletedAt: null })
                    .where(
                        and(
                            eq(registrationSourceTable.sourceType, props.sourceType as SourceTypeEnum),
                            eq(registrationSourceTable.source, props.source)
                        )
                    ).returning())[0];

                return new RegistrationSource({
                    id: updatedSource.id,
                    sourceType: updatedSource.sourceType,
                    source: updatedSource.source,
                    createdAt: updatedSource.createdAt,
                    deletedAt: updatedSource.deletedAt
                });
            });
        } catch (error) {
            throw new DatabaseException(`Failed to save registration source.`, error);
        }
    }

    private async findRecordBySource(props: {
        sourceType: string;
        source: string;
    } | RegistrationSource, tx?: DrizzleDBOrTransaction): Promise<RegistrationSource | null> {
        try {
            return this.drizzleDB.handleTransaction(tx, async (db) => {
                const registrationSource = (await db.select()
                    .from(registrationSourceTable)
                    .where(
                        and(
                            eq(registrationSourceTable.sourceType, props.sourceType as SourceTypeEnum),
                            eq(registrationSourceTable.source, props.source)
                        )
                    )
                )[0] ?? null;

                if(!registrationSource) {
                    return null;
                }

                return new RegistrationSource({
                    id: registrationSource.id,
                    sourceType: registrationSource.sourceType,
                    source: registrationSource.source,
                    createdAt: registrationSource.createdAt,
                    deletedAt: registrationSource.deletedAt
                });
            });
        } catch (error) {
            throw new DatabaseException(`Failed to find registration source by source.`, error);
        }
    }

    public async findBySource(props: StartRegistrationDto, tx?: DrizzleDBOrTransaction): Promise<RegistrationSource | null> {
        return (await this.findRecordBySource({
            sourceType: props.source_type,
            source: props.source
        }, tx));
    }
}