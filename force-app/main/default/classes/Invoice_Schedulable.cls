global class Invoice_Schedulable Implements Schedulable {
    global void execute(SchedulableContext sc) {
        createInvoice();
    }
    
    public void createInvoice(){
        List<Resident_Invoice__c> invoices = new List<Resident_Invoice__c>();
        List<Lease__c> listLeases = [SELECT ID, Resident__c, Property__c, Property__r.Name, Rent_Price__c, Start_Date__c, End_Date__c 
                       FROM Lease__c 
                       WHERE Start_Date__c <= TODAY 
                       AND End_Date__c >= TODAY];

        Date dToday = Date.today();
        String dateStr = dToday.year() + '/' + dToday.month() + '/' + dToday.day();


        for(Lease__c l: listLeases){
            Resident_Invoice__c rentInvoice = new Resident_Invoice__c(Invoice_Date__c=dToday,
                                                                 Resident__c=l.Resident__c,
                                                                 Total__c=l.Rent_Price__c,
                                                                 Reason__c='Rent payment',
                                                                 Subject__c='Rent payment '  + l.Property__r.Name + ' ' + dateStr);
            invoices.add(rentInvoice);
        }
        Database.insert(invoices, false);
    }
}