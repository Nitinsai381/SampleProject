/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void afterUpdate() {
        // TO DO: implement unit test
        Account a = new Account(Name='Test Account' );
        insert a;
        List<Contact> contactList = new List<Contact>();
        for (Integer i=0; i<10; i++){
            Contact c = new Contact(LastName='Test Contact '+i, AccountId=a.Id);
            contactList.add(c);
        }
        insert contactList;
        Test.startTest();
        a.Status__c=true;
        update  a;
        
        Test.stopTest();

        List<Contact> relatedList = [SELECT Id, Status__c FROM Contact WHERE AccountId =:a.Id];
        for (Contact c : relatedList){
            System.assertEquals(a.Status__c, c.Status__c, 'Contact status should equal Account Status');
        }
    }
}