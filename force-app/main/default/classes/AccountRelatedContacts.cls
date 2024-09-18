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

  @AuraEnabled(cacheable=true)
  public static List<Contact> dynamicAccountContacts(Id accId) {
    List<RelatedContact__mdt> metadataLabels = contactLabels();

    String query = 'Select Id, ';

    for (Integer i = 0; i < metadataLabels.size(); i++) {
      if (i == (metadataLabels.size() - 1)) {
        query += metadataLabels[i].Column_Api_Name__c;
      } else {
        query += metadataLabels[i].Column_Api_Name__c + ', ';
      }
    }
    query += ' from Contact Where AccountId =: accId';
    System.debug(query);
    List<Contact> relatedContacts = Database.query(query);
    System.debug(relatedContacts);
    return relatedContacts;
  }
  
  @AuraEnabled(cacheable=true)
  public static List<RelatedContact__mdt> contactLabels() {
    return [
      SELECT Column__c, Column_Api_Name__c
      FROM RelatedContact__mdt
    ];
  }
}
