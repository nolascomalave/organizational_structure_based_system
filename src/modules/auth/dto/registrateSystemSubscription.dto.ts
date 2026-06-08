import { IsEmail, IsIn, IsNotEmpty, IsString, IsUppercase} from 'class-validator';
import { sourceType } from 'src/lib/models/schema';

export class RegistrateSystemSubscriptionDto {
    @IsString()
    @IsNotEmpty()
    @IsUppercase()
    @IsIn(sourceType.enumValues, {
        message: `sourceType must be ${sourceType.enumValues.join(' or ')}.`,
    })
    source_type: string;

    @IsEmail()
    @IsNotEmpty()
    source: string;
}