public with sharing class DynamicTableWrapper {
  @AuraEnabled
  public List<Object_Field_Config__mdt> columns;
  @AuraEnabled
  public List<SObject> objectType;

  public DynamicTableWrapper(List<Object_Field_Config__mdt> columns) {
    this.columns = columns;
  }
  public DynamicTableWrapper(List<SObject> objectType) {
    this.objectType = objectType;
  }
}
