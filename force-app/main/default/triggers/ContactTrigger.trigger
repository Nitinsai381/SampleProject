trigger ContactTrigger on Contact (before insert, before update) {
    ContactTriggerHandler cth=new ContactTriggerHandler();
    if((Trigger.isBefore) && (Trigger.isInsert )){
        cth.beforeInsert(Trigger.new); 
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        cth.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    
    
}