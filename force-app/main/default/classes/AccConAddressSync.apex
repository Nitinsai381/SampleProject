//Today trigger scenario:
// Auto sync the address fields(city, state, postal code and street) changes between the account and contacts objects.

trigger ContactTrigger on Contact(before insert, before update){
    new ContactTriggerHandler().getAddressFromAccount(Trigger.new);
}

public without sharing class ContactTriggerHandler{
    public void getAddressFromAccount(List<Contact> newContacts){
        Set<Id> newConIds = new Set<Id>();
        for(Contact con : newContacts){
            newConIds.add(con.Id);
        }
        Map<Id, Account> accMap = Map<Id, Account>([Select Id, BillingCity, BillingState, BillingPostalCode, BillingStreet From Account ])
        if(!accMap.isEmpty()){
            return;
        }
        for(Contact con : newContacts){
            if(accMap.containsKey(con.AccountId)){
                con.BillingCity = accMap.get(con.AccountId).BillingCity;
                con.BillingState = accMap.get(con.AccountId).BillingState;
                con.BillingPostalCode = accMap.get(con.AccountId).BillingPostalCode;
                con.BillingStreet = accMap.get(con.AccountId).BillingStreet;
            }
        }
    }
}


trigger AccountTrigger on Account(before update){
    new AccountTriggerHandler().getAddressFromContact(Trigger.new);
}
public without sharing AccountTriggerHandler{
    public void getAddressFromContact(List<Account> newAccs){
        Map<Id,Account> accMap = new SMap<Id,Account>();
        for(Account acc: newAccs){
            accMap.put(acc.Id, acc);
        }
        List<Contact> conList = [Select Id, AccountId, BillingCity, BillingPostalCode,BillingStreet,BillingState from Contact where AccountId In : accMap.keySet()];
        for(Contact con: conList){
            accMap.get(con.AccountId).BillingCity = con.BillingCity;
            accMap.get(con.AccountId).BillingPostalCode = con.BillingPostalCode;
            accMap.get(con.AccountId).BillingState = con.BillingState;
            accMap.get(con.AccountId).BillingStreet = con.BillingStreet;
        }
    }
}