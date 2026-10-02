public with sharing class PostOfficeApi {
    public PostOfficeApi() {

    }
    @AuraEnabled(cacheable=true)
    public static List<PostalResponseWrapper> postofficeApiByPincode(String pincode)
    {
        List<PostalResponseWrapper> postalList =new List<PostalResponseWrapper>();
        String endpoint ='https://api.postalpincode.in/pincode/';
        if(pincode !=null || pincode !='')
        {
            endpoint+=pincode;
        }
        Http h = new Http();
        // Endpoin,method,header set
        HttpRequest req= new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        //Invoke rest call
        HttpResponse res = h.send(req);
        //if the response success 200
        if(res.getStatusCode()==200)
        {
            JSONParser parser = JSON.createParser(res.getBody());
            parser.nextToken();
            while(parser.nextToken()!=null)
            {
              if(parser.getCurrentToken()==JSONToken.START_ARRAY)
              {
                while(parser.nextToken()!=null)
                {
                    if(parser.getCurrentToken()==JSONToken.START_OBJECT)
                    {
                        PostalResponseWrapper eachPostal =(PostalResponseWrapper)parser.readValueAs(PostalResponseWrapper.class);
                        eachPostal.PINCODE=pincode;
                        postalList.add(eachPostal);
                    }
                }
              }
            }
        }
        return postalList;
    }
    //Postal api serch by branchname
    @AuraEnabled(cacheable=true)
    public static List<PostalResponseWrapper> postofficeApiByBranchName(String branchName)
    {
        List<PostalResponseWrapper> postalList =new List<PostalResponseWrapper>();
        String endpoint ='https://api.postalpincode.in/postoffice/';
        if(branchName !=null || branchName !='')
        {
            endpoint+=branchName;
        }
        Http h = new Http();
        // Endpoin,method,header set
        HttpRequest req= new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        //Invoke rest call
        HttpResponse res = h.send(req);
        //if the response success 200
        if(res.getStatusCode()==200)
        {
            JSONParser parser = JSON.createParser(res.getBody());
            parser.nextToken();
            while(parser.nextToken()!=null)
            {
              if(parser.getCurrentToken()==JSONToken.START_ARRAY)
              {
                while(parser.nextToken()!=null)
                {
                    if(parser.getCurrentToken()==JSONToken.START_OBJECT)
                    {
                        PostalResponseWrapper eachPostal =(PostalResponseWrapper)parser.readValueAs(PostalResponseWrapper.class);
                        postalList.add(eachPostal);
                    }
                }
              }
            }
        }
        return postalList;
    }
    //Wrapeer class
    public class PostalResponseWrapper{
        @AuraEnabled public String Name;
        @AuraEnabled public String PINCODE;
        @AuraEnabled public String Description;
        @AuraEnabled public String BranchType;
        @AuraEnabled public String DeliveryStatus;
        @AuraEnabled public String Circle;
        @AuraEnabled public String District;
        @AuraEnabled public String Division;
        @AuraEnabled public String Region;
        @AuraEnabled public String State;
        @AuraEnabled public String Country;
    }
}