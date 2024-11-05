public with sharing class CustomReparent {
  public void reParentCustomObject(Id parentId, List<Id> childIds) {
    List<AccountChild__c> accountChilds = [
      SELECT Id, Name, AccountParent__r.Id
      FROM AccountChild__c
      WHERE Id IN :childIds
    ];
    Schema.SObjectField accountRelation = this.getFieldsByObjectType(childIds[0].getSobjectType(),parentId.getSobjectType());
    for (AccountChild__c accountChild : accountChilds) {
      accountChild.AccountParent__r.Id = parentId;
    }  
    update accountChilds;
  }

  List<SObject> childsToUpdate = new List<SObject>();
  SObject child = childId.newInstance();
  child.put('Id', '');
  child.put(accountRelation, parentId);
  update childsToUpdate;

  /**
   * Method Documentation
   * 
   */ 
  // this method goes to Abstract  class
  @TestVisible
  protected Map<String, Schema.SObjectField> getFieldsByObjectType(Schema.SObjectType sot, parentType){

    Map<Schema.SObjecType, Schema.SObjectField>{
      Schema.Contact => Schema.Contact.AccountId, Schema.Lead => Schema.Lead.AccountId
    }
    return 
  }

  //setResumeCheckpoint--2 events
}
