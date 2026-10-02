public class JobQueueHandler {
    public static void createQueue(List<JobQueue__c> newRecords){
        System.debug('Inside QueueHandler');
        System.enqueueJob(new JobQueueQueueable(newRecords));
    }
}