public class IntegrationConsume {
    public static void callout(){
          Http http =new Http();
          HttpRequest req = new HttpRequest();
          req.setEndpoint('callout:Named_Cred_SF_to_SF/services/apexrest/getAccountData');
          req.setMethod('GET');
          HttpResponse res =http.send(req);
          System.debug('Response form server '+res.getStatusCode());
    If(res.getStatusCode()==200)
    {
        System.debug('Record fetched from the target Org: '+res.getBody());
    }
        
 
    }

    public static void calloutCustomApi(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Account acc = [Select Name,Phone from Account Limit 1];
        Map<String, Object> requestBody = new Map<String, Object>{
                                                    'Name' => acc.Name,
                                                     'Phone' => acc.Phone
                                                        };
        req.setEndpoint('callout:TrailheadMindfulNamedCred/services/apexrest/accounts');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(requestBody));
        HttpResponse res = http.send(req);
        if(res.getStatusCode() == 201){
           System.debug('Response from Server'+res.getBody());
        }
        
    }
    
      public static void calloutCustomApi2(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        InterfaceServiceRequest__c interfaceRequest =[Select Id, Name,HttpMethod__c ,PayloadSchema__c,Request_SOQL__c,NamedCredential__c from InterfaceServiceRequest__c
                                                     where Name='Account-Post' Limit 1];
          
        //Account acc = [Select Name,Phone from Account Limit 1];
        /*Map<String, Object> requestBody = new Map<String, Object>{
                                                    'Name' => acc.Name,
                                                        'Phone' => acc.Phone};*/
          if(interfaceRequest != null)  {                                              
        req.setEndpoint('callout:'+interfaceRequest.NamedCredential__c+'/services/apexrest/accounts');
        req.setMethod(interfaceRequest.HttpMethod__c);
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(interfaceRequest.PayloadSchema__c));
        HttpResponse res = http.send(req);
        if(res.getStatusCode() == 201){
           System.debug('Response from Server'+res.getBody());
         }
        }
        
      }    
         ///
    public static void calloutCustomApi3(Id recordId) {

        // -----------------------------------------
        // 1. Get Integration Configuration
        // -----------------------------------------

        InterfaceServiceRequest__c interfaceRequest = [
            SELECT Id,
                   Name,
                   HttpMethod__c,
                   PayloadSchema__c,
                   Request_SOQL__c,
                   NamedCredential__c
            FROM InterfaceServiceRequest__c
            WHERE Name = 'Account-Post'
            LIMIT 1
        ];


        if (interfaceRequest == null) {
            throw new IntegrationException(
                'Interface Service Request configuration not found.'
            );
        }


        // -----------------------------------------
        // 2. Execute Dynamic Request SOQL
        // -----------------------------------------

        List<SObject> records =
            DynamicRequestQueryService.executeRequestSOQL(
                interfaceRequest.Request_SOQL__c,
                recordId
            );


        if (records.isEmpty()) {
            throw new IntegrationException(
                'No record found for Id: ' + recordId
            );
        }


        // We expect one record because the query
        // contains WHERE Id = :recordId
        SObject record = records[0];


        // -----------------------------------------
        // 3. Build Payload
        // -----------------------------------------

        String payload =
            buildPayload(
                interfaceRequest.PayloadSchema__c,
                record
            );


        // -----------------------------------------
        // 4. Create HTTP Request
        // -----------------------------------------

        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:' +interfaceRequest.NamedCredential__c + '/services/apexrest/accounts');

        req.setMethod(
            interfaceRequest.HttpMethod__c
        );

        req.setHeader(
            'Content-Type',
            'application/json'
        );

        req.setBody(payload);


        // -----------------------------------------
        // 5. Send Callout
        // -----------------------------------------

        Http http = new Http();

        HttpResponse response = http.send(req);


        // -----------------------------------------
        // 6. Handle Response
        // -----------------------------------------

        System.debug(
            'Status Code: ' +
            response.getStatusCode()
        );

        System.debug(
            'Response Body: ' +
            response.getBody()
        );


        if (
            response.getStatusCode() >= 200 &&
            response.getStatusCode() < 300
        ) {

            System.debug(
                'Integration successful.'
            );

        } else {

            throw new IntegrationException(
                'Integration failed. ' +
                'Status Code: ' +
                response.getStatusCode() +
                ', Response: ' +
                response.getBody()
            );
        }
    }


    // -----------------------------------------
    // Payload Builder
    // -----------------------------------------

    private static String buildPayload(
        String payloadTemplate,
        SObject record
    ) {

        if (String.isBlank(payloadTemplate)) {
            throw new IntegrationException(
                'Payload Schema is not configured.'
            );
        }


        String payload = payloadTemplate;


        /*
         * Example:
         *
         * {
         *     "Name": "{!Name}",
         *     "Phone": "{!Phone}"
         * }
         *
         */


        Pattern pattern =
            Pattern.compile(
                '\\{!([a-zA-Z0-9_]+)\\}'
            );

        Matcher matcher =
            pattern.matcher(payload);


        Set<String> fields =
            new Set<String>();


        while (matcher.find()) {

            String fieldName =
                matcher.group(1);

            fields.add(fieldName);
        }


        // Replace each {!FieldName}
        for (String fieldName : fields) {

            Object fieldValue =
                record.get(fieldName);


            String value =
                fieldValue == null
                ? ''
                : String.valueOf(fieldValue);


            payload = payload.replace(
                '{!' + fieldName + '}',
                value
            );
        }


        return payload;
    }
  

    public class IntegrationException extends Exception {
    }
    
 ///////   
    public static void calloutCustomApi4(JobQueue__c queue) {
        if(queue == null) return;

        // -----------------------------------------
        // 1. Get Integration Configuration
        // -----------------------------------------
       
        InterfaceServiceRequest__c interfaceRequest = [
            SELECT Id,
                   Name,
                   HttpMethod__c,
                   PayloadSchema__c,
                   Request_SOQL__c,
                   NamedCredential__c
            FROM InterfaceServiceRequest__c
            WHERE Id =:queue.InterfaceServiceRequestId__c
            LIMIT 1
        ];


        if (interfaceRequest == null) {
            throw new IntegrationException(
                'Interface Service Request configuration not found.'
            );
        }


        // -----------------------------------------
        // 2. Execute Dynamic Request SOQL
        // -----------------------------------------

        List<SObject> records =
            DynamicRequestQueryService.executeRequestSOQL(
                interfaceRequest.Request_SOQL__c,
                queue.InterfaceRecordId__c
            );


        if (records.isEmpty()) {
            throw new IntegrationException(
                'No record found for Id: ' + queue.InterfaceRecordId__c
            );
        }


        // We expect one record because the query
        // contains WHERE Id = :recordId
        SObject record = records[0];


        // -----------------------------------------
        // 3. Build Payload
        // -----------------------------------------

        String payload =
            buildPayload(
                interfaceRequest.PayloadSchema__c,
                record
            );


        // -----------------------------------------
        // 4. Create HTTP Request
        // -----------------------------------------

        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:' +interfaceRequest.NamedCredential__c + '/services/apexrest/accounts');

        req.setMethod(
            interfaceRequest.HttpMethod__c
        );

        req.setHeader(
            'Content-Type',
            'application/json'
        );

        req.setBody(payload);


        // -----------------------------------------
        // 5. Send Callout
        // -----------------------------------------

        Http http = new Http();

        HttpResponse response = http.send(req);


        // -----------------------------------------
        // 6. Handle Response
        // -----------------------------------------

        System.debug(
            'Status Code: ' +
            response.getStatusCode()
        );

        System.debug(
            'Response Body: ' +
            response.getBody()
        );


        if (
            response.getStatusCode() >= 200 &&
            response.getStatusCode() < 300
        ) {

            System.debug(
                'Integration successful.'
            );

        } else {

            throw new IntegrationException(
                'Integration failed. ' +
                'Status Code: ' +
                response.getStatusCode() +
                ', Response: ' +
                response.getBody()
            );
        }
    }
}