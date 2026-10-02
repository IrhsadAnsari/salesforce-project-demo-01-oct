trigger BatchApexErrorEventSubscirber on BatchApexErrorEvent (after insert) {
   List<Task> taskList = new List<Task>();
    for(BatchApexErrorEvent event : Trigger.new){
        Id jobId = event.AsyncApexJobId;
        String exceptionType = event.ExceptionType;
        String errorMessage = event.Message;
        String stackTrace = event.StackTrace;
        String scope = event.JobScope;
        
        taskList.add(new Task(Subject = 'Batch Job Failure Detected '+exceptionType,
                             Description = 'Job Id '+jobId+'\n'+'Message'+errorMessage +'\n'+'StackTrace '+stackTrace+'\nJobScope '+scope,
                    Status ='In Progress',
                    Priority ='High')
                     );
    }
    if(!taskList.isEmpty()) insert taskList;
}