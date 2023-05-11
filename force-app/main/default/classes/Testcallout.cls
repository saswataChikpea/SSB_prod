@isTest
public class Testcallout {
static void testAccessTokenCallout() {
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new CreateProjectInPmscallouts_calloutest());

    // Frst request
    Http h = new Http();        
    HttpRequest req1 = new HttpRequest();
    req1.setEndpoint('http://mygreatservice.com/foo/bar');
    req1.setMethod('POST');
    req1.setBody('Access Token');
    HttpResponse res1 = h.send(req1);
    System.assertEquals('{"access_token":"somevalidAccessToken"}', res1.getBody());

    // Second request       
    HttpRequest req2 = new HttpRequest();
    req2.setEndpoint('http://mygreatservice.com/foo/bar');
    req2.setMethod('POST');
    req2.setBody('Client Id');
    HttpResponse res2 = h.send(req2);
    System.assertEquals('{"client_id" : "12345"}', res2.getBody());

    Test.startTest();

    // Trigger should fire to grab Beyond ID
    Account a = new Account();
    a.Name = 'APITestAccount';
    insert a;     

    Set<Id> accountIds = new Set<Id>();
    accountIds.add(a.Id);

    //BeyondApiService.fetchBeyondClientIds(accountIds);

    Test.stopTest();
}
}