import PhoneNumberRepository, { FormattedPhoneNumber } from "src/shared/application/repositories/phone-number.repository";
import { isValidPhoneNumber, type CountryCode, parsePhoneNumberFromString } from 'libphonenumber-js';
import { Injectable } from "@nestjs/common";

@Injectable()
export class LibPhoneNumberPhoneNumberRepository implements PhoneNumberRepository {
    validate(phone: string | FormattedPhoneNumber): void {
        if(typeof phone === "string") {
            if(!isValidPhoneNumber(phone)) {
                throw new Error("Invalid phone number.");
            }
        } else {
            if(!isValidPhoneNumber(phone.nationalNumber, phone.countryCode as CountryCode)) {
                throw new Error(`Invalid Country Code (${phone.countryCode}) for phone number (${phone.nationalNumber}).`);
            }
        }
    };

    format(phoneNumber: string): FormattedPhoneNumber {
        try {
            const phone = parsePhoneNumberFromString(phoneNumber);

            if(!phone) {
                throw new Error(phoneNumber);
            }

            return {
                countryCode: phone.country || "US",
                countryCallingCode: phone.countryCallingCode,
                nationalNumber: phone.nationalNumber,
                e164Format: phone.number
            };
        } catch(e: any) {
            throw new Error(`Invalid phone number format: ${e.message}`);
        }
    };

    formatAndValidate(phone: string): FormattedPhoneNumber {
        this.validate(phone);

        return this.format(phone);
    };
};