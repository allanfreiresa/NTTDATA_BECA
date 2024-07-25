trigger HelloWorldTrigger on Account (before insert, after insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            AccountBO.updateDescription(Trigger.new);
        }
        when AFTER_INSERT {
         //Execução apos inserir
        }
    }
}