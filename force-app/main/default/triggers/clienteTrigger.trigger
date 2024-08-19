trigger clienteTrigger on Cliente__c (after insert, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ClienteTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isDelete) {
            ClienteTriggerHandler.handleAfterDelete(Trigger.old);
        }
    }
}