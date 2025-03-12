public with sharing class GetAllFieldsOfAllObjects {
  public GetAllFieldsOfAllObjects() {
  }
  public void getAllFields() {
    Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

    Map<String, List<String>> allFieldsContainsCTC = new Map<String, List<String>>();

    for (String objectName : globalDescribe.keySet()) {
      Schema.SObjectType objectType = globalDescribe.get(objectName);

      Schema.DescribeSObjectResult describeResult = objectType.getDescribe();

      Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();

      // Iterate through the fieldMap to access each field details
      allFieldsContainsCTC.put(objectName, new List<String>());

      for (Schema.SObjectField field : fieldMap.values()) {
        // System.debug(
        //   field.getDescribe().getName() + ' - ' + field.getDescribe().getType()
        // );
        String fieldName = '' + field;
        if (fieldName.containsIgnoreCase('ctc')) {
          allFieldsContainsCTC.get(objectName).add(fieldName);
          // System.debug('Object = ' + objectName + 'Field = ' + fieldName);
        }
      }
    }
    // System.debug(allFieldsContainsCTC);

    Map<String, List<String>> allFieldsContainsOnlyCTC = new Map<String, List<String>>();
    for (String objectApi : allFieldsContainsCTC.keySet()) {
      if (allFieldsContainsCTC.get(objectApi).size() != 0) {
        allFieldsContainsOnlyCTC.put(
          objectApi,
          allFieldsContainsCTC.get(objectApi)
        );
        System.debug(
          'Object = ' +
            objectApi +
            ' || Field = ' +
            allFieldsContainsCTC.get(objectApi)
        );
      }
    }
    System.debug(allFieldsContainsOnlyCTC);
  }
}