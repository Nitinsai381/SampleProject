public with sharing class CalloutsRestApi {
  // GET
  public void calloutsRestApiGet() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://reqres.in/api/users');
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    System.debug('Response == ' + response);
    if (response.getStatusCode() == 200) {
      System.debug('JSON format == ' + JSON.serialize(response.getBody()));
      //   Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
      //     response.getBody()
      //   );
      //   System.debug(result);
    } else {
      System.debug('Error!');
    }
  }

  // POST
  public void calloutsRestApiPost() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://reqres.in/api/users');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    String body = '{"name": "morpheus","job": "leader"}';
    request.setBody(body);
    HttpResponse response = http.send(request);
    System.debug('Response == ' + response);
  }

  //PATCH
  public void calloutsRestApiPatch() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://reqres.in/api/users/2');
    request.setMethod('PATCH');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    String body = '{"name": "Junk","job": "Doll"}';
    request.setBody(body);
    HttpResponse response = http.send(request);
    System.debug('Response == ' + response);
  }

  //PUT
  public void calloutsRestApiPut() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://reqres.in/api/users/2');
    request.setMethod('PUT');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    String body = '{"name": "Junk","job": "Doll"}';
    request.setBody(body);
    HttpResponse response = http.send(request);
    System.debug('Response == ' + response);
    if (response.getStatusCode() == 200) {
      System.debug('Result == ' + JSON.serialize(response.getBody()));
    }
  }

  //DELETE
  public void calloutsRestApiDelete() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://reqres.in/api/users/2');
    request.setMethod('DELETE');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // String body = '{"name": "Junk","job": "Doll"}';
    // request.setBody(body);
    HttpResponse response = http.send(request);
    System.debug('Response == ' + response);
    if (response.getStatusCode() == 204) {
      System.debug('Result Deleted == ' + JSON.serialize(response.getBody()));
    }
  }
}
