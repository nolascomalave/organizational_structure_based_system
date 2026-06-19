import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import RegistrationRepository, { SavePropsType } from "../../../domain/repositories/registration.repository";
import type RegistrationSourceRepository from "../../../domain/repositories/registration-source.repository";
import { DrizzleService } from "src/lib/drizzle.service";
import { Inject, Injectable } from "@nestjs/common";
import { REGISTRATION_SOURCE_REPOSITORY } from "../../../domain/repositories/registration-source.repository";
import Registration from "src/modules/auth/domain/aggregates/registration.aggregate";
import { DrizzleDBOrTransaction } from "src/lib/drizzle-transaction";
import { registration as registrationTable, registrationSource as registrationSourceTable } from "src/models/schema";
import RegistrationSource from "src/modules/auth/domain/entities/registration-source.entity";
import { IpAddress } from "src/modules/auth/shared/value-objects/ip-address.vo";
import { and, sql } from "drizzle-orm";
import { registrationSourceRelations } from "src/models/relations";

@Injectable()
export class DrizzleRegistrationRepository implements RegistrationRepository {
    constructor(
        @Inject(REGISTRATION_SOURCE_REPOSITORY)
        private readonly registrationSourceRepository: RegistrationSourceRepository,
        private readonly drizzleDB: DrizzleService
    ) {}

    public async save(props: SavePropsType, tx?: DrizzleDBOrTransaction): Promise<Registration> {
        return this.drizzleDB.handleTransaction({ tx: tx, beginTransaction: true }, async (db) => {
            const registration = (props instanceof Registration
                ? props
                : (new Registration({
                    ipAddress: (new IpAddress(props.ipAddress)),
                    registrationSource: (("registrationSource" in props)
                        ? props.registrationSource
                        : new RegistrationSource({
                            source: props.source,
                            sourceType: props.source_type
                        })
                    )
                }))
            );

            registration.setProperty("registrationSource", await this.registrationSourceRepository.save(registration.registrationSource, db));

            /* let foundRegistration = await db.query.registration.findFirst({
                where: {
                    ipAddress: registration.ipAddress.toString()
                },
                with: { registrationSource: true }
            }); */
            let foundRegistration = await db.query.registration.findFirst({
                where: (registrationTable, { eq }) => and(
                    eq(registrationTable.ipAddress, registration.ipAddress.toString()),
                    eq(registrationTable.registrationSourceId, registration.registrationSource.id?.toString()),
                    sql`(NOW() BETWEEN ${registrationTable.createdAt} AND ${registrationTable.expiredAt})`
                ),
                with: { registrationSource: true }
            });

            if(foundRegistration) {
                return new Registration({
                    id: foundRegistration.id,
                    ipAddress: new IpAddress(foundRegistration.ip_address),
                    registrationSource: new RegistrationSource({
                        id: foundRegistration.registrationSource.id,
                        source: foundRegistration.registrationSource.source,
                        sourceType: foundRegistration.registrationSource.sourceType,
                        createdAt: foundRegistration.registrationSource.createdAt,
                        deletedAt: foundRegistration.registrationSource.deletedAt
                    }),
                    confirmRegistrationAt: foundRegistration.confirm_registration_at,
                    createdAt: foundRegistration.createdAt,
                    expiredAt: foundRegistration.expiredAt,
                    deletedAt: foundRegistration.deletedAt
                });
            }

            const registrationResult = (await db.insert(registrationTable)
                .values({
                    id: sql`uuidv7()`,
                    ipAddress: registration.ipAddress.toString(),
                    registrationSource: registration.registrationSource.id?.toString(),
                    confirmRegistrationAt: registration.confirmRegistrationAt,
                    createdAt: sql`now()`,
                    expiredAt: sql`(now() + '00:30:00'::interval)`,
                    deletedAt: null
                }).returning())[0];

            return new Registration({
                id: registrationResult.id,
                ipAddress: registration.ipAddress,
                registrationSource: registration.registrationSource,
                confirmRegistrationAt: registrationResult.confirmRegistrationAt,
                createdAt: registrationResult.createdAt,
                expiredAt: registrationResult.expiredAt,
                deletedAt: registrationResult.deletedAt
            });
        });
    }

    /* public async findById(id: string, tx?: DrizzleDBOrTransaction): Promise<Registration> {
        return await this.drizzleDB.handleTransaction(tx, async (db) => {
            const result = await db.query.registration.findFirst({
                where: (registrationTable, { eq }) => eq(registrationTable.id, id),
                with: {
                    registrationSourceRelations: true
                },
            });

            return ({} as Registration);
        });
    } */
}