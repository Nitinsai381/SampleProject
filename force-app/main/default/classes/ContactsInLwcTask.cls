public with sharing class ContactsInLwcTask {
  @AuraEnabled(cacheable=true)
  public static List<Contact> contactsListInLWC() {
    List<Contact> conList = [SELECT Id, Name, Email, Phone FROM Contact];
    return conList;
  }

  @AuraEnabled(cacheable=true)
  public static List<Contact> getContactDetails(Id conId) {
    System.debug('Contact Id ==== ' + conId);

    List<Contact> con = [
      SELECT
        FirstName,
        LastName,
        Department,
        Email,
        Phone,
        Languages__c,
        Birthdate,
        Upload_Image__c,
        CreatedDate
      FROM Contact
      WHERE Id = :conId
    ];
    // List<Contact> con = Database.query(
    //   'select FirstName from Contact where Id =: conId'
    // );
    return con;
  }
}
