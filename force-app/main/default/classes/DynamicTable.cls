public with sharing class DynamicTable {
  public DynamicTable() {
  }
  // @AuraEnabled(cacheable=true)
  // public static List<DynamicTableWrapper> dynamicTableData(
  //   Id id,
  //   String objectName
  // ) {
  //   List<Object_Field_Config__mdt> mdtColumns = [
  //     SELECT Field_Config__r.label, Field_Config__r.Field_Api_Name__c
  //     FROM Object_Field_Config__mdt
  //     WHERE Object_Config__r.label = :objectName
  //   ];
  //   System.debug('MetaData ==== ' + mdtColumns);
  //   List<DynamicTableWrapper> dynamicTable = new List<DynamicTableWrapper>();
  //   dynamicTable.add(new DynamicTableWrapper(mdtColumns));
  //   String query = 'Select Id, ';
  //   for (Integer i = 0; i < mdtColumns.size(); i++) {
  //     if (i == (mdtColumns.size() - 1)) {
  //       query += mdtColumns[i].Field_Config__r.Field_Api_Name__c;
  //     } else {
  //       query += mdtColumns[i].Field_Config__r.Field_Api_Name__c + ', ';
  //     }
  //   }
  //   query += ' from ' + objectName + ' Where AccountId=: id';
  //   List<SObject> objectList = Database.query(query);
  //   dynamicTable.add(new DynamicTableWrapper(objectList));
  //   System.debug('SObject Records ==== ' + objectList);
  //   System.debug('DynamicTableWrapper Data ==== ' + dynamicTable);
  //   return dynamicTable;
  // }

  @AuraEnabled(cacheable=true)
  public static Map<String, DynamicTableWrapper> dynamicTableDataHere(
    Id id,
    String objectName
  ) {
    Map<String, DynamicTableWrapper> tableData = new Map<String, DynamicTableWrapper>();
    List<Map<String, String>> columnsData = new List<Map<String, String>>();
    Set<String> cols = new Set<String>();
    for (Object_Field_Config__mdt colMdt : [
      SELECT Field_Config__r.label, Field_Config__r.Field_Api_Name__c
      FROM Object_Field_Config__mdt
      WHERE Object_Config__r.label = :objectName
    ]) {
      columnsData
        .add(
          new Map<String, String>{
            'Id' => colMdt.Field_Config__r.Id,
            'Label' => colMdt.Field_Config__r.Label,
            'Field_Api_Name' => colMdt.Field_Config__r.Field_Api_Name__c
          }
        );
      cols.add(colMdt.Field_Config__r.Field_Api_Name__c);
    }
    // tableData.put('columns', new DynamicTableWrapper(columnsData));

    String query = 'Select Id, ';
    query +=
      String.join(cols, ', ') +
      ' from ' +
      objectName +
      ' Where AccountId=: id';
    List<SObject> records = Database.query(query);
    tableData.put('data', new DynamicTableWrapper(columnsData,records));
    return tableData;
  }
}
