import { Injectable, OnModuleDestroy } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import MailerRepository from "src/shared/application/repositories/mailer.repository";
import nodemailer, { type Transporter } from "nodemailer";

@Injectable()
export class NodemailerMailerRepository implements MailerRepository, OnModuleDestroy {
    private transporter: Transporter;

    constructor (private configService: ConfigService) {
        this.transporter = nodemailer.createTransport({
            host: this.configService.get<string>('MAILER_SMTP_GMAIL_HOST'),
            port: this.configService.get<number>('MAILER_SMTP_GMAIL_PORT'),
            secure: true, // true for port 465, false for other ports
            auth: {
                pass: this.configService.get<string>('MAILER_SMTP_GMAIL_USER'),
                user: this.configService.get<string>('MAILER_SMTP_GMAIL_PASSWORD')
            },
        });
    }

    async onModuleDestroy() {
        this.transporter.close();
    }

    async sendMail(props: {
        to: string;
        subject: string;
        html: string;
    }): Promise<void> {}
}