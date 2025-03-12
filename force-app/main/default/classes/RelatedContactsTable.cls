public class RelatedContactsTable {
  // @AuraEnabled
  // public String columnName;
  // @AuraEnabled
  // public String columnApiName;
  @AuraEnabled
  public List<Contact> contacts;

  @AuraEnabled
  public List<RelatedContact__mdt> columns;

  public RelatedContactsTable(List<RelatedContact__mdt> columns) {
    this.columns = columns;
  }
  public RelatedContactsTable(List<Contact> contacts) {
    this.contacts = contacts;
  }
}