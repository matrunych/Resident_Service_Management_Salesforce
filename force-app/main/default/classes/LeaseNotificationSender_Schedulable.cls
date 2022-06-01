global class LeaseNotificationSender_Schedulable Implements Schedulable {
    global void execute(SchedulableContext sc) {
        sendNotification();
    }
    
    public void sendNotification(){

        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                    FROM CustomNotificationType 
                                                    WHERE DeveloperName='Invoice_Payment_Notification'];
        
        List<Lease__c> leases = [SELECT Id, End_Date__c FROM Lease__c 
                                    WHERE End_Date__c = NEXT_N_DAYS:30];

        List<PermissionSetAssignment> assignees = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name= 'FSL_Admin_Permissions' or  PermissionSet.Name= 'FSL_Dispatcher_Permissions']; 
        Set<Id> assigneeIds = new Set<Id>();
        for(PermissionSetAssignment psa: assignees){
            assigneeIds.add(psa.AssigneeId);
        }
        Map<String, User> users = new Map<String, User>([SELECT Id, Email FROM User WHERE Id IN :assigneeIds]);
       
        for(Lease__c l: leases){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    
            notification.setTitle('Lease will soon expire!');
            notification.setBody('It seems that lease will expire in 30 days.');
                
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(l.Id);
            notification.send(users.keySet());
        }

    }
}