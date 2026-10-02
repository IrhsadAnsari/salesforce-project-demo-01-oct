public class LeadHelper {
   public static void checkLeadWithContactEmail(boolean isInsert,Boolean isUpdate, List<Lead> leads)
   {
      
       List<Contact> conList = queryContact(RecordHelper.extractValues(leads ,'Email'));
       for(Lead l:leads)
       {
           For(Contact c:conList)
           {
               if(c.Email == l.Email)
               {
                   l.EMail.addError('Contact with this Email already exist in the System.');
               }
           }
       }
   }
    
    public static List<Contact> queryContact(List<String> emails)
    {
        return [Select Id, Email,LastName from Contact where Email in:emails];
    }
}