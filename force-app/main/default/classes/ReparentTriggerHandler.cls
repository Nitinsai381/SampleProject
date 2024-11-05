public with sharing class ReparentTriggerHandler {
  // public ReparentTriggerHandler() {

  // }
  public void reparentingChilds(List<Reparent__e> reparentMessage) {
    //guard clauses

    if (reparentMessage.isEmpty()) {
      return;
    }
    Id parentId;
    String childIdsStr;
    String className;
    System.debug('reparentMessage ---- ' + reparentMessage.get(0));

    for (Reparent__e event : reparentMessage) {
      parentId = event.ParentId__c;
      childIdsStr = event.ChildIds__c;
      className = event.Class_Name__c;
    }
    if (String.isBlank(childIdsStr)) {
      return;
    }
    // List<String> childIds = childIdsStr.split(', ');
    Schema.SObjectType parentType = parentId.getSObjectType();
    String parentName = parentType.getDescribe().getName();
    Set<String> childNames = new Set<String>();
    System.debug('ChildIds string = ' + childIdsStr);
    List<Id> childIds = (List<Id>) JSON.deserialize(
      childIdsStr,
      List<Id>.class
    );

    System.debug(
      'ChildIds after deserialize == ' +
      (List<Id>) JSON.deserialize(childIdsStr, List<Id>.class)
    );
    String childObjName;
    for (Id childId : childIds) {
      Schema.SObjectType childType = childId.getSObjectType();
      String childName = childType.getDescribe().getName();
      childObjName = childName;
      childNames.add(childName);
    }
    System.debug('ParentId = ' + parentId + ', Parent Name = ' + parentName);
    if (childNames.size() == 1) {
      String childName = childNames.toString();
      ReparentAbstract standardAbs = (ReparentAbstract) Type.forName(className)
        .newInstance();
      standardAbs.reParentObject(parentId, childIds, childObjName);
      // StandardReparent standardObj = new StandardReparent();
      // standardObj.reParentObject(parentId, childIds, childObjName);
    }
  }
}
