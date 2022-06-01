trigger InvoiceTrigger on Resident_Invoice__c (before insert) {   
    Set<Integer> monthSet = new Set<Integer>();
    Set<Integer> yearSet = new Set<Integer>();
    Set<Id> cases = new Set<Id>();
    Set<Id> existingCases = new Set<Id>();

    for(Resident_Invoice__c invoice: Trigger.New){
        if (invoice.Reason__c == 'Rent Payment'){
           
            monthSet.add(invoice.Invoice_Date__c.month());
            yearSet.add(invoice.Invoice_Date__c.year());
        } else {
            cases.add(invoice.Case__c);
        }
        
    }

    if (monthSet.size() > 0){
        List<Resident_Invoice__c> existInvoices = [SELECT Id, Invoice_Date__c 
                                                    FROM Resident_Invoice__c
                                                    WHERE Reason__c = 'Rent Payment'
                                                    AND CALENDAR_MONTH(Invoice_Date__c) IN: monthSet
                                                    AND CALENDAR_YEAR(Invoice_Date__c) IN :yearSet];

        for(Resident_Invoice__c newInvoice: Trigger.New){
            for(Resident_Invoice__c exist: existInvoices){
                if(newInvoice.Invoice_Date__c.month() == exist.Invoice_Date__c.month() && newInvoice.Invoice_Date__c.year() == exist.Invoice_Date__c.year()){
                newInvoice.addError('Invoice for rent for already exist');
                }
            }
        }
    } else {
            List<Resident_Invoice__c> invoices = [SELECT Id, Case__c 
                                                    FROM Resident_Invoice__c 
                                                    WHERE Case__c IN: cases];
            for(Resident_Invoice__c inv: invoices){
                existingCases.add(inv.Case__c);
            }
            for(Resident_Invoice__c invoice: Trigger.New){
                if(existingCases.contains(invoice.Case__c)){
                    invoice.addError('Invoice for this case already exist');
            }
        
        }
    }
    
}