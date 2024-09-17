public with sharing class AccountRelatedContacts {
  @AuraEnabled(cacheable=true)
  public static List<Contact> accountContacts(Id accId) {
    return [
      SELECT Id, Name, Email, Phone, Owner.Name
      FROM Contact
      WHERE AccountId = :accId
      ORDER BY LastModifiedDate DESC
    ];
  }
}
