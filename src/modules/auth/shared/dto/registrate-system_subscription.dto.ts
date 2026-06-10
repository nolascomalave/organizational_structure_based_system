import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsNotEmpty, IsString } from 'class-validator';
import { sourceType } from 'src/lib/models/schema';

export class RegistrateSystemSubscriptionDto {
    // @IsString()
    @ApiProperty({
        required: true,
        description: `Type of source, must be one of ${sourceType.enumValues.join(', ')}.`,
        example: sourceType.enumValues[0],
    })
    @IsIn(sourceType.enumValues, {
        message: `sourceType must be ${sourceType.enumValues.join(' or ')}.`,
    })
    @IsNotEmpty()
    // @IsUppercase()
    source_type: string;

    @ApiProperty({
        required: true,
        description: `Source identifier, must be a string with the specified source type format.`,
        example: "osbs@osbs.com",
    })
    @IsString()
    @IsNotEmpty()
    source: string;
}