trigger TaskTrigger on Task(before delete){
    new TaskTriggerHandler().beforeDelete(Trigger.old);
}
public without sharing class TaskTriggerHandler{
    public void beforeDelete(List<Task> taskList){
        Profile userProfile = [Select Id, Name from Profile where Id = UserInfo.getProfileId() limit 1];
        for(Task task: taskList){
            if(userProfile.Name!='System Administrator'){
                task.addError('You cannot delete task as you dont have enough permissions');
            }
        }
    }
}