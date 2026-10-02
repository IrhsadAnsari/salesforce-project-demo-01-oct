public with sharing class CommonHendler {
    private static final String RECORD_ID = 'Id';
    public CommonHendler() {

    }
    //Write A trigger to return Number of Contact whnenever a contact is Inserted,Updated, deleted,Undeleted
    Public static void numberofContactOnAccount(Boolean isInsert, Boolean isUpdate, Boolean isUndelete,
    Boolean isDelete, List<Contact> newContact, List<Contact> oldContact)
    {
      if(isInsert || IsUpdate || isUndelete | isDelete)
      {
        List<Contact> contactList = (newContact != null && !newContact.isEmpty()) ? newContact : oldContact;
      
      Map<Id, Contact> accToContactMap= New Map<Id,Contact>();
      Map<Id, List<Contact>> newAccToContactMap =new Map<Id, List<Contact>>();
      for(Contact con : contactList)
      {
        accToContactMap.put(con.accountId, con);
      }
      List<Account> accList = [select id,NumberOfContact__c from Account where Id In:accToContactMap.keySet()];
      List<Contact> existingContact =[Select Id,Name,AccountId from Contact Where AccountId In: accToContactMap.keySet()];
      for(Contact con : existingContact)
      {
        if(newAccToContactMap.containsKey(con.AccountId))
        {
            newAccToContactMap.get(con.AccountId).add(con);
        }
        else{
            newAccToContactMap.put(con.AccountId, new List<Contact>{con});
        }
      }
      for(Account acc : accList)
      {
        acc.NumberOfContact__c =newAccToContactMap.get(acc.Id).size();
      }
      update accList;
      }
    }
    //Return List of Id of the Sobject
    public static List<Id> extractIds(List<SObject> records)
    {
      List<Id> recordIds = new List<Id>();
      for(SObject record : records)
        {
            if(record.get(RECORD_ID) != null && !recordIds.contains((ID)record.get(RECORD_ID)))
            {
                recordIds.add((ID)record.get(RECORD_ID));
            }
        }
        return recordIds;
    }
    //Return specific Record based on the ObjectId
    Public static Sobject getObjet(List<SObject> objects, Id objectId)
    {
        for(SObject objectEntry : objects)
        {
            if(objectEntry.Id == objectId)
            {
                return objectEntry;
            }
        }
        return null;
    }
    // Return Specific record based on the Passing id field and Id
    public static SObject getObject(List<SObject> objects, String idFieldName, Id objectId)
    {
        for(SObject objectEntry : objects)
        {
            if(objectEntry.get(idFieldName) == objectId)
            {
                return objectEntry;
            }
        }
        return null;
    }
    //Generic method To check any a parent have any child or not.
    public static List<SObject> getRelatedRecord(List<SObject> records,String objectName,String relationFieldName)
    {
        List<SObject> relatedRecords = new List<SObject>();
        String query = 'SELECT Id, ' + relationFieldName + ' FROM ' + objectName + 
        ' WHERE ' + relationFieldName + ' IN :records';
        if(records.size() > 0)
        {
            relatedRecords =Database.query(query);
        }
        return relatedRecords;
    }
    //use of above generic code
    Public static void checkAccountWithContact(Boolean isDelete, List<Account> oldRecord)
    {
        List<Contact> contactList= (List<Contact>)getRelatedRecord(oldRecord , 'Contact','AccountId');
        Map<Id, List<Contact>> accToContactMap = new Map<Id, List<Contact>>();
        for(Contact con : contactList)
        {
          if(accToContactMap.containsKey(con.AccountId))
          {
            accToContactMap.get(con.AccountId).add(con);
          }
          else{
            accToContactMap.put(con.AccountId, new List<Contact>{con});
          }
        }
        if(contactList.size() > 0)
        {
            for(Account acc : oldRecord)
            {
                if(acc.Id !=null && accToContactMap.get(acc.Id).size() >0)
                  acc.addError('You can not delete a account because it has associated contact!');
            } 
        }   
    }
   // Generic code for return map of Sobject for child record
    public static Map<Id,List<SObject>> getRelatedRecordMap(List<SObject> records,String objectName,String relationFieldName)
    {
        List<SObject> relatedRecords = new List<SObject>();
        Map<Id, List<SObject>> relatedParentIdIWhtChildRecord =new Map<Id, List<SObject>>();
        String query = 'SELECT Id, ' + relationFieldName + ' FROM ' + objectName + 
        ' WHERE ' + relationFieldName + ' IN :records';
        if(records.size() > 0)
        {
            relatedRecords =Database.query(query);
        }
        for(SObject entry :relatedRecords)
        {
            Id  paentId = (Id)entry.get(relationFieldName);
            if(relatedParentIdIWhtChildRecord.containsKey((Id)entry.get(relationFieldName)))
            {
                relatedParentIdIWhtChildRecord.get((Id)entry.get(relationFieldName)).add(entry);
            }
            else{
                relatedParentIdIWhtChildRecord.put((Id)entry.get(relationFieldName), new List<SObject>{entry}); 
            }
        }
        return relatedParentIdIWhtChildRecord;
    }
    Public static void checkAccountWithContactMap(Boolean isDelete, List<Account> oldRecord)
    {
        if(isDelete)
        {
            Map<Id,List<Contact>> accounToContactMap= (Map<Id,List<Contact>>)getRelatedRecordMap(oldRecord , 'Contact','AccountId');

        if(accounToContactMap.size() > 0)
        {
            for(Account acc : oldRecord)
            {
                if(acc.Id !=null && accounToContactMap.get(acc.Id).size() >0)
                  acc.addError('You can not delete a account because it has associated contacts!');
            } 
        } 
        }
         
    }
    
    //Wrtie a method to return all the object and field into the map.
    public static void getObjectStructure()
    {
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        System.debug(' Key Details:'+ objectMap.keySet());
        System.debug(' Value Details of the map: '+objectMap.values());
    }

    @AuraEnabled(cacheable=true)
    public static List<FieldDefinition> getFieldSetField(String objectName, String fieldSetName)
    {
     List<FieldDefinition> fieldDefs = New List<FieldDefinition>();
     Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
     Schema.DescribeSobjectResult describeSobjectResult = sObjectType.getDescribe();
     Schema.FieldSet fieldSet = describeSobjectResult.fieldSets.getMap().get(fieldSetName);
     for(Schema.FieldSetMember f : fieldSet.getFields()){
        fieldDefs.add(new FieldDefinition(f.getFieldPath(), f.getLabel(), f.getType()));
     }
     return fieldDefs;
    }

    public class FieldDefinition{
        @AuraEnabled public  String apiName;
        @AuraEnabled public String label;
        @AuraEnabled public String dataType;
        public FieldDefinition( String apiName, String label, Schema.DisplayType dataType){
            this.apiName = apiName;
            this.label = label;
            this.dataType = String.valueOf(dataType);
        } 
    }

    
}