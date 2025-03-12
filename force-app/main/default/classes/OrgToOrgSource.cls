public with sharing class OrgToOrgSource {
  public static void sendAccounts(List<Account> accountJSON) {
    String requestBody = JSON.serialize(accountJSON);
    String targetEndpoint = 'callout:testingExternal/services/apexrest/AccountInt';

    HttpRequest req = new HttpRequest();
    req.setEndpoint(targetEndpoint);
    req.setMethod('POST');
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
      System.debug('SessionId == > '+UserInfo.getSessionId());
    req.setHeader('Content-Type', 'application/json');
    System.debug('AccountsJSON == > ' + requestBody);
    req.setBody(requestBody);

    Http http = new Http();
    HttpResponse res = http.send(req);
    if (res.getStatusCode() != 200) {
      System.debug('Error sending accounts: ' + res.getBody());
    } else {
      System.debug('Accounts sent successfully. ' + res.getBody());
    }
  }
}