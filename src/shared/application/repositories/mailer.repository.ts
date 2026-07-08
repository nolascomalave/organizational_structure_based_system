export const MAILER_REPOSITORY = Symbol("MAILER_REPOSITORY");

export default interface MailerRepository {
    sendMail(props: {
        to: string;
        subject: string;
        html: string;
    }): Promise<void>
};