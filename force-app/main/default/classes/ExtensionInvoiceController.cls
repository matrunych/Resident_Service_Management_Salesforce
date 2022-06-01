public class ExtensionInvoiceController {
    
    private final Resident_Invoice__c resInvoice;
    public Case invoiceCase {get; set;}
    public Contact invoiceContact {get; set;}
    public Account invoiceAccount {get; set;}
     
     
    public ExtensionInvoiceController
		(ApexPages.StandardController stdController) {
            stdController.addFields(new List<String>{'Id', 'Name', 'Subject__c', 'Resident__c', 'Invoice_Due_Date__c'});
        	this.resInvoice =(Resident_Invoice__c)stdController.getRecord();
            
            invoiceContact = [SELECT Id, Name, Phone, Email, AccountId FROM Contact WHERE Id = :resInvoice.Resident__c][0];
            invoiceAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry 
                              FROM Account WHERE Id =: invoiceContact.AccountId];

                           
    }

    public void saveNew(){        
        String invName = resInvoice.Name;
        String fileName = 'Invoice_' + invName + '.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + fileName);   
    }
    
}