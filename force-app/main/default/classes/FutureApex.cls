public class FutureApex {
    
    @future(callout=true)
    public static void futureCallout(List<Id> accId)
    {
        if(accId.size()>0){
            for(Account acc: [Select Id,Name,phone from Account where ID IN : accID])
            {
                Http http =new Http();
                HttpRequest req= new HttpRequest();
                    req.setMethod('GET');
                    req.setEndpoint('callout:Named_Cred_SF_to_SF/services/apexrest/getAccountData?phoneNo='+acc.Phone);
                HttpResponse res =http.send(req);
          System.debug('Response form server1 '+res.getStatusCode());
    If(res.getStatusCode()==200)
    {
        System.debug('Success: '+res.getBody());
    }
 
            }
        }
    }
     @future(callout=true)
    public static void futureCallout2(List<Id> accId)
    {
        if(accId.size()>0){
            for(Account acc: [Select Id,Name,phone from Account where ID IN : accID])
            {
                Http http =new Http();
                HttpRequest req= new HttpRequest();
                    req.setMethod('POST');
                    req.setEndpoint('callout:Named_Cred_SF_to_SF/services/apexrest/getAccountData?accID='+acc.Id+'&Phone='+acc.Phone);
                HttpResponse res =http.send(req);
          System.debug('Response form server2 '+res.getStatusCode());
    If(res.getStatusCode()==200)
    {
        System.debug('Success: '+res.getBody());
    }
 
            }
        }
    }

}