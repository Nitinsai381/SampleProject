public with sharing class DynamicTable {
  public DynamicTable() {
  }
  @AuraEnabled(cacheable=true)
  public static List<DynamicTableWrapper> dynamicTableData(
    Id id,
    String objectName
  ) {
    List<Object_Field_Config__mdt> mdtColumns = [
      SELECT Field_Config__r.label, Field_Config__r.Field_Api_Name__c
      FROM Object_Field_Config__mdt
      WHERE Object_Config__r.label = :objectName
    ];
    System.debug('MetaData ==== ' + mdtColumns);
    List<DynamicTableWrapper> dynamicTable = new List<DynamicTableWrapper>();
    dynamicTable.add(new DynamicTableWrapper(mdtColumns));
    String query = 'Select Id, ';
    for (Integer i = 0; i < mdtColumns.size(); i++) {
      if (i == (mdtColumns.size() - 1)) {
        query += mdtColumns[i].Field_Config__r.Field_Api_Name__c;
      } else {
        query += mdtColumns[i].Field_Config__r.Field_Api_Name__c + ', ';
      }
    }
    query += ' from ' + objectName + ' Where AccountId=: id';
    List<SObject> objectList = Database.query(query);
    dynamicTable.add(new DynamicTableWrapper(objectList));
    System.debug('SObject Records ==== ' + objectList);
    System.debug('DynamicTableWrapper Data ==== ' + dynamicTable);
    return dynamicTable;
  }
}
