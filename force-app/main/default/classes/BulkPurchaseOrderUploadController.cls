public with sharing class BulkPurchaseOrderUploadController {

    public static final String OBJ = 'Purchase_Order__c';
    public static final String FIELD_SET = 'Import_Field_set';

    /**
     * Return field API names from field set
     */
    @AuraEnabled(cacheable=true)
    public static List<String> getFieldSetFields() {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(OBJ);
        Schema.DescribeSObjectResult objDesc = objType.getDescribe();

        Schema.FieldSet fieldSet = objDesc.fieldSets.getMap().get(FIELD_SET);
        List<String> apiNames = new List<String>();

        for (Schema.FieldSetMember f : fieldSet.getFields()) {
            apiNames.add(f.getFieldPath());
        }
        return apiNames;
    }

    /**
     * Process bulk upload with error handling
     */
    @AuraEnabled
    public static Map<String, Object> processBulkUpload(String jsonData) {
        List<Map<String, Object>> rows =
            (List<Map<String, Object>>) JSON.deserializeUntyped(jsonData);

        List<String> allowedFields = getFieldSetFields();

        List<SObject> toInsert = new List<SObject>();
        List<String> errors = new List<String>();

        Integer rowNum = 1;

        for (Map<String, Object> row : rows) {
            rowNum++;

            if (row.isEmpty()) {
                errors.add('Row ' + rowNum + ' is empty.');
                continue;
            }

            SObject po = (SObject) Type.forName('Schema.' + OBJ).newInstance();
            Boolean hasValidField = false;

            for (String col : row.keySet()) {
                if (!allowedFields.contains(col)) {
                    errors.add('Row ' + rowNum + ': Invalid column → ' + col);
                    continue;
                }

                try {
                    po.put(col, row.get(col));
                    hasValidField = true;
                } catch (Exception e) {
                    errors.add('Row ' + rowNum + ' Field: ' + col +
                        ' → ' + e.getMessage());
                }
            }

            if (hasValidField) {
                toInsert.add(po);
            } else {
                errors.add('Row ' + rowNum + ': No valid fields.');
            }
        }

        // Save records with partial success
        Database.SaveResult[] results = Database.insert(toInsert, false);

        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                for (Database.Error err : results[i].getErrors()) {
                    errors.add('Row ' + (i + 1) + ': ' + err.getMessage());
                }
            }
        }

        return new Map<String, Object>{
            'successCount' => toInsert.size() - errors.size(),
            'errorCount' => errors.size(),
            'errors' => errors
        };
    }
}