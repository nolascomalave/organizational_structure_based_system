// domain/transaction-manager.interface.ts
export const TRANSACTION_MANAGER_REPOSITORY = Symbol("TRANSACTION_MANAGER_REPOSITORY");
export default abstract class TransactionManager {
    /**
     * Ejecuta el callback dentro de una transacción de base de datos.
     * Si el callback lanza una excepción, se hace rollback automático.
     * Retorna el valor retornado por el callback.
     */
    abstract execute<T>(callback: (tx?: any) => Promise<T>): Promise<T>;
  }