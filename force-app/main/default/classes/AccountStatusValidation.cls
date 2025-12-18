/*
On Account there is picklist name Called Status with following 2 values “Active” , “Not Active”.
Please write a Trigger to Validate Following Scenario:
IF user is changing Account.Status__c value from “Active” to “Not Active”
then do not allow users to change the Value to “Not Active”
incase there is any Open Opportunity associated with Account.
(Note: Validation Error message through Trigger)
*/

trigger AccountTrigger on Account(before update){
    new AccountTriggerHandler(Trigger.new, Trigger.oldMap);
}
public class without AccountTriggerHandler{
    public void checkAccount(List<Account> accList, Map<Id,Account> oldAccMap){
        Set<Id> accIds = new Set<Id>();
        for(Account acc: accList){
            if((acc.Status__c!=oldAccMap.get(acc.Id).Status__c) && acc.Status__c=='Not Active'){
                accIds.add(acc.Id);
            }
        }
        if(accIds.isEmpty()){
            return;
        }
        Map<Id,Opportunity> oppList = Map<Id,Opportunity>([Select AccountId, StageName from Opportunity where AccountId IN : accIds AND StageName != 'Closed Lost' AND StageName!='Closed Won' limit 1]);
        if(oppList.isEmpty()){
            return;
        }
        for(Account acc: accList){
            if(oppList.containsKey(acc.Id)){
                acc.addError('Error in changing status!')
            }
        }
    }
}