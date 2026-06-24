import { IsNotEmpty, IsString } from "class-validator";


export default class SendVerificationSourceCodeDto {
    @IsNotEmpty()
    @IsString()
    registration_source_id: string;
}