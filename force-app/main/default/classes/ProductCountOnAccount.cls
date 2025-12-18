trigger ProductTrigger on Product(after insert){
    new ProductTriggerHandler().countOfProducts(Trigger.new);
}
public without sharing class ProductTriggerHandler{
    public void countOfProducts(List<Product> newProducts){
        Set<Id> oppIds = new Set<Id>();
        for(Product prod : newProducts){
            if(prod.OpportunityId!=null ){
                oppIds.add(prod.OpportunityId);
            }
        }
        if(oppIds.isEmpty()){
            return;
        }
        List<Opportunity> oppList = [Select Id, AccountId from Opportunity where Id IN: oppIds];
        List<Product> prodList = [Select Id, OpportunityId from Product where OpportunityId IN : oppIds];
        Map<Id, Integer> prodCountOfOpp = new Map<Id,Integer>();
        for(Product prod : prodList){
            if(!prodList.containsKey(prod.OpportunityId)){
                prodList.put(OpportunityId, 1);
            }
            else{
                prodList.get(OpportunityId)+=1;
            }
        }
        Map<Id,Account> accToUpdate = new Map<Id,Account>();
        for(Opportunity opp : oppList){
            if(prodCountOfOpp.containsKey(opp.Id)){
                if( !accToUpdate.containsKey(opp.AccountId)){
                    accToUpdate.put(opp.AccountId, new Account(id= opp.accountId));
                }
                
                    accToUpdate.get(opp.AccountId).countOfProducts+= prodCountOfOpp.get(opp.Id);                
            }
        }
        if(!accToUpdate.isEmpty()){
            Database.update(accToUpdate.values(),false);
        }
    }
}