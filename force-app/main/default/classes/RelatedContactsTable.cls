public class RelatedContactsTable {
  @AuraEnabled
  public String columnName;
  // @AuraEnabled
  // public String columnApiName;
  @AuraEnabled
  public List<Contact> contacts;
  // public RelatedContactsTable() {
  // }
  public RelatedContactsTable(String columnName) {
    // List<Contact> contacts
    this.columnName = columnName;
    // this.columnApiName = columnApiName;
    // this.contacts = contacts;
  }
  public RelatedContactsTable(
    // String columnName,
    // String columnApiName,
    List<Contact> contacts
  ) {
    // this.columnName = columnName;
    // this.columnApiName = columnApiName;
    this.contacts = contacts;
  }
}
