public class JobQueueQueueable implements Queueable,Database.AllowsCallouts {
    private List<JobQueue__c> jobQueueRecords;
    public JobQueueQueueable(List<JobQueue__c> queueRecords){
        this.jobQueueRecords = queueRecords;
    }
    
    public void execute(QueueableContext qc){
        System.debug('Inside start of Execute method');
        for(JobQueue__c queue : jobQueueRecords){
            if(queue != null){
               // callInterface(queue); 
               IntegrationConsume.calloutCustomApi4(queue);
            }
        }
    }
    public static void callInterface(JobQueue__c queue){
        Http http= new Http();
        HttpRequest req= new HttpRequest();
        req.setEndpoint('callout:'+queue.NamedCredentialWithPoint__c);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        if(res.getStatusCode() >= 200 && res.getStatusCode() <= 300)
        {
            System.debug('StatusCode:'+res.getStatusCode());
            System.debug('Status'+res.getStatus());
        }
        else{
            queue.Retry_Count__c= queue.Retry_Count__c+1;
            update queue;
        }
       System.debug('Response from Server'+res.getBody());              
    }
}