public with sharing class RecordsFromAccordWrapper {
  @AuraEnabled
  public List<Contact> contacts;
  @AuraEnabled
  public List<Opportunity> opportunities;
  @AuraEnabled
  public List<Case> cases;

  public RecordsFromAccordWrapper(
    List<Contact> contacts,
    List<Opportunity> opportunities,
    List<Case> cases
  ) {
    this.contacts = contacts;
    this.opportunities = opportunities;
    this.cases = cases;
  }
}
