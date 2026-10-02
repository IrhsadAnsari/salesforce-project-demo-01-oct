public with sharing class ContactHandler {
    public ContactHandler() {

    }
    //Popolate number of contact realted to the Account on Contact updattion
    public static void returnNumberOfContactOnParent(Boolean IsUpdate,List<Contact> newContact)
    {
        if(IsUpdate)
        {
        Map<Id,Contact> accToContactMap =new Map<Id,Contact>();
        Map<Id,List<Contact>> accToContactNewMap =new Map<Id,List<Contact>>();

        if(newContact.size() > 0)
        {
            for(Contact con : newContact)
            {
                    accToContactMap.put(con.AccountId, con);               
            }
        }
        List<Account> accList = [Select Id, NumberOfContact__c from Account where Id IN: accToContactMap.keYSet() ];
        List<Contact> allContactwithAccountId = [Select Id, Name, AccountId From Contact where AccountId In :accToContactMap.keySet()];
      For(Contact cont : allContactwithAccountId)
      {
        if(accToContactNewMap.containsKey(cont.AccountId))
        {
            accToContactNewMap.get(cont.AccountId).add(cont); 
        }
        else{
            accToContactNewMap.put(cont.AccountId , New List<Contact>{cont});
        }
      }

      For(Account acc : accList)
       {
        if(acc.id !=null && accToContactNewMap.get(acc.id) !=null)
         {
            acc.NumberOfContact__c = accToContactNewMap.get(acc.id).size();
         }
       }
       update accList;
    }
    }
//Write a trigger to on contact creation to check email field will be unique accross the Organisation
Public Static void checkContactEmail(Boolean isInsert,Boolean isUpdate, List<Contact> newContact)
{
    if(isInsert || isUpdate)
    {
    Map<Id, String> contactWithEmailMap = new Map<Id, String>();
    for(Contact con : newContact)
    {
        contactWithEmailMap.put(con.Id, con.Email);
    }
    List<Contact> existingContact = [Select id, Email,Name from Contact where Email In:contactWithEmailMap.values()];
    for(Contact newCon : newContact)
    {
       /* for(Contact newCon: newContact)
        {
            if(newCon.Email !=null && existcon.Email.equalsIgnoreCase(newCon.Email))
        {
            newCon.addError('You can not create contact with same Email.') ;
        } 
        }
       */ 
      if(newCon.Email !=null && contactWithEmailMap.get(newCon.id).equalsIgnoreCase(newCon.Email))
        {
            if(isUpdate){
                newCon.addError('You can not update contact with same Email.') ;
            }
            if(isInsert){
                newCon.addError('You can not Create contact with same Email.') ;
            }
        } 
    }
   }
}

}