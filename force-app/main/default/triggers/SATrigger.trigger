trigger SATrigger on ServiceAppointment (after insert, after update) {
    if (Trigger.isUpdate){
        Set<Id> caseIds = new Set<Id>();
        List<Resident_Invoice__c> saInvoices = new List<Resident_Invoice__c>();
        
        for(ServiceAppointment sa: Trigger.New){
            if(sa.Case__c != null){
                caseIds.add(sa.Case__c);
            }
        }
        
        Map<Id,Case> caseMap = new Map<Id,Case> ([SELECT Id, Price__c, Status 
                                                    FROM Case WHERE Id IN :caseIds]);
        
        for(ServiceAppointment sa: Trigger.New){
            if(sa.Case__c != null){
                caseMap.get(sa.Case__c).Price__c = sa.Price__c;
                if(sa.Case__c != null){
                    caseMap.get(sa.Case__c).Price__c = sa.Price__c;
                    caseMap.get(sa.Case__c).Scheduled_Start__c = sa.SchedStartTime;
                    caseMap.get(sa.Case__c).Scheduled_End__c = sa.SchedEndTime;
                    if(sa.Status == 'Scheduled' || sa.Status == 'Dispatched' || sa.Status == 'In Progress'){
                        caseMap.get(sa.Case__c).Status = 'In Progress';
                    } else if (sa.Status == 'Cannot Complete' || sa.Status == 'Canceled' ) {
                        caseMap.get(sa.Case__c).Status = 'Closed';
                    } else if (sa.Status == 'Completed'){
                        caseMap.get(sa.Case__c).Status = 'Completed';
                    }
                }
            }
            if(sa.Status == 'Completed'){
                Resident_Invoice__c invoice = new Resident_Invoice__c(Invoice_Date__c=Date.today(),
                                                                    Resident__c=sa.ContactId,
                                                                    Total__c=sa.Price__c,
                                                                    Case__c=sa.Case__c,
                                                                    Subject__c=sa.Subject);
                saInvoices.add(invoice);
            }
        }
        
        update caseMap.values();
        Database.insert(saInvoices, false);
    }

}