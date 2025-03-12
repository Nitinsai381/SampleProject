public with sharing class AllFlowsRevision {

    @InvocableMethod(label='Get Account Details' description='Returns Account Details' category='Account')
	public static List<WrapperClass> createInOtherOrg(List<persondetails> person)
    {
        String body= '{"attributes" : { "type" : "Account" },"Name" : "'+person[0].Name+'","Mobile__c" : '+person[0].Mobile+',"Email__c" : "'+person[0].Email+'","City__c" : "'+person[0].City+'","Salary__c" : '+ person[0].Salary +'}';
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('callout:P1N/services/data/v55.0/sobjects/Person__c');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        req.setBody(body);
        res = http.send(req);
        system.debug('response body'+res.getBody());
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> obj = (List<Object>)meta.values();
        if(res.getStatus() == 'Success')
        {
            System.debug('Successfully Created Account');
          
          
         
		}
        else
        {
        System.debug('Failed Creating Account');
        }
        System.debug('data'+obj[0]);
        List<WrapperClass> wrapList = new List<WrapperClass>();
        List<List<WrapperClass>> wList = new List<List<WrapperClass>>();
        WrapperClass wrap = new WrapperClass();
        wrap.Id = (string)obj[0];
        wrap.Success = (boolean)obj[1];
        //wrap.Error = (List<String>)obj[2];
        wrapList.add(wrap);
        wList.add(wrapList);
        return wrapList;
}
    public class persondetails
    {
        @InvocableVariable(required=true)
        public String Name;
        @InvocableVariable(required=true)
        public String Email;
        @InvocableVariable(required=true)
        public String City;
        @InvocableVariable(required=true)
        public String Mobile;
        @InvocableVariable(required=true)
        public Integer Salary;
    }
    public class WrapperClass
    {
        @InvocableVariable public String Id;
        @InvocableVariable public boolean Success;
        @InvocableVariable public List<String> Error;
    }
}