global class NotificationSender Implements Schedulable {
    global void execute(SchedulableContext sc) {
        sendNotification();
    }
    
    public void sendNotification(){

        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                    FROM CustomNotificationType 
                                                    WHERE DeveloperName='Invoice_Payment_Notification'];
        
        List<Resident_Invoice__c> invoices = [SELECT Id, Resident__c, Invoice_Due_Date__c FROM Resident_Invoice__c 
                                    WHERE Invoice_Due_Date__c = NEXT_N_DAYS:3];

        Set<Id> resIds = new Set<Id>();
        for(Resident_Invoice__c inv: invoices){
            resIds.add(inv.Resident__c);
        }

        List<User> users = [SELECT Id, Email, ContactId FROM User WHERE ContactId IN :resIds];
        Map<String, String> userIds = new Map<String, String>();
        for(User u: users){
            userIds.put(u.ContactId, u.Id);
        }
       
        for(Resident_Invoice__c inv: invoices){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();


            notification.setTitle('Invoice is still not paid.');
            notification.setBody('It seems that you have some unpaid invoices. Please make payments on time.');
            notification.setNotificationTypeId(notificationType.Id);

            notification.setTargetId(inv.Id);
            notification.send(new Set<String>{userIds.get(inv.Resident__c)});

        }

    }
}