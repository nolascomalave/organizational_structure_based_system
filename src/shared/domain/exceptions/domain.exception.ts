export abstract class DomainException extends Error {
    abstract readonly code: string;
    abstract readonly status: number; // Opcional, solo para mapeo
}