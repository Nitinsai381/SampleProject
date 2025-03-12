public with sharing class CustomReparent {
  public void reParentCustomObject(Id parentId, List<Id> childIds) {
    List<AccountChild__c> accountChilds = [
      SELECT Id, Name, AccountParent__r.Id
      FROM AccountChild__c
      WHERE Id IN :childIds
    ];

    for (AccountChild__c accountChild : accountChilds) {
      accountChild.AccountParent__r.Id = parentId;
    }
    update accountChilds;
  }
}