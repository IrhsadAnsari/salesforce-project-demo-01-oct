trigger JobQueueTrigger on JobQueue__c (before insert,after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('Job Queue Start in Trigger');
        JobQueueHandler.createQueue(Trigger.new);
        System.debug('Job Queue out from Trigger');
    }
}