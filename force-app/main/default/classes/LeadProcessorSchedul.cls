Global class LeadProcessorSchedul Implements Schedulable {
    
    global void execute(SchedulableContext sc)
    {
        List<Lead> leads= [Select Id, Name,Status,Company from Lead];
        System.debug('Size of the leads' +leads.size());
        For(Lead l:leads)
        {
            if(l.status ==null  )
            {
              l.Status ='Working - Contacted';  
            }
        }
       if(!leads.isEmpty())
       {
           update leads;
       }
    }
}