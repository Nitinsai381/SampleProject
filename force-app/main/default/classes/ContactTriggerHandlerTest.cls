@isTest
private class ContactTriggerHandlerTest {


    @TestSetup//to create setup object data... like Users, Persmission sets, Queues, Groups.
    static void makeData(){
        
    }

    @isTest
    static void updateContactWithAccStatusTest() {
        // TO DO: implement unit test
        Account a = new Account(Name = 'Test Acc', Status__c = true);
        insert a;

        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = a.Id);
        Test.startTest();
        insert c;

        Contact updateCon = [SELECT Id, Status__c FROM Contact WHERE Id =: c.Id];
        System.assertEquals(true, updateCon.Status__c, 'Status should equal Account status');
        Test.stopTest();
    }
}//prettier for apex, npm, node, java ver 17, GitHub -> Repo -> push, SFDX CLI 