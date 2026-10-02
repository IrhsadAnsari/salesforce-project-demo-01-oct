@isTest
Private class My_AccountHandlerTestClass {
    @isTest
  static void validateContactWithAssociatedAccount()
  {
      List<Account> accountList = new List<Account>();
      Account acc= new Account();
          acc.Name='Test Account';
          acc.Account_Creation_date__c=date.today();
      System.debug('Account has successfully created. '+acc);   
 Test.startTest();
 // Insert Account
      accountList.add(acc);
       insert accountList;

 System.debug('accc---->'+acc);
 Test.stopTest();
      
      System.debug('Testing stop--Associated account');
 //My_AccountHandler.accountToAssociatedContact(accountList);
      
      // Retrieve the Contact
     Set<id> accountId = new Set<Id>();
      For(Account a:accountList)
      {
          accountId.add(a.Id);
      }

  
 Contact con= [SELECT firstName,lastName,Id FROM Contact WHERE AccountId=:acc.Id limit 1];
 System.debug('Accoutn after trigger fired: ' + acc);
      System.debug('Contact has been Created :'+con);
 
 // Test that the trigger correctly created Contact with same name of account
 System.assertEquals('Irshad', con.firstName);
 System.assertEquals('Ansari', con.LastName);
 System.debug('Testing stop--Associated account');

         
  }
}