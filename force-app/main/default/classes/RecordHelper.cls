/**
* @File Name : RecordHelper.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : August 25, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | August 25, 2024 |   | Initial Version
**/

public class RecordHelper {
	private static final String FIELDNAME_ID ='Id';

	public static List<Id> extractIds(List<sObject> records )
	{
		List<Id> resultIds = new List<Id>();
		for (sObject record : records)
		{
		  if(record.get(FIELDNAME_ID)!= null && !resultIds.contains((ID)record.get(FIELDNAME_ID)))
		  {
            resultIds.Add((ID)record.get(FIELDNAME_ID));
		  }
		}
		return resultIds;
	}
	public static SObject getObject(List<SObject> objects, Id objectId)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.Id == objectId){
                return objectEntry;
            }
        }
        return null;
    }
	 public static SObject getObject(List<SObject> objects, String idFieldName, Id objectId)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.get(idFieldName) == objectId){
                return objectEntry;
            }
        }
        return null;
    }
    
    public static AggregateResult getObject(List<AggregateResult> objects, string idFieldName, Id objectId){
        for(AggregateResult objectEntry : objects){
            if(objectEntry.get(idFieldName) == objectId){
                return objectEntry;
            }
        }
        return null;
    }

    public static List<ID> extractIds(List<SObject> records, string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !resultIds.contains((ID)record.get(fieldName))){
                resultIds.Add((ID)record.get(fieldName));
            }
        }
        return resultIds;
    }

 

    public static List<String> extractValues(List<SObject> records, string fieldName)
    {
        List<String> resultIds = new List<String>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !resultIds.contains((String)record.get(fieldName))){
                resultIds.Add((String)record.get(fieldName));
            }
        }
        return resultIds;
    }

    public static List<Decimal> extractIntegerValues(List<SObject> records, string fieldName){
        List<Decimal> resultIds = new List<Decimal>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !resultIds.contains((Decimal)record.get(fieldName))){
                resultIds.Add((Decimal)record.get(fieldName));
            }
        }
        return resultIds;
    }

    public static List<Id> extractIds(List<AggregateResult> records, string fieldName)
    {
        List<Id> resultIds = new List<Id>();
        for(AggregateResult record : records){
            if(record.get(fieldName) != null && !resultIds.contains((ID)record.get(fieldName))){
                resultIds.Add((ID)record.get(fieldName));
            }
        }
        return resultIds;
    } 

    public static List<String> extractUniqueValues(List<SObject> records, string fieldName)
    {
        List<String> results = new List<String>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains((String)record.get(fieldName))){
                results.Add((String)record.get(fieldName));
            }
        }
        return results;
    }

    public static List<String> extractUniqueIds(List<SObject> records, string fieldName)
    {
        List<Id> results = new List<Id>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains((Id)record.get(fieldName))){
                results.Add((Id)record.get(fieldName));
            }
        }
        return results;
    }

    public static List<ID> extractIdsFromLookup(List<SObject> records, string lookupFieldReference, string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            SObject relatedRecord = (SObject)record.GetsObject(lookupFieldReference);
            if(relatedRecord !=null){
                if(relatedRecord.get(fieldName) != null)
                    resultIds.Add((ID)relatedRecord.get(fieldName));
            }
        }
        return resultIds;
    }

    public static List<SObject> extractUniqueObjects(List<SObject> records, string fieldName)
    {
        List<SObject> results = new List<SObject>();
        List<Object> fieldValues = new List<Object>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !fieldValues.contains(record.get(fieldName))){
                fieldValues.Add(record.get(fieldName));
                results.add(record);
            }
        }
        return results;
    }

 

    public static List<SObject> getModifiedNewObjects(
        string fieldNameToCheck, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.get(fieldNameToCheck) != lineEntry.get(fieldNameToCheck)) {                    
                    modifiedObjects.add(lineEntry);
                } 
            }   
        }
        return modifiedObjects;
    }

 

    public static List<SObject> getModifiedNewObjects(List<String> fieldNamesToCheck, List<SObject> oldEntries, List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                for(String fieldName: fieldNamesToCheck){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        modifiedObjects.add(lineEntry);
                        break;
                    } 
                }
            }   
        }
        return modifiedObjects;
    }

 

    //@namespaceAccessible
    public static List<SObject> getApprovedObjects(String approvalfieldNames, List<SObject> oldEntries, List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.get(approvalfieldNames) != lineEntry.get(approvalfieldNames) 
&& ((Boolean)lineEntry.get(approvalfieldNames))) {                    
                    modifiedObjects.add(lineEntry);
                    // break;
                } 
            }   
        }
        return modifiedObjects;
    }

 

    public static List<SObject> getApprovedNewObjects(String approvalfieldNames, List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null){
            return modifiedObjects;
        }
        for(SObject lineEntry : newEntries){
            if((Boolean)lineEntry.get(approvalfieldNames)) {
                modifiedObjects.add(lineEntry);
                //break;
            } 
        }
        return modifiedObjects;
    }

 

    public static List<SObject> getNotApprovedNewObjects(String approvalfieldNames, List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null){
            return modifiedObjects;
        }
        for(SObject lineEntry : newEntries){
            if(!(Boolean)lineEntry.get(approvalfieldNames)) {
                modifiedObjects.add(lineEntry);
                //break;
            } 
        }
        return modifiedObjects;
    }
 

    public static List<SObject> getObjectsWithNotNull(List<SObject> objects, String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) != null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

 

    public static List<SObject> getObjectsWithNull(List<SObject> objects, String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

 

    public static SObject getObjectByFilter(List<SObject> objects, String fieldName, Object value)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value){
                return objectEntry;
            }
        }
        return null;
    }

 

    public static List<SObject> getObjectsByFilter(List<SObject> objects, String fieldName, object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

 

    public static List<SObject> getObjectsNotEqualsTo(List<SObject> objects, String fieldName, object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) != value){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    public static void validateChangeInSystemFields(List<String> systemFields, List<SObject> oldEntries, List<SObject> newEntries){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                for(String fieldName: systemFields){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        //lineEntry.addError(String.format(
                           // String.valueOf(System.Label.IntegrityFailed_SystemFieldNotEditable), 
                          //  new String[]{fieldName})); 
                    } 
                }
            }   
        }
    }

    public static void validateCanBeDeleted(List<SObject> oldEntries, String fieldName, Boolean value)
    {
        for(SObject oldEntry : oldEntries){
            if(oldEntry.get(fieldName) == value){
              //  oldEntry.addError(String.valueOf(System.Label.LineFieldsCannotBeDeleted));
            }
        }
    }

    public static void validateCanBeDeleted(List<SObject> oldEntries)
    {
        {
        if(oldEntries==null){
            return;
        }
            for(SObject oldEntry : oldEntries){
               // oldEntry.addError(String.valueOf(System.Label.LineFieldsCannotBeDeleted)); 
        }

      }
    }

    public static SObject getFirstIfExists(List<SObject> objects)
    {
        if(objects?.size()>0){
            return objects[0];
        }
        return null;
    }

    public static List<Date> extractUniqueDateValues(List<SObject> records, string fieldName)
    {
        List<Date> results = new List<Date>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains((Date)record.get(fieldName))){
                results.Add((Date)record.get(fieldName));
            }
        }
        return results;
    }

    public static List<ID> extractIds(List<SObject> records, string relationshipName, string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            List<SObject> relatedRecords = (List<SObject>)record.getSObjects(relationshipName);
            if(relatedRecords !=null && relatedRecords.size() > 0){
                for(SObject relatedRecord : relatedRecords){
                    if(relatedRecord.get(fieldName) != null 
                        && !resultIds.contains((ID)relatedRecord.get(fieldName))){
                        resultIds.Add((ID)relatedRecord.get(fieldName));
                    }
                }
            }
        }
        return resultIds;
    }
}