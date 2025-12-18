// Today's Trigger Scenario : 

// When a record is created(You Can Take Any Object), share it with the record creator's manager (Owner's Manager Sharing)

trigger AccountTrigger on Account(after insert){
    new AccountTriggerHandler().changeOwnerOnInsert(Trigger.new);
}
public without sharing AccountTriggerHandler{
    public void changeOwnerOnInsert(List<Account> newAccs){
        Set<Id> oldOwner = new Set<Id>;
        for(Account acc : newAccs){
            if(acc.OwnerId!=null){
                oldOwner.add(acc.OwnerId);
            }
        }
        Map<Id,User> ownerUsers = Map<Id,User>([Select Id, ManagerId from User where Id in : oldOwner]);
        if(!ownerUsers.isEmpty()){
            return;
        }
        List<AccountShare> shareToNewOwners = new List<AccountShare>();
        for(Account acc : newAccs){
            if(ownerUsers.containsKey(acc.OwnerId))
            shareToNewOwners.add(AccountId = acc.Id, UserOrGroupId = ownerUsers.get(acc.OwnerId).ManagerId,AccountAccessLevel='Edit');
        }
        if(!shareToNewOwners.isEmpty()){
            Database.insert(shareToNewOwners,false);
        }
    }
}