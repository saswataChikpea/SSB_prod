public with sharing class JiraAuthorize {
    public String response1{get;set;}
    public String token1{get;set;}
    public String code1{get;set;}
    public String cloudId{get;set;}
    public JiraAuthorize(){
        this.code1 = ApexPages.currentPage().getParameters().get('code');
        System.debug(code1);
        if(this.code1 != null && this.code1 != ''){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://auth.atlassian.com/oauth/token');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody('{"grant_type": "authorization_code", "client_id": "eyPPCS52PMbNwqltWLQJjhn67st8PNFR","client_secret": "0Uey3FbqAGGCOorqVWYC9ntuj37hIIYxt1nhMYbMsl6EC70-yPwvDTUJyMsbv1pD", "code": "'+code1+'", "redirect_uri": "https://efficiency-enterprise-2066-dev-ed--c.vf.force.com/apex/JiraAuthorize"}');

            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.

            System.debug('#******************************response='+response);
            //this.token1 = String.valueOf(response);
            if(response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('results:'+results);
                this.token1 = (String)results.get('access_token');
            }
        }
    }
    public PageReference doAuthorizationJira(){
        Integer STRING_LENGTH = 8;
        Decimal MIN = Math.pow(10,STRING_LENGTH -1); //Returns 100
        Decimal MAX = Math.pow(10,STRING_LENGTH) - 1; // Returns 999
        String state = String.valueOf(Math.Round(Math.Random() * (MAX-MIN) + MIN));
        String authorization_endpoint = 'https://auth.atlassian.com/authorize?audience=api.atlassian.com'+
        '&client_id=eyPPCS52PMbNwqltWLQJjhn67st8PNFR&'+
        'scope=read%3Ajira-work%20manage%3Ajira-project%20manage%3Ajira-configuration%20read%3Ajira-user%20write%3Ajira-work%20manage%3Ajira-data-provide%20offline_access&'+
        'redirect_uri=https://efficiency-enterprise-2066-dev-ed--c.vf.force.com/apex/JiraAuthorize&state='+state+'&response_type=code&prompt=consent';
    
        //String scope = 'com.intuit.quickbooks.accounting';
        //String final_EndPoint = authorization_endpoint+'?client_id='+client_Id+'&response_type=code&scope='+
        //scope+'&state='+state+'&redirect_uri='+redirect_URI;
        System.debug('final_EndPoint : '+authorization_endpoint);
        PageReference pageRef = new PageReference(authorization_endpoint);
        System.debug('pageRef===>>'+pageRef);
        return pageRef;
    }
    public PageReference getClouldId(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.atlassian.com/oauth/token/accessible-resources');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+this.token1);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept' , 'application/json');

        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        System.debug('#******************************response='+response);
        this.response1 = String.valueOf(response);
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            System.debug('results:'+response.getBody());
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> result1 = (Map<String, Object>) results[0];
            this.cloudId = (String)result1.get('id');
        }
        return null;
    }
    public Pagereference getTicket(){
        //https://api.atlassian.com/ex/jira/
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.atlassian.com/ex/jira/'+cloudId+'/rest/api/3/issue/SS-3');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+this.token1);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept' , 'application/json');

        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        System.debug('#******************************response='+response);
        this.response1 = String.valueOf(response);
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            System.debug('results:'+response.getBody());
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            this.response1 = results.toString();
            
        }
        return null;
    }

    public void getJiraClouldId(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:jira_cloud_id/oauth/token/accessible-resources');
        request.setMethod('GET');
        //request.setHeader('Authorization', 'Bearer '+this.token1);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept' , 'application/json');

        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        System.debug('#******************************response='+response);
        this.response1 = String.valueOf(response);
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            System.debug('results:'+response.getBody());
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> result1 = (Map<String, Object>) results[0];
            this.cloudId = (String)result1.get('id');
        }
    }
    public void getJiraTicket(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:jira_cloud_id/ex/jira/'+cloudId+'/rest/api/3/issue/SP-1');
        request.setMethod('GET');
        //request.setHeader('Authorization', 'Bearer '+this.token1);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept' , 'application/json');

        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        System.debug('#******************************response='+response);
        this.response1 = String.valueOf(response);
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            System.debug('results:'+response.getBody());
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            this.response1 = results.toString();
            
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Object> getJiraClouldIdLWC(){
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:jira_cloud_id/oauth/token/accessible-resources');
            request.setMethod('GET');
            //request.setHeader('Authorization', 'Bearer '+this.token1);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept' , 'application/json');

            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            System.debug('#******************************getJiraClouldIdLWC response='+response);
            if(response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                System.debug('results body:'+response.getBody());
                List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('results:'+results);
                return results;
                // Map<String, Object> result1 = (Map<String, Object>) results[0];
                // String cloudId = (String)result1.get('id');
                // System.debug('cloudId:'+results);
            }else{
                throw new AuraHandledException(response.toString());
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getJiraTicketLWC(String cloudId, String jsonBody){
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:jira_cloud_id/ex/jira/'+cloudId+'/rest/api/3/search/');
            request.setMethod('POST');
            //request.setHeader('Authorization', 'Bearer '+this.token1);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept' , 'application/json');
            request.setBody(jsonBody);

            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            System.debug('#******************************response='+response);
            System.debug('results:'+response.getBody());
            Map<String, Object> results = new Map<String, Object>();
            try{
                Map<String, Object> jiraRes = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                results.put('jiraRes', jiraRes);
            }catch(Exception e){

            }
            try{
                List<Object> jiraRes = (List<Object>) JSON.deserializeUntyped(response.getBody());
                results.put('jiraRes', jiraRes);
            }catch(Exception e){

            }
            results.put('StatusCode', response.getStatusCode());
            return results;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> createJiraTicketLWC(String cloudId, String jsonBody){
        try {
            Long ms = System.currentTimeMillis();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:jira_cloud_id/ex/jira/'+cloudId+'/rest/api/3/issue/bulk');
            request.setMethod('POST');
            //request.setHeader('Authorization', 'Bearer '+this.token1);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept' , 'application/json');
            //request.setBody('{"fields": {"project": {"key": "SP"},"summary": "Creating From Collection '+ms+'","description": {"type": "doc","version": 1,"content": [{"type": "paragraph","content": [{"type": "text","text": "This is an autogenerated issue from a demo."}]}]},"issuetype": {"name": "Task"}}}');
            request.setBody(jsonBody);

            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            System.debug('#******************************response='+response);
            System.debug('results:'+response.getBody());
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            results.put('StatusCode', response.getStatusCode());
            return results;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> createJiraProjectLWC(String cloudId, String jsonBody){
        try {
            Long ms = System.currentTimeMillis();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:jira_cloud_id/ex/jira/'+cloudId+'/rest/api/3/project/');
            request.setMethod('POST');
            //request.setHeader('Authorization', 'Bearer '+this.token1);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept' , 'application/json');
            //request.setBody('{"fields": {"project": {"key": "SP"},"summary": "Creating From Collection '+ms+'","description": {"type": "doc","version": 1,"content": [{"type": "paragraph","content": [{"type": "text","text": "This is an autogenerated issue from a demo."}]}]},"issuetype": {"name": "Task"}}}');
            request.setBody(jsonBody);

            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            System.debug('#******************************createJiraProjectLWC response='+response);
            System.debug('results:'+response.getBody());
            // if(response.getStatusCode() == 201) {
            //     // Deserialize the JSON string into collections of primitive data types.
            //     System.debug('results:'+response.getBody());
            //     Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            //     System.debug('results:'+results);
            //     //this.response1 = results.toString();
            //     return results;
            // }
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            results.put('StatusCode', response.getStatusCode());
            return results;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> jiraGenericCallLWC(String url, String jsonBody, String method, String callId){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            System.debug('#******************************method='+method);
            request.setMethod(method);
            //request.setHeader('Authorization', 'Bearer '+this.token1);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept' , 'application/json');
            if(method == 'POST' || method == 'PUT')
                request.setBody(jsonBody);

            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            System.debug('#******************************jiraGenericCallLWC response='+response);
            System.debug('results:'+response.getBody());
            Map<String, Object> results = new Map<String, Object>();
            try{
                Map<String, Object> jiraRes = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                results.put('jiraRes', jiraRes);
            }catch(Exception e){

            }
            try{
                List<Object> jiraRes = (List<Object>) JSON.deserializeUntyped(response.getBody());
                results.put('jiraRes', jiraRes);
            }catch(Exception e){

            }
            results.put('StatusCode', response.getStatusCode());
            results.put('callId', callId);
            return results;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}