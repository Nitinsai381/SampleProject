/*
Trigger Scenario :
Whenever a new Task is assigned to a Contact, increment the Number of Tasks Associated field on Contact by 1
*/

trigger TaskTrigger on Task(after update){
  new TaskTriggerHandler().updateNumberOfTasks(Trigger.new, Trigger.oldMap);
}

public with sharing class TaskTriggerHandler{
    public void updateNumberOfTasks(List<Task> taskList, Map<Id,Task> taskOldMap){
        Set<Id> conIds = new Set<Id>();
        for(Task task : taskList){
            if(task.WhoId != null && task.WhoId != taskOldMap.get(task.Id).WhoId && task.WhoId.SObjectType == Contact.SObjectType){
                conMap.add(task.WhoId);
            }
        }
        if(taskOldMap.isEmpty()){
            return;
        }
        Map<Id,Contact> conMap = new Map<Id,Contact>([Select Id, NumberOfTasks from Contact where Id IN: conIds]);
        if(conMap.isEmpty()){
            return;
        }
        for(Task task : taskList){
            if(conMap.containsKey(task.WhoId)){
                conMap.get(task.WhoId).NumberOfTasks+=1;
            }
        }
        
            Database.update(conMap.values(),false);
   
    }
}