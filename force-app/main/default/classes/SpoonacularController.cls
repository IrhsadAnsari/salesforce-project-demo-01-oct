public class SpoonacularController {
    public static void getRecipe(){
           Spoonacilar_API__mdt	 spoon=[Select Id, API_key__c, Endpoint_API__c from Spoonacilar_API__mdt where DeveloperName='Spoonacular_Data'];
          HttpRequest req =new HttpRequest();
        String endpoint = spoon.Endpoint_API__c+'?ingredients=apple';
          req.setEndpoint(endpoint);
        req.setHeader('x-api-key',spoon.API_key__c);
        req.setMethod('GET');
        
        Http ht= new Http();
        HttpResponse res=ht.send(req);
        if(res.getStatusCode()==200){
            System.debug('=== data==>'+res.getBody());
        }
    }
}