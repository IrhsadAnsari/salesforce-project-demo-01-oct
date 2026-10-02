public class AccountHandler {
 public static void validateAccount(list<Account> accounts)
 {
     Set<Id> accountid =new Set<Id>();
     for(Account acc:accounts)
     {
         if(acc.id !=null)
         accountid.add(acc.id);
     }
     List<Opportunity> oplist= [Select id,StageName from Opportunity where accountId in :accountid];
    
     for(Account ac:accounts)
     {
         
         for(Opportunity op:oplist)
         {
             if(ac.id != null && op.StageName =='Needs Analysis')
             {
                 ac.addError('You can not delete the account beacause Oppornity is Open');
             }
         }     
      }      
   }
    //Storing Opportunity with Associated account id
    public static void OpportunityWithAccountId()
    {
        List<Account> accountList = [Select id, name from account limit 10 offset 2 ];
        //Stoing account id and name in map
        Map<Id, String> mapAccountName = New Map<Id, String>();
        for(Account acc :accountList)
        {
            mapAccountName.put(acc.Id, acc.Name);
        }
        System.debug('Account Id and Name associated with that: --->'+mapAccountName);
        System.debug('Key of the Map are:--'+mapAccountName.keySet());
        System.debug('Value of the Map are:--'+mapAccountName.values());
        System.debug('Fetch id of the Map :--'+mapAccountName.get('0015i00000nSExGAAW'));
        // System.debug('all Name of the Map are:--'+mapAccountName.get('Name'));
        for(Account acc : accountList)
        {
            if(mapAccountName.containsKey(acc.Id))
            {
                System.debug('List of Ids-->'+mapAccountName.get(acc.Id));
                //System.debug('List of Name-->'+mapAccountName.get(acc.Name)); 
            }
        }  
        
//    List<Opportunity> opplist = [Select id, Name, StageName,AccountId from Opportunity where accountId in :mapAccountName.keySet()];
           List<Opportunity> opplist = [Select id, Name, StageName,AccountId from Opportunity where accountId in :accountList];
        Map<Id, List<Opportunity>> accToOppMap = New Map<Id, List<Opportunity>>();
        System.debug('List related Opportunity-->'+opplist);
        System.debug('Total related Opportunity-->'+opplist.size());
        for(Opportunity opp :opplist)
        {
            if(accToOppMap.containskey(opp.accountId))
            {
                accToOppMap.get(opp.accountId).add(opp);
            }
            else{
                accToOppMap.put(opp.accountId, new List<Opportunity> {opp});
            }
        }
        System.debug('Map of Opportunity with account--->'+accToOppMap); 
        For(Account Acc:accountList ){
           System.debug('Realeted Opportunity with Account id'+accToOppMap.get(acc.Id));
    }
  
   }
    //Creating Map to sroe the Contact with account Id
    Public static void conactMapWithAccount()
    {
        List<Account> accountList = [select id, name from Account limit 20 offset 0];
        List<Contact> contactlist  = [Select id ,name,accountId from Contact where AccountId in:accountList];
      Map<Id, List<Contact>>  accounToContactMap = new Map<ID, List<Contact>>();
        for(Contact con : contactlist)
        {
            if(accounToContactMap.containsKey(con.accountId))
               {
                   accounToContactMap.get(con.accountId).add(con);
                  
               }
               else
               {
                   accounToContactMap.put(con.accountId, new List<Contact>{con});
               }
        }
     System.debug('Map of Contact with account--->'+accounToContactMap); 
      For(Account acc:accountList)
      {
          System.debug('Conatct with accountid as key :'+accounToContactMap.get(acc.Id));
      }
        
    }
    //Restrict to delete of the account if contact associated with that contact.
    public static void restricAccountDeletion(List<Account> OldEntries)
    {
        List<Contact> contactList = [Select id, Name,FirstName, AccountId from Contact where AccountId In : OldEntries];
        Map<Id, list<Contact>> accToContactMap = new Map<Id, List<Contact>>();
        For(Contact con : contactList)
        {
            if(accToContactMap.containsKey(con.AccountId))
            {
                accToContactMap.get(con.AccountId).add(con);
            }
            else{
                accToContactMap.put(con.AccountId, New List<Contact>{con});
            }
        } 
        if(OldEntries.size() > 0)
        for(Account entry : OldEntries)
        {
           if(entry.Id !=null && accToContactMap.get(entry.id) !=null)
           {
               for(Contact con :accToContactMap.get(entry.id))
               {
                 if(con.FirstName == 'Sean')
                 entry.addError('You can not delete account because it has associated contact as firsname Sean');   
               }
           }
        }
        
    }
    // Populate then nomber of field contact with associated contact on to the account whenever account updated
    
    public static void returnNumberOfContactOnAccount(List<Account> newEntries)
    {
        
        List<Contact> contactList = [Select id, Name,FirstName, AccountId from Contact where AccountId In : newEntries];
        Map<Id, list<Contact>> accToContactMap = new Map<Id, List<Contact>>();
        For(Contact con : contactList)
        {
            if(accToContactMap.containsKey(con.AccountId))
            {
                accToContactMap.get(con.AccountId).add(con);
            }
            else{
                accToContactMap.put(con.AccountId, New List<Contact>{con});
            }
        } 
        if(newEntries.size() > 0)
        for(Account entry : newEntries)
        {
           if(entry.Id !=null && accToContactMap.get(entry.id) !=null)
           {
               entry.NumberOfContact__c	 = accToContactMap.get(entry.id).size();
           }
        } 
   }
   //Write a trigger to update phone number on account and mark the IsPhoneNumber  as true with all 
   //associated contact

public static void updateIsPhoneNumberOnContact(List<Account> newAccount, List<Account> oldAccount)
{
    List<Account> modifiedAccount = new List<Account>();
    
    For(Account accnew: newAccount)
    {
      for(Account accold : oldAccount)
      {
        if(accnew.Phone != accold.Phone)
        {
            modifiedAccount.add(accnew);
        }
      }
    }
    List<Contact> contactList = new List<Contact>();
    if(modifiedAccount.size() > 0)
    contactList =[Select id, name,AccountId,IsPhoneNumberUpdated__c from Contact where AccountId In :modifiedAccount];
        for(Contact con : contactList)
        {
            con.IsPhoneNumberUpdated__c =true;
        }
    
    update contactList;
}
//RoundRobinTracker__c	,Last_Assigned_Index__c
    Public static void assignOwner(Boolean isInsert ,List<Account> newEntries)
    {
        if(isInsert){
        List<Round_Robin__mdt> config =[Select id,User_Name__c,Object_Type__c,Sequence_Number__c from Round_Robin__mdt where
                                 Object_Type__c ='Account' order by Sequence_Number__c ASC]; 
        System.debug('Metadata record '+config);
        List<String> userIdList = new List<String>();
        for(Round_Robin__mdt mt : config)
        {
            userIdList.add(mt.User_Name__c);
        }
            System.debug('User Id list' +userIdList);
        //Load Tracker
        //RoundRobinTracker__c tracker = RoundRobinTracker__c.getInstance('a0OJ3000000yMhO');
        //Integer lastIndex = tracker != null ? (Integer)tracker.Last_Assigned_Index__c :-1;
      //  Integer currentIndex = lastIndex;
      RoundRobinTracker__c tracker = RoundRobinTracker__c.getOrgDefaults();
            System.debug('Tracker'+tracker);
            if(tracker == null){
            tracker =new RoundRobinTracker__c(Name='Account',SetupOwnerId = UserInfo.getOrganizationId(),Last_Assigned_Index__c = -1);
             insert tracker;
          }
            
            Integer lastIndex = tracker != null ? (Integer)tracker.Last_Assigned_Index__c :-1;
            Integer currentIndex = lastIndex;
            System.debug('last index'+lastIndex);
            
            System.debug('Current index'+currentIndex);
            List<Account> accountToUpdate= new List<Account>();
        
        for(Account entry: newEntries)
        {
            currentIndex = Math.mod((currentIndex +1), userIdList.size());
            System.debug('Current index2'+currentIndex);
            //Account acc = new Account(Id= entry.Id);
            entry.AssigneeId__c = Id.valueOf(userIdList[currentIndex]);
           // acc.AssigneeId__c =Id.valueOf(userIdList[currentIndex]);
            //accountToUpdate.add(acc);
        }
           /*if(accountToUpdate.size() > 0)
            {
             update accountToUpdate ;
            }*/
         if(currentIndex == userIdList.size() - 1){
            tracker.Last_Assigned_Index__c =-1;        
  
            }
            else{
               tracker.Last_Assigned_Index__c= currentIndex;
            }  
        System.debug('Upserting Tracker'+tracker);
        upsert tracker;
    }
   }
    // Wrapper for Flow input
   public class FlowInput {
        @InvocableVariable(label='Name' required=true)
        public String accName;
        
        @InvocableVariable(label='Created Date' required=true)
        public Date varCreatedDate;
        @InvocableVariable(label=' Phone Number' required=true)
        public string varPhone;
    }
    
    @InvocableMethod
    public static void createAccount(List<FlowInput> flowInputs){
        List<Account> accountList = new List<Account>();
        for(FlowInput input : flowInputs){
            Account a =new Account();
            a.Name = input.accName;
            a.Account_Creation_date__c =input.varCreatedDate;
            a.Phone =input.varPhone;
            accountList.add(a);
        }
        if(!accountList.isEmpty()) insert accountList;
            
      }  
}