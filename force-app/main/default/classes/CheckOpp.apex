/**
 * Write a Trigger On
Only one Opportunity can be created per Account per day.
Multiple Opportunities for the same Account in a single transaction are not allowed, throw an error message".
 */

trigger OpportunityTrigger on Opportunity(before insert){
    new OpportunityTriggerHandler().beforeInsert(Trigger.new);
}

public without sharing class OpportunityTriggerHandler{
public void beforeInsert(List<Opportunity> newOpps){
    Map<Id,Opportunity> accIdsMap = new Map<Id,Opportunity>();
    for(Opportunity opp: newOpps){
        if(opp.AccountId!=null){

            accIdsMap.add(opp.AccountId, null);
        }
    }
    if(accIdsMap.isEmpty()){
        return;
    }
    List<Opportunity> oldOpps = [Select AccountId from Opportunity where AccountId in : accIdsMap.keySet() and CreatedDate = System.today() limit 1];
    if(oldOpps.isEmpty()){
        return;
    }
    for(Opportunity opp: oldOpps){
        if(accIdsMap.containsKey(opp.AccountId)){
            
            accIdsMap.get(opp.AccountId).add(opp);
        }
    }
    for(Opportunity opp: newOpps){
        if(accIdsMap.containsKey(opp.AccountId) && accIdsMap.get(opp.AccountId)!=null){
            opp.addError('Opportunity already exists!')
        }
    }
}
}

