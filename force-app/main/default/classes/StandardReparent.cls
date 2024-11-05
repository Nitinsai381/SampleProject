public with sharing class StandardReparent extends ReparentAbstract {
  public override void reParentObject(
    Id parentId,
    List<Id> childIds,
    String objectName
  ) {
    // String query =
    //   ' SELECT Id, Name, AccountId FROM ' +
    //   objectName +
    //   ' WHERE Id IN ' +
    //   childIds;
    // List<SObject> objectRecords = Database.query(query);
    List<SObject> objectRecords = new List<SObject>();
    if (objectName == 'Contact') {
      objectRecords = [
        SELECT Id, Name, AccountId
        FROM Contact
        WHERE Id IN :childIds
      ];
    } else if (objectName == 'Opportunity') {
      objectRecords = [
        SELECT Id, Name, AccountId
        FROM Opportunity
        WHERE Id IN :childIds
      ];
    } else if (objectName == 'Case') {
      objectRecords = [
        SELECT Id, AccountId
        FROM Case
        WHERE Id IN :childIds
      ];
    }
    for (SObject objectData : objectRecords) {
      objectData.AccountId = parentId;
    }
    update objectRecords;
  }
  // @TestVisible
  // protected Map<String, Schema.SObjectField> getFieldsByObjectType(
  //   Schema.SObjectType sot,
  //   Schema.SObjectType parentType
  // ) {
  //   Map<Schema.SObjectType, Schema.SObjectField> schemaMap = new Map<Schema.SObjectType, Schema.SObjectField>{
  //     Schema.Contact => Schema.Contact.AccountId,
  //     Schema.Lead => Schema.Lead.AccountId
  //   };
  //   Map<String, Schema.SObjectField> mapReparent = new Map<String, Schema.SObjectField>();
  //   return mapReparent;
  // }
}
