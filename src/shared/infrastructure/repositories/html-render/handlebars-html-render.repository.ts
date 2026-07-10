import { Injectable, OnModuleInit } from "@nestjs/common";
import HTMLRenderRepository from "src/shared/application/repositories/html-render.repository";

@Injectable()
export class HandlebarsHTMLRenderRepository implements HTMLRenderRepository, OnModuleInit {
    constructor () {
        /* this.transporter = nodemailer.createTransport({
            host: this.configService.get<string>('MAILER_SMTP_GMAIL_HOST'),
            port: this.configService.get<number>('MAILER_SMTP_GMAIL_PORT'),
            secure: true, // true for port 465, false for other ports
            auth: {
                pass: this.configService.get<string>('MAILER_SMTP_GMAIL_USER'),
                user: this.configService.get<string>('MAILER_SMTP_GMAIL_PASSWORD')
            },
        }); */
    }

    async onModuleInit() {
        // this.transporter.close();
    }

    async render(templateName: string, props: Record<string, any>): Promise<string> {
        return "";
    };
}