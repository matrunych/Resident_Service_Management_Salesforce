global class ScheduleAppointment implements Database.Batchable<sObject>{
    public FSL__Scheduling_Policy__c sp = [SELECT Id, Name from FSL__Scheduling_Policy__c WHERE Name = 'Customer First' LIMIT 1];
 
    public Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator([SELECT Id, Status FROM ServiceAppointment WHERE Status = 'None']);
    }
 
    public void execute(Database.BatchableContext BC, List<sObject> scope){
      
        for(SObject sa: scope){        
           FSL.ScheduleResult myResult = new FSL.ScheduleResult();

            myResult = FSL.ScheduleService.schedule(sp.Id, sa.Id);

           System.debug(myResult);
        }
     }
 
    public void finish(Database.BatchableContext BC){
        System.debug('done');
    }
    
 }
