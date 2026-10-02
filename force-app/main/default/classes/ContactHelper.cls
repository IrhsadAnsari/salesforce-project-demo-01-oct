public class ContactHelper {
  //Checking contact is having any account or not if not then create account.
  public static void createAccount(Boolean isInsert, List<Contact> conList )
  {
     List<Account> acclist = new List<Account>();
      for(Contact con:conList)
      {
          if(con.AccountId ==null)
          {
          
              Account a = new Account();
              a.Name = con.LastName;
              a.Account_Creation_date__c=System.today();
              acclist.add(a);
          }
      }
      if(acclist.size()>0)
          insert acclist;    
  }
    //Phone and email validation on contact creation.
    Public static void contactValidation(Boolean isInsert, List<Contact> conList)
    {
        For(Contact c:conList)
        {
            if(c.Phone==Null || c.Phone =='')
            {
                c.addError('Please Enter phone number');
            }
            if(c.Email==Null || c.Email =='')
            {
                c.addError('Please Enter Email');
            }
        }
    }
    //Validate account Selcation on contact creation.
    Public static void validateAccountSelection(Boolean isInsert, List<Contact> conList)
    {
        For(Contact c:conList)
        {
            if(c.AccountId ==null)
            {
                c.AccountId.addError('Please select account for the Contact');
            }
        }
    }
}