// public with sharing class ContactTriggerHandler {
public class ContactTriggerHandler {

    // For Before Insert....
    public void beforeInsert(List<Contact> contactU){     
        checkStatus(contactU,new Map<Id,Contact>{});      
    }  

    public void beforeUpdate(List<Contact> newContact , Map<Id,Contact> oldContactMap){       
        checkStatus(newContact,oldContactMap);
     }

     public void checkStatus(List<Contact> contactU,Map<Id,Contact> oldContactMap){
    Set<Id> accId = new Set<Id>();
        for(Contact con : contactU){
            // if (con.AccountId != null && oldContactMap.isEmpty()) {
            //     Contact oldCon = oldContactMap.get(con.Id);
                
                if (con.AccountId != null && oldContactMap.isEmpty() || oldContactMap.get(con.Id)!= null && con.Status__c != oldContactMap.get(con.Id).Status__c) {
                    accId.add(con.AccountId);
                }
        }
            // }
            

             Map<Id, Account> accMap = new Map<Id, Account>([select Id, Name, Status__c from Account where Id IN : accId ]);
         
        for(Contact con : contactU){
            if(con.AccountId != null &&  accMap.containsKey(con.AccountId) ){               
                con.Status__c = accMap.get(con.AccountId).Status__c;
            }
        }    
    }
}

