public with sharing class AccountRelatedContacts {
  String columnName;
  String columnApiName;
  List<Contact> contacts;

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

    query += ' from Contact Where AccountId =: accId ORDER BY LastModifiedDate DESC';
    System.debug(query);
    List<Contact> relatedContacts = Database.query(query);

    System.debug(relatedContacts);
    return relatedContacts;
  }

  @AuraEnabled(cacheable=true)
  public static List<RelatedContact__mdt> contactLabels() {
    // Clue given....
    //class obj = new class();
    //string q = 'SELECT Id,';
    //List<class> objList = new List<Class>();
    //obj.columnName = mdt.column__c
    //obj.colApNam = mdt.api__c
    //objList.add(obj);//new LIst<Class>{new Class(columnName : 'value', apiName : 'value'), .......}
    //set<String>
    //string.join(set<string> , ',')
    //'fieldname, fieldname....'
    // q += string.join(
    //obj.contact =database.Query()
    //from contact)
    /**
     * String columnName
     * String columnApiName
     * List<Contact> contacts
     */
    // clue till here....

    return [
      SELECT Column__c, Column_Api_Name__c
      FROM RelatedContact__mdt
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<RelatedContactsTable> relatedContactsTable(Id accId) {
    List<RelatedContact__mdt> rcMdt = [
      SELECT Column__c, Column_Api_Name__c
      FROM RelatedContact__mdt
    ];
    RelatedContactsTable rct; //= new RelatedContactsTable();
    List<RelatedContactsTable> rctList = new List<RelatedContactsTable>();
    Set<String> columns = new Set<String>();
    for (RelatedContact__mdt mdt : rcMdt) {
      columns.add(mdt.Column_Api_Name__c);
    }
    rctList.add(new RelatedContactsTable(rcMdt));
    String query = 'Select Id, ';
    query +=
      String.join(columns, ', ') +
      ' from Contact where AccountId = :accId  order by LastModifiedDate desc';
    System.debug(String.join(columns, ', '));
    System.debug(query);
    List<Contact> contactList = Database.query(query);
    System.debug(contactList);
    rctList.add(new RelatedContactsTable(contactList));
    System.debug(rctList);
    return rctList;
    // Map<String, List<String>> labelContacts = new Map<String, List<String>>();
    // for (RelatedContact__mdt rc : rctList) {
    //   for (Contact c : contactList) {
    //     String a = rc.Column_Api_Name__c;
    //     if (!labelContacts.containsKey(rc.Column__c)) {
    //       labelContacts.put(rc.Column__c, c.a);
    //     }
    //     labelContacts.put(rc.Column__c,new List())
    //   }
    // }
  }
}