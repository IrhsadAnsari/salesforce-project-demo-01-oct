public class LogExceptionHelper {
    public static void logError(Exception e){
        List<ErrorLog__c> logs = new List<ErrorLog__c>();
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        logs.add(new ErrorLog__c(
        Message__c =e.getMessage(),
        Type__c= Exception.class.getName(),
        UseId__c = UserInfo.getUserId(),
        StackTrace__c = e.getStackTraceString(),    
        ClassName__c  = stackTrace.substringAfter('.').substringBefore('.'),
        MethodName__c = stackTrace.substringBefore(':').substringAfter(stackTrace.substringAfter('.').substringBefore('.')).substringAfter('.'),
        QueryLimit__c = Limits.getQueries()+'/' +Limits.getLimitQueries(),
        QueryRecordLimit__c = Limits.getQueryRows() +'/'+Limits.getLimitQueryRows(),    
        DMLLimit__c =  Limits.getDmlRows() + '/' + Limits.getLimitDmlRows(),
        DMLStat__c =  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements(),  
        CPUTime__c =  Limits.getCpuTime() + '/' + Limits.getLimitCpuTime()    
        ));
        if(!logs.isEmpty())
          insert logs;
    }
    
    ////Written for Publish Platform Event
    public static void logExceptionError(Exception e){
       ErrorLogEvent__e log = new ErrorLogEvent__e();
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        log.Message__c =e.getMessage();
        log.Type__c= Exception.class.getName();
        log.UserId__c = UserInfo.getUserId();
        log.StackTrace__c = e.getStackTraceString();  
        log.ClassName__c  = stackTrace.substringAfter('.').substringBefore('.');
        log.MethodName__c = stackTrace.substringBefore(':').substringAfter(stackTrace.substringAfter('.').substringBefore('.')).substringAfter('.');
        log.QueryLimit__c = Limits.getQueries()+'/' +Limits.getLimitQueries();
        //log.QueryRecordLimit__c = Limits.getQueryRows() +'/'+Limits.getLimitQueryRows();
        log.DMLLimit__c =  Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
        log.DMLStat__c =  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();
        log.CPUTime__c =  Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();    
        if(log !=null){
            EventBus.publish(log);
        }
          
    }
    
    //This method for Subscribe:
    public static void logErrorProcess(List<ErrorLogEvent__e> newLogs){
        List<ErrorLog__c> logs = new List<ErrorLog__c>();
        for(ErrorLogEvent__e log : newLogs){
                logs.add(new ErrorLog__c(
                Message__c =log.Message__c,
                Type__c= log.Type__c,
                UseId__c = log.UserId__c,
                StackTrace__c = log.StackTrace__c,    
                ClassName__c  = log.ClassName__c,
                MethodName__c = log.MethodName__c,
                QueryLimit__c = log.QueryLimit__c,
                DMLLimit__c =  log.DMLLimit__c,
                DMLStat__c =  log.DMLStat__c,
                CPUTime__c =  log.CPUTime__c ,       
                Replay_ID__c =String.valueOf(log.ReplayID) 
                ));
        }
                if(!logs.isEmpty())
                  insert logs;
       }
}