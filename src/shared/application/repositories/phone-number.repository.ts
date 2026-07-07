export const PHONE_NUMBER_REPOSITORY = Symbol("PHONE_NUMBER_REPOSITORY");

export type FormattedPhoneNumber = {
    countryCode: string;
    countryCallingCode: string;
    nationalNumber: string;
    e164Format: string;
}

export default interface PhoneNumberRepository {
    validate(phone: string | FormattedPhoneNumber): void;

    format(phoneNumber: string): FormattedPhoneNumber;

    formatAndValidate(phone: string): FormattedPhoneNumber;
};