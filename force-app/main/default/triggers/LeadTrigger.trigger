trigger LeadTrigger on Lead (before insert,before update) {
    if(trigger.isBefore)
    {
        System.debug('before trigger is excuting');
         LeadHelper.checkLeadWithContactEmail(Trigger.isInsert ,Trigger.isUpdate, Trigger.new);
        
    }
   if(trigger.isAfter)
   {
       System.debug('After trigger is excuting');
   }
}