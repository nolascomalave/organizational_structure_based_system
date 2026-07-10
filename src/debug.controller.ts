import { Controller, Get, Header, HttpCode, HttpStatus } from "@nestjs/common";
import path from "path";
import fs from "fs";
import Handlebars from "handlebars";
import Temporal from "@js-temporal/polyfill";
// import { Handlebars } from "handlebars";

const OneMinute = 60 * 1000; // 1 minute in milliseconds;
const OneHour = 60 * OneMinute; // 1 hour in milliseconds;

@Controller("/debug")
export class DebugController {
    constructor() {}

    @Get("/get-sent_verification_code-email")
    @HttpCode(HttpStatus.OK)
    @Header('Content-Type', 'text/html')
    async getSentVerificationCodeEmail() {
        const templatePath = path.join(process.cwd(), 'src/shared/infrastructure/repositories/html-render/templates', 'verification-code.hbs'),
            templateSource = fs.readFileSync(templatePath, 'utf8'),
            time = new Date(172812000)

        return (Handlebars.compile(templateSource))({
            sourceType: "phone number",
            source: "+584123161687",
            expirationLongFormat: "5 minutes",
            verificationCode: "123456",
            digitalFormatExpiration: "05:00"
        });
    }
}
