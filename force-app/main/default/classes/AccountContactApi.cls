@RestResource(Urlmapping='/AccountContactApi')
global class AccountContactApi {
  @HttpPost
  global static void saveAcctContFromExternalSystem() {
    //Initiate Req and res objects
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    //Parse Your JSON Body to your own understandable structures
    String body = req.requestBody.toString(); // {"CustomerName":"salesforce", "isAccount":true}
    MyJsonClass myObj = (MyJsonClass) JSON.deserialize(body, MyJsonClass.class);
    System.debug('@@@@' + myObj.CustomerName + '@' + myObj.isAccount);
    //your Logic
    if (myObj.isAccount == true) {
      Account acc = new Account(name = myObj.CustomerName);
      insert acc;
    } else if (myObj.isAccount == false) {
      Contact con = new Contact(lastname = myObj.CustomerName);
      insert con;
    }
  }
}
