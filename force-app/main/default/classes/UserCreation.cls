public class UserCreation {
   public static void permissionSetforUser(Boolean isInsert, List<User> newUser)
   { 
       if(isInsert & !newUser.isEmpty())
       {
       List<Permission_Set_Metadata__mdt> metadataList =new  List<Permission_Set_Metadata__mdt>();
       For(User user:newUser){
           // Fetch the appropriate permission sets based on user type
            metadataList = [
                SELECT ID,Permission_Set_Id__c,IsActive__c,User_Type__c 
                FROM Permission_Set_Metadata__mdt 
                WHERE User_Type__c =:user.User_Type__c
            ];
       }
       List<PermissionSetAssignment> permssionListTOEngineer = new List<PermissionSetAssignment>();
       For(User user:newUser)
       {
           for(Permission_Set_Metadata__mdt mdtlist:metadataList)
           {
               if(user.User_Type__c == mdtlist.User_Type__c)
               {
                  permssionListTOEngineer.add(new PermissionSetAssignment(PermissionSetId = mdtlist.Permission_Set_Id__c, AssigneeId = user.id));
               }
           }
       }
       Database.SaveResult[] permResults = Database.insert(permssionListTOEngineer, false);
       for (Database.SaveResult result : permResults) {
         if (!result.isSuccess()) {
          System.debug('Failed PermissionSetAssignment: ' + result.getErrors()[0].getMessage());
          }
       }   
   } 
  }  
  Public static void publishUserPlateformEvent(Boolean isInsert, List<User> userNewRecord)
    {
        if(isInsert)
        {
            
        
        List<UserCreationNotification__e> userlistToPublish = new List<UserCreationNotification__e>();
        for(User u : userNewRecord)
        {
            userlistToPublish.add(new UserCreationNotification__e(UserName__c = u.Name));
        }
        EventBus.publish(userlistToPublish);
        }     
    }
}


/*
Set<Id> userId= new set<Id>();
for(User user:userlist)
{
    userId.add(user.Id);
}
System.debug('userid-->'+userId);
List<User> FetchedUser = [
    SELECT Id, FirstName, LastName, Email, Username, ContactId, UserRoleId, ProfileId, 
           CompanyName, FederationIdentifier, Alias, TimeZoneSidKey, 
           LocaleSidKey, EmailEncodingKey, LanguageLocaleKey 
    FROM User 
    WHERE Id IN :userId
];
System.debug('FetchedUser-->'+FetchedUser);


//for Permission set assignment 
List<String> userTypes =new List<String>();
Set<Id> userIds = new Set<Id>();
for (User user : userList) {
    userIds.add(user.Id);
    userTypes.add(user.User_Types__c);
}
System.debug('List of unique inserted User IDs: ' + userIds);

// Permission Set Assignment
List<PermissionSetAssignment> permssionListTOEngineer = new List<PermissionSetAssignment>();
Set<Id> uniqueEngineerPermission = new Set<Id>{'0PS5i000008WuxI'};
for (Id userId : userIds) {
    for (Id uniquePermissionId : uniqueEngineerPermission) {
        permssionListTOEngineer.add(new PermissionSetAssignment(PermissionSetId = uniquePermissionId, AssigneeId = userId));
    }
}
Database.SaveResult[] permResults = Database.insert(permssionListTOEngineer, false);
for (Database.SaveResult result : permResults) {
    if (!result.isSuccess()) {
        System.debug('Failed PermissionSetAssignment: ' + result.getErrors()[0].getMessage());
    }
}
System.debug('Permission Sets Assigned: ' + permssionListTOEngineer);

// Fetch the appropriate permission sets based on user type
            List<Permission_Set_Metadata__mdt> metadataList = [
                SELECT ID,Permission_Set_Id__c,IsActive__c,User_Type__c 
                FROM Permission_Set_Metadata__mdt 
                WHERE User_Type__c In :userTypes
            ];
Set<Id> permissionIds= new Set<Id>();
For(Permission_Set_Metadata__mdt prmId:metadataList)
{
    permissionIds.add(prmId.Permission_Set_Id__c);
}
List<PermissionSetAssignment> permssionListTOEngineer = new List<PermissionSetAssignment>();
for (Id userId : userIds) {
    for (Id prid : permissionIds) {
        permssionListTOEngineer.add(new PermissionSetAssignment(PermissionSetId = prid, AssigneeId = userId));
    }
}
Database.SaveResult[] permResults = Database.insert(permssionListTOEngineer, false);
for (Database.SaveResult result : permResults) {
    if (!result.isSuccess()) {
        System.debug('Failed PermissionSetAssignment: ' + result.getErrors()[0].getMessage());
    }
*/