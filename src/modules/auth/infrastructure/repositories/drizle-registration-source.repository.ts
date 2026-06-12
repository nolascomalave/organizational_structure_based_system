// import RegistrationSource from "../../domain/entities/registration-source.entity";
import RegistrationSourceRepository, { SaveReturnType } from "../../domain/repositories/registration-source.repository";
import { Injectable } from "@nestjs/common";
import { DrizzleService } from "src/lib/drizzle.service";
import { StartRegistrationDto } from "../../shared/dto/start-registration.dto";
import { SourceType as SourceTypeEnum, registrationSource as registrationSourceTable } from "src/models/schema";
import { and, eq, sql } from "drizzle-orm";

@Injectable()
export default class DrizzleRegistrationSourceRepository implements RegistrationSourceRepository {
    constructor(
        private readonly drizzleDB: DrizzleService
    ) {}

    public async save(props: {
        sourceType: string;
        source: string;
    }): Promise<SaveReturnType> {
        console.error(props);
        let source = await this.findRecordBySource(props);

        if(!source) {
            return await this.drizzleDB.db.insert(registrationSourceTable)
                .values({
                    sourceType: props.sourceType as SourceTypeEnum,
                    source: (props.source as string)
                })[0];
        }

        source = await this.drizzleDB.db.update(registrationSourceTable)
            .set({ deletedAt: null })
            .where(
                and(
                    eq(registrationSourceTable.sourceType, props.sourceType as SourceTypeEnum),
                    eq(registrationSourceTable.source, props.source)
                )
            )[0];

        return {
            id: source.id,
            sourceType: source.sourceType as string,
            source: source.source,
            createdAt: source.createdAt,
            deletedAt: source.deletedAt,
        }
    }

    private async findRecordBySource(props: {
        sourceType: string;
        source: string;
    }) {
        return (await this.drizzleDB.db.select()
            .from(registrationSourceTable)
            .where(
                and(
                    eq(registrationSourceTable.sourceType, props.sourceType as SourceTypeEnum),
                    eq(registrationSourceTable.source, props.source)
                )
            )
        )[0] ?? null;
    }

    public async findBySource(props: StartRegistrationDto): Promise<SaveReturnType | null> {
        const registrationSource = await this.findRecordBySource({
            sourceType: props.source_type,
            source: props.source
        });

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