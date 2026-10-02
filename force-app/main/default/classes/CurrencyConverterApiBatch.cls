global class CurrencyConverterApiBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query ='Select id,Amount,Amount_INR_value__c from Opportunity where StageName=\'Closed won\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<Opportunity> oppList)
    {
       // List<Opportunity> opplist =[Select id,Amount,Amount_INR_value__c from Opportunity where StageName='Closed won'];
        System.debug('List of Opportunity--->'+opplist);
        string endpoint ='https://api.currencylayer.com/live?access_key=2fffc101163135abeefa46a701614a91&currencies=INR&source=USD&format=1';
        Http hp=new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response =hp.send(request);
        String jsonString;
        Decimal amt;
        if(response.getStatusCode()==200)
        {
            System.debug('Status'+response.getStatus());
            jsonString=response.getBody();
            System.debug('Json Response--->'+jsonString);
        }
        System.JSONParser jp=JSON.createParser(jsonString);
        While(jp.nextToken()!=null)
        {
            if(jp.getText()=='USDINR')
            {
                jp.nextToken();
                amt=(Decimal)jp.getDecimalValue();
            }
        }
        for(Opportunity op:opplist)
        {
            if(op.Amount !=null)
            {
              op.Amount_INR_value__c = 'Rs. '+(amt*op.Amount);
            }
        }
        update opplist;
    }
    global void finish(Database.BatchableContext bc)
    {
        
    }

}