public with sharing class RecordsFormSelectAccount {
  @AuraEnabled(cacheable=true)
  public static List<Account> recordsFormSelectAccount() {
    return [SELECT Id, Name FROM Account];
  }

  @AuraEnabled(cacheable=true)
  public static RecordsFromAccordWrapper allRelatedRecords(String accId) {
    List<Contact> conList = [
      SELECT Id, Name, Phone, Email
      FROM Contact
      WHERE AccountId = :accId
    ];
    List<Opportunity> oppsList = [
      SELECT Id, Name, StageName, CloseDate
      FROM Opportunity
      WHERE AccountId = :accId
    ];
    List<Case> caseList = [
      SELECT Id, Status, CaseNumber
      FROM Case
      WHERE AccountId = :accId
    ];
    RecordsFromAccordWrapper allRecords = new RecordsFromAccordWrapper(
      conList,
      oppsList,
      caseList
    );
    return allRecords;
  }

  @AuraEnabled(cacheable=true)
  public static List<SObject> relatedObjectsList(
    String accId,
    String objectName
  ) {
    List<SObject> objectList;
    if (objectName == 'Contact') {
      objectList = [
        SELECT Id, Name, Phone, Email
        FROM Contact
        WHERE AccountId = :accId
      ];
    } else if (objectName == 'Opportunity') {
      objectList = [
        SELECT Id, Name, StageName, CloseDate
        FROM Opportunity
        WHERE AccountId = :accId
      ];
    } else if (objectName == 'Case') {
      objectList = [
        SELECT Id, Status, CaseNumber
        FROM Case
        WHERE AccountId = :accId
      ];
    }

    System.debug('Related records == ' + objectList);
    return objectList;
  }

  @AuraEnabled(cacheable=true)
  public static List<Contact> relatedContactsList(
    String accId,
    List<Contact> contacts
  ) {
    return [
      SELECT Id, Name, Phone, Email
      FROM Contact
      WHERE AccountId = :accId
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<Opportunity> relatedOpportunitiesList(
    String accId,
    List<Opportunity> opps
  ) {
    String onj = 'Contact';
    return [
      SELECT Id, Name, StageName, CloseDate
      FROM Opportunity
      WHERE AccountId = :accId
    ];
  }

  // @AuraEnabled(cacheable=true)
  // public static List<Case> relatedCasesList(String accId, List<Case> cases) {
  //   return [SELECT Id, Status, CaseNumber FROM Case WHERE AccountId = :accId];
  // }
}
