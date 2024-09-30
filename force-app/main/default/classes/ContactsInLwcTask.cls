public with sharing class ContactsInLwcTask {
  @AuraEnabled(cacheable=true)
  public static List<Contact> contactsListInLWC() {
    List<Contact> conList = [SELECT Id, Name, Email, Phone FROM Contact];
    return conList;
  }
}
