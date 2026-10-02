public with sharing class BulkImportController {

/* Get available field sets for an object */
    @AuraEnabled(cacheable=true)
    public static List<String> getFieldSets(String objectApiName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectApiName);
        return new List<String>(objType.getDescribe().fieldSets.getMap().keySet());
    }

    /* Get fields from a field set */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getFieldSetFields(String objectApiName, String fieldSetName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectApiName);
        Schema.FieldSet fs = objType.getDescribe().fieldSets.getMap().get(fieldSetName);

        List<Map<String, String>> result = new List<Map<String, String>>();
        for (Schema.FieldSetMember f : fs.getFields()) {
            result.add(new Map<String, String>{
            'apiName' => f.getFieldPath(),
            'label' => f.getLabel(),
            'type' => String.valueOf(f.getType())
            });     
        }
        return result;
    }

    /* Bulk Insert Records */
    @AuraEnabled
public static void importRecords(String objectApiName, List<Map<String, Object>> rows) {

    if (String.isBlank(objectApiName) || rows == null || rows.isEmpty()) {
        throw new AuraHandledException('No data received');
    }

    Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectApiName);
    if (sObjType == null) {
        throw new AuraHandledException('Invalid object');
    }

    Map<String, Schema.SObjectField> fieldMap =
        sObjType.getDescribe().fields.getMap();

    List<SObject> recordsToInsert = new List<SObject>();

    for (Map<String, Object> row : rows) {
        SObject record = sObjType.newSObject();

        for (String fieldApi : row.keySet()) {

            if (!fieldMap.containsKey(fieldApi)) continue;

            Schema.DescribeFieldResult d = fieldMap.get(fieldApi).getDescribe();

            // 🚨 Skip read-only fields
            if (!d.isCreateable()) continue;

            Object value = row.get(fieldApi);
            if (value != null && String.valueOf(value).trim() != '') {
                record.put(fieldApi, value);
            }
        }

        recordsToInsert.add(record);
    }

    if (recordsToInsert.isEmpty()) {
        throw new AuraHandledException('No valid records to insert');
    }

    Database.SaveResult[] results = Database.insert(recordsToInsert, false);

    List<String> errors = new List<String>();
    for (Integer i = 0; i < results.size(); i++) {
        if (!results[i].isSuccess()) {
            errors.add(
                'Row ' + (i + 2) + ': ' +
                results[i].getErrors()[0].getMessage()
            );
        }
    }

    if (!errors.isEmpty()) {
        throw new AuraHandledException(String.join(errors, '\n'));
    }
}

}