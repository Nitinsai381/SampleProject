trigger CaseTrigger on Case(after insert){
 new CaseTriggerHandler().countCaseTypes(Trigger.new); 
}

public without sharing class CaseTriggerHandler {
    public void countCaseTypes(List<Case> newCases){
        Set<Id> accSet = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id, Account>();
        for(Case newCase: newCases){
            accSet.add(newCase.AccountId);
        }
        if(accSet.isEmpty()){
            return;
        }
        List<Case> casesList = [Select AccountId, RecordType.Name from Case Where AccountId In : accSet];
        if(caseList.isEmpty()){
            return;
        }
        for(Case case : casesList){
        if(!accMap.containsKey(case.AccountId)){
             Account acc = new Account(Id = case.AccountId, Total_Partner_Cases__c = 0, Total_Customer_Cases__c=0);
            accMap.put(case.AccountId, acc);
           
        } 
        if(case.RecordType.Name.equalsIgnoreCase('Partner')){
                accMap.get(case.AccountId).Total_Partner_Cases__c +=1;
        }
        else if(case.RecordType.Name.equalsIgnoreCase('Customer')){
                accMap.get(case.AccountId).Total_Customer_Cases__c +=1;
        }

        }
        if(!accMap.isEmpty()){
            Database.update(accMap.values());
        }
    }
    // public void countCaseTypes2(List<Case> newCases){
    //     Id partnerRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId();
    //     Id customerRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId();

    //     List<AggregateResult> caseList = [Select RecordTypeId from Case Group by RecordTypeId];
    // }
}