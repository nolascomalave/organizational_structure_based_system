import { BadRequestException, ConflictException, Injectable, NotFoundException } from "@nestjs/common";
import { DrizzleService } from "src/lib/drizzle.service";
import { eq, and, isNull, desc, sql } from 'drizzle-orm';
import { registration, registrationSource, sourceType, SourceType, systemSubscriptionRegistration } from "src/models/schema";
import { StartRegistrationDto } from './dto/start-registration.dto';

class AuthServicePrivate {
    constructor() {}

    protected createOrUpdateRegistration(params) {

    }
}

@Injectable()
export class AuthService {
    constructor(
        private drizzle: DrizzleService
    ) {}

    public async startRegistration(credentials: StartRegistrationDto) {
        if(!sourceType.enumValues.includes(credentials.source_type as SourceType)) {
            throw new BadRequestException(`sourceType ${credentials.source_type} invalid.`);
        }

        const registrationData = (await this.drizzle.db.select({
            registration: registration,
            registrationSource: registrationSource,
            systemSubscriptionRegistration: systemSubscriptionRegistration
        })
            .from(registration)
            .innerJoin(registrationSource, eq(registrationSource.id, registration.registrationSourceId))
            .leftJoin(systemSubscriptionRegistration, eq(systemSubscriptionRegistration.registrationId, registration.id))
            .where(
                and(
                    eq(registrationSource.sourceType, credentials.source_type as SourceType),
                    eq(registrationSource.source, credentials.source), // opcional, pero recomendado
                    isNull(registration.deletedAt),              // ignora registros eliminados lógicamente
                    isNull(registrationSource.deletedAt),
                    isNull(systemSubscriptionRegistration.deletedAt),
                    sql`NOW() BETWEEN ${registration.createdAt} AND ${registration.expiredAt}`
                )
            )
            .orderBy(desc(registration.expiredAt))
            .limit(1))[0] ?? ({
                registration: null,
                registrationSource: null,
                systemSubscriptionRegistration: null,
                now: null
            });

        if(!!registrationData.systemSubscriptionRegistration) {
            throw new ConflictException(`${credentials.source.toLowerCase()} is registered yet!`);
        }

        /* if(!registrationData.registration) {
            const newResult = await this.drizzle.db.transaction(async (DB) => {
                try {
                    const result = await DB.insert(registrationSource).values({
                        sourceType: credentials.source_type as SourceType,
                        source: credentials.source
                    });

                    return result;
                } catch(error) {
                    DB.rollback();
                }
            });

            return newResult;
        } */

        return null;
    }
}