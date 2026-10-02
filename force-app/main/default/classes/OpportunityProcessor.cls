public class OpportunityProcessor implements Database.Batchable<sObject>, Schedulable, Database.RaisesPlatformEvents{
   public Integer processRecord = 0;
    public DataBase.QueryLocator start(Database.BatchableContext bc)
    {
        return DataBase.getQueryLocator([Select Id,AccountId, LeadSource from Opportunity]);
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> oppList)
    {
        for(Opportunity o:oppList)
        {
          //o.LeadSource = 'Manufacturing'; 
          if(o.AccountId == null)
                      throw new NullPointerException();

        }
        //update oppList;
       // processRecord +=oppList.size();
        //System.debug('Batch Job Id :'+bc.getJobId());
       
      
    }
    public void finish(Database.BatchableContext bc)
    {
        System.debug('All the Batch executed successfully and recored processed is: '+processRecord);
    }
    public void execute(SchedulableContext sc)
    {
       OpportunityProcessor opl =new OpportunityProcessor();
       Database.executeBatch(opl,10);       
    }
}