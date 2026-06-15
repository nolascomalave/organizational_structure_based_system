// domain/transaction-manager.interface.ts
export default interface TransactionManagerRepository {
    /**
     * Ejecuta el callback dentro de una transacción de base de datos.
     * Si el callback lanza una excepción, se hace rollback automático.
     * Retorna el valor retornado por el callback.
     */
    execute<T>(callback: (tx?: any) => Promise<T>): Promise<T>;
  }