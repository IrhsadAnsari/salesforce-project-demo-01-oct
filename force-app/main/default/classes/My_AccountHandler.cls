public class My_AccountHandler {
    /*Whenever New Account reocrd is created then needs to creata Associated Contact Automatically*/
    public static void accountToAssociatedContact( list<Account> accRecords)
    {
        Set<id> accountId = new Set<Id>();
        List <Contact> conlist = new List<Contact>(); 
        for(Account a:accRecords)
        {
            Contact con = new Contact();
           con.accountId = a.Id;
           con.firstName= 'Irshad';
           con.lastName= 'Ansari';
           con.Phone = a.Phone;
           conlist.add(con); 
        }
        insert conlist;
    }
   /* Whenever an Account is created with Industry as Banking then Create a Contact for the Account
    Contact lastName as Account name and contact phone as Account phone.*/
      public static void accountAndContactwithLastName( list<Account> accRecords)
    {
        Set<id> accountId = new Set<Id>();
        List <Contact> conlist = new List<Contact>(); 
        for(Account a:accRecords)
        {
            Contact con = new Contact();
            if(a.Industry=='Banking')
            {
           con.accountId = a.Id;
           con.lastName= a.Name	;
           con.Phone = a.Phone;
           conlist.add(con);
            }
            
        }
        insert conlist;
    
   }
    /*Creates the number of contacts which are equal to the number 
    which we will enter in the Number of Locations field on the Account Object.
    */
    public static void contactEqualNumberOfLocationsOnAccount(List<Account> accRecords)
    {
        system.debug('46== ');
        List<Contact> conlist = New List<Contact>();
        Map<ID, Decimal> mapAcc = New Map<ID, Decimal>();
        for(Account acc : accRecords)
        {
           // if(acc != null){
            mapAcc.put(acc.Id, acc.NumberofLocations__c);
            system.debug('mapAcc== '+mapAcc);
            system.debug('mapAccsize== '+mapAcc.size() );
            //}
        }
        if(mapAcc.size()>0 && mapAcc != null)
        {
          system.debug('58==');  
            for(ID accid:mapAcc.keySet())
            {
                for(Integer i = 0; i<mapAcc.get(accId); i++)
                {
                    Contact newCon = new Contact();
                    newCon.LastName = 'Irshad Ansari'+i;
                    conlist.add(newCon);  
                    
                    system.debug('LastName== '+newCon.LastName);
                    system.debug('conlist== '+conlist);
                }
            }
        }
        if(conlist.size()>0 && conlist != null)
        {
            system.debug('conlistconlist== '+conlist);
            try{
            insert conlist;
            }
            catch(Exception e)
            {
                System.debug(e);
            }
        }
    }
    //Validate the deletion of account if there is any Opportunity record exist for the account
   /* public static void validateOpportunityWithAccount(List<Account> aclist)
    {
        Set<Id> accId = new Set<Id>();
        for(Account a:aclist)
        {
            accId.add(a.Id);
        }
        List<Opportunity> oplist = [Select id, Name,Amount from Opportunity where AccountId In :accId];
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for(Opportunity o:oplist)
        {
            oppMap.put(o.AccountId, o);
        }
        for(Account ac:aclist)
        {
            if(oppMap.containsKey(ac.Id))
            {
                ac.addError('account has realted Opportunity so can not delete the opportunity');
            }
        }
    }*/
    Public static void validateAccountContact(Map<Id, Account> oldMap)
    {
        List<Contact> cList = [Select Id,AccountId, Name from Contact where AccountId in: oldMap.keySet()];
        Map<Id, Contact> cmap = new Map<Id, Contact>();
        for(Contact c:clist)
        {
            cmap.put(c.AccountId, c);
        }
        System.debug('Contact map size '+cmap.size());
        for(Id a:oldMap.keySet())
        {
            Account acold = oldMap.get(a);
             if(cmap.containsKey(acold.Id))
            {
                acold.addError('You can not delete the account as it has a Associated contact');
            }
        
            
        }
           
    }
    // Check duplicate account creation  and update method trigger method/ correct Implemented
    public static void duplicacyAccountCheck(Boolean isInsert ,Boolean isUpdate, List<Account> acclist)
    {
     Set<String> accountName = new Set<String>();
        for(Account a:acclist)
        {
            accountName.add(a.Name);
        }
        System.debug('Account List name---'+accountName);
        Map<String, Account> existingAccounts=new Map<String , Account>();
        for(Account acc : [SELECT Id, Name FROM Account WHERE Name IN :accountName]) 
        {
            existingAccounts.put(acc.Name, acc);
        }
        //System.debug('Size of the map' +acc.size());
            for(Account a:accList)
            {
                if(existingAccounts.containsKey(a.Name))
                {
                   a.addError('Account already exist with this name');
                }
            }    
    }
    //Write a trigger on Account, when an account is inserted, automatically account billing address
    // should populate into the account shipping address.//Correct Implemented
   public static void billingAddressToShippingAddress(Boolean isInsert ,Boolean isUpdate, List<Account> accList)
   {
       for(Account a:accList)
       {
           if(a.BillingState != Null)
           {
             a.ShippingState =a.BillingState;  
           }
           if(a.BillingCountry != null)
           {
               a.ShippingCountry = a.BillingCountry;
           }
           if(a.BillingCity != null)
           {
               a.ShippingCity =a.BillingCity;
           }
           if(a.BillingStreet != null)
           {
               a.ShippingStreet = a.BillingStreet;
           }
           if(a.BillingPostalCode != null)
           {
               a.ShippingPostalCode = a.BillingPostalCode;
           }        
       }
   }
    //code for checking Custom Exception.
   Public static void checkCustomException()
   {
      Integer a=5;
       Boolean istrue=true;
      Integer b;
       Integer Sum=0;
       try{
          //sum=a+b;
          if(isTrue)
          {
            throw new CustomException('This is custom Exception');  
          }
         // System.debug('Sum fo the a and b'+ sum);
          //throw new CustomException('This is custom Exception');
       } 
       catch(CustomException e)
       {
           System.debug('Handled Custom Exception Executing');
       }
       catch(Exception e)
       {
           System.debug('Caught generic exception Executing'+e.getMessage());
       }           
   }
    
   //Whenever any account is updated or created then fetched all the contact which mateches Accountid
   // and update  contact phone number as account phone number
   //where lastname as account name.
   public static void upadteContactPhoneNumber(boolean isInsert , Boolean isUpdate, list<Account> accounts)
   {
       List<Contact> conList = queryContact(RecordHelper.extractIds(accounts)); 
       List<Contact> updatedContact =new List<Contact>();
       for(Account a:accounts)
       {
           for(Contact c:conList)
           {
              
               If(c.lastname == a.name)
               {
                   c.Phone =a.Phone;
                   updatedContact.add(c);
               }
           }
       }
       if(!updatedContact.isEmpty())
       {
           update updatedContact;
       }
   }
    public static List<Contact> queryContact(List<Id> ids)
    {
        Return [select Id, lastName,Phone from Contact where accountId In:ids];
    }
    
    //Upon Account Creation If industry is not null and Having value as Insurance then Set rating As Hot
      public static void checkIndustryFieldAndSetRating( Boolean isInsert, List<Account> accounts)
      {
          List<Account> filterAccount =(List<Account>)RecordHelper.getObjectsWithNotNull(accounts ,'Industry');
          for(Account a:filterAccount)
          { 
              if(a.Industry =='Insurance')
              {
                  a.Rating ='Hot';
              }
              
          }
      }
   /* //Checking the Phone is valid or not
    Public static void checkPhoneIsValid(Boolean isInsert,List<Account> newEntries)
    {
        if(isInsert)
        {
        LIst<String> phoneNumberList= new List<String>(); 
        List<Account> updateToAccount = new List<Account>();
        if(!newEntries.isEmpty())
        {
            for(Account a:newEntries)
            {
                if(a.Phone !=null && a.Phone != '')
                {
                 phoneNumberList.add(a.Phone);   
                }
            }
   
        }
            if(!phoneNumberList.isEmpty()) {    
        System.debug('phoneNumberList'+phoneNumberList);
        List<String> returnResponse=VeriphoneApi.invokePhoneAPI(phoneNumberList);
        System.debug('returnResponse'+returnResponse);

        for(Account a:newEntries)
            {
                for(String s:returnResponse)
                {
                    a.PhoneNumberisValid__c =Boolean.valueof(s);
                }
                updateToAccount.add(a);
            }
        if(!updateToAccount.isEmpty()){
           update  updateToAccount;
        }
            }else{
                System.debug('No phone numbers to validate');
            }         
      }      
    }//*/
    
     public static void checkPhoneIsValid(Boolean isInsert, List<Account> newEntries) {
        if (isInsert) {
            Set<Id> accountIds = new Set<Id>();
            List<String> phoneNumberList = new List<String>();

            for (Account acc : newEntries) {
                if (acc.Phone != null && acc.Phone != '') {
                    accountIds.add(acc.Id);
                    phoneNumberList.add(acc.Phone);
                }
            }
            System.debug('accountIds'+accountIds);
            System.debug('phoneNumberList'+phoneNumberList);

            // Call the future method to validate phone numbers asynchronously
            if (!phoneNumberList.isEmpty()) {
                VeriphoneApi.validatePhoneFuture(accountIds, phoneNumberList);
            }
        }
    }
    
    //Sent Account to Another Org when Phone account isAcitve become yes
    Public static void sentAccountToTrailHeadOrg(List<Account> newAccounts,Map<Id,Account> oldAccountMap){
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : newAccounts){
            if(acc.Active__c =='Yes' && acc.Active__c !=oldAccountMap.get(acc.id).Active__c){
                accountIds.add(acc.Id);
            }
        }
        List<InterfaceServiceRequest__c> interfaceReq =[Select Id from InterfaceServiceRequest__c where Name ='Account-Post'];
        if(interfaceReq.isEmpty() || accountIds.isEmpty()) return;
        List<JobQueue__c> queueRecords = new List<JobQueue__c>();
          for(Id  accId: accountIds){
               queueRecords.add(new JobQueue__c(InterfaceRecordId__c =accId,QueueType__c='Queue',InterfaceServiceRequestId__c=interfaceReq[0].Id));
          }
          if(!queueRecords.isEmpty())
            insert queueRecords;
    }
}