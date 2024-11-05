@isTest
public with sharing class ReparentTriggerHandlerTest {
@isTest
public static void reparentingChilds(){
    Account acc1 = new Account(Name='AccountForReparent');
    insert acc1;
    List<Contact> contacts = new List<Contact>{new Contact(Name='ContactForReparent1'), new Contact(Name='ContactForReparent2'),new Contact(Name='ContactForReparent3')}  ; 
    insert contacts;
    Test.startTest();
    List<Account> accList = [select Id,Name from Account where Name='AccountForReparent'];
    List<Contact> cons = [select Id, Name from Contact where Name = 'ContactForReparent1' or Name = 'ContactForReparent2' or Name = 'ContactForReparent3'];
    List<Reparent__e> reparentList = new List<Reparent__e>();
    Reparent__e reparent = new Reparent__e(ParentId__c=accList.Id);
    Test.stopTest();
}
}