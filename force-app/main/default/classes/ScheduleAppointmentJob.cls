public class ScheduleAppointmentJob implements Queueable {
     private List<ServiceAppointment> objs;
     public FSL__Scheduling_Policy__c sp = [SELECT Id, Name from FSL__Scheduling_Policy__c WHERE Name = 'Customer First' LIMIT 1];

     
     public QueueClass1(List<ServiceAppointment> recs) {
                   this.objs = recs;
     }
     
      public void execute(QueueableContext recs) {
          for(SObject sa: recs){           
              FSL.ScheduleResult myResult = new FSL.ScheduleResult();
   
               myResult = FSL.ScheduleService.schedule(sp.Id, sa.Id);
          }
          System.enqueueJob(new QueueClass2(recs));
      }

}
