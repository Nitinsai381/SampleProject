public with sharing class DynamicTableWrapper {
  // @AuraEnabled
  // public List<Object_Field_Config__mdt> columns;
  @AuraEnabled
  public List<Map<String, String>> columns;
  @AuraEnabled
  public List<SObject> objectType;

  // public DynamicTableWrapper(List<Map<String, String>> columns) {
  //   this.columns = columns;
  // }
  // public DynamicTableWrapper(List<Object_Field_Config__mdt> columns) {
  //   this.columns = columns;
  // }
  // public DynamicTableWrapper(List<SObject> objectType) {
  //   this.objectType = objectType;
  // }

  public DynamicTableWrapper(
    List<Map<String, String>> columns,
    List<SObject> objectType
  ) {
    this.columns = columns;
    this.objectType = objectType;
  }
}
