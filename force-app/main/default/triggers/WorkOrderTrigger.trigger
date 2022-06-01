trigger WorkOrderTrigger on WorkOrder (after insert, after update) {
    Map <  Id,  WorkOrder > mapWorkOrder = Trigger.NewMap;
    List < ServiceAppointment > listSA = new List< ServiceAppointment >();

 
    if(mapWorkOrder.size() > 0){
        listSA = [SELECT Property__C, ParentRecordId, Case__C, Case__r.Price__c, FSL__Auto_Schedule__c FROM ServiceAppointment WHERE ParentRecordId IN: mapWorkOrder.keySet()];
        if(listSA.size() > 0){
            for(ServiceAppointment sa: listSA){
                sa.Property__C = mapWorkOrder.get(sa.ParentRecordId).Property__C;
                sa.Case__C = mapWorkOrder.get(sa.ParentRecordId).CaseId;
                if(Trigger.isInsert){
                    sa.FSL__Auto_Schedule__c = True;
                    sa.FSL__Scheduling_Policy_Used__c = 'a0V7Q000000ZdULUA0';
                }
                
            }
        }
        update listSA;

        }

}