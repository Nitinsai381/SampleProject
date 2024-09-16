public without sharing class AccountTriggerHandler{

    public void afterUpdate(List<Account> acco, Map<Id,Account> oldMap){
        // System.debug('oldMap==  '+oldMap);
        // Set<Id> accIds = new Set<Id>();
        Map<Id,Account> accM = new Map<Id,Account>();

        for(Account acc : acco){
            if(acc.Status__c != oldMap.get(acc.Id).Status__c) {
            // accIds.add(acc.Id);
            accM.put(acc.Id,acc);
            }
        }
        if(!accM.isEmpty()){
            changeContactStatus(accM);
        }
    }

    public static void changeContactStatus(Map<Id,Account> accMap){//apex security model
        List<Contact> conList = [Select Id, Name, AccountId, Status__c from Contact where AccountId In : accMap.keyset() WITH SECURITY_ENFORCED];
        for(Contact c : conList){
            if(c.AccountId<> null){
                Account a = accMap.get(c.AccountId);
                c.Status__c = a.Status__c;
            }
        }
        if(conList.size()>0 && !Schema.sObjectType.Contact.fields.Status__c.isUpdateable()){
            update conList;
        }
    }
}