/**
* @File Name : GenericClass.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : June 1, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | June 1, 2025 |   | Initial Version
**/

public class GenericClass {
	@AuraEnabled
	public static void LightningStudio(){
		System.debug('Lightning Studio');
	}

	@AuraEnabled
	public static List<SObject> recordValues(String objectName)
	{
      if(String.isBlank(objectName))
	   {
	      throw new AuraHandledException('Object name Cannot be null or Empty.');	
	   }
	   	try{
            String query ='Select Id, Name from '+ String.escapeSingleQuotes(objectName); 
		    return Database.query(query);
		}
		catch (Exception e) {
			throw new AuraHandledException('Failed to fetch record: ' + e.getMessage());
      }

     		
	}

     @AuraEnabled
	public static void updateSelectedRecordWithCurrentRecordPageId(List<SObject> listToUpdate)
	{
		try{
		if(listToUpdate.size() > 0){
			
		  update listToUpdate;
		}
		}
		catch(Exception e){
				throw new AuraHandledException('Failed update record '+e.getMessage());
			}
		
	}
	@AuraEnabled(cacheable=true)
	public static List<WrapperField> getFieldList(String objectName, String fieldSetName){
		List<WrapperField> listfieldWrapper = new List<WrapperField>();
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
		Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
		Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
		Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);	
		for(Schema.FieldSetMember f : fieldSetObj.getFields())
		{
			WrapperField temp = new WrapperField();
			temp.fieldAPIName = f.getFieldPath();
			temp.label = f.getLabel();
			temp.type = String.valueOf(f.getType());
			listfieldWrapper.add(temp);
		}
		return listfieldWrapper;
	}
	public class WrapperField{
		@AuraEnabled public String fieldAPIName;
		@AuraEnabled public String label;
		@AuraEnabled public String type; 		 
		@AuraEnabled public String helpText;
	}
   
    //I have to write a generic  Query on the Basis of Object and fieldset.
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectName, String fieldSetName){
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj =objectMap.get(objectName);
        Schema.DescribeSObjectResult DesctibeSobjetObjType = SObjectTypeObj.getDescribe();
        Schema.FieldSet FieldSetObject = DesctibeSobjetObjType.FieldSets.getMap().get(fieldSetName);
        
        List<String> fieldPaths = new List<String>();
        for(Schema.FieldSetMember f :FieldSetObject.getFields() ){
            fieldPaths.add(f.getFieldPath());
        }
        String fields = String.join(fieldPaths,',');
        String query = 'SELECT '+fields+' FROM '+objectName;
        return Database.query(query);
    }
}