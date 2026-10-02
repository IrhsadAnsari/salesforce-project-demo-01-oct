public with sharing class DynamicRequestQueryService {

    /**
     * Executes the Request SOQL configured on
     * InterfaceServiceRequest__c.
     *
     * The configured SOQL must use:
     *
     * WHERE Id = :recordId
     *
     * Example:
     * SELECT Id, Name, Phone
     * FROM Account
     * WHERE Id = :recordId
     */
    public static List<SObject> executeRequestSOQL(
        String requestSOQL,
        Id recordId
    ) {
        if (String.isBlank(requestSOQL)) {
            throw new IntegrationException(
                'Request SOQL is not configured.'
            );
        }

        if (recordId == null) {
            throw new IntegrationException(
                'Record Id cannot be null.'
            );
        }

        // Bind variables used by the dynamic SOQL
        Map<String, Object> bindVariables =
            new Map<String, Object>{
                'recordId' => recordId
            };

        try {

            List<SObject> records = Database.queryWithBinds(
                requestSOQL,
                bindVariables,
                AccessLevel.USER_MODE
            );

            return records;

        } catch (QueryException e) {

            throw new IntegrationException(
                'Error executing Request SOQL: ' +
                e.getMessage()
            );
        }
    }


    public class IntegrationException extends Exception {
    }
}