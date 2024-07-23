trigger AccountTrigger on Account (before insert) {

if(Trigger.OperationType == System.TriggerOperation.BEFORE_INSERT){

    AccountTriggerHandler.onBeforeInsert(Trigger.new, Trigger.newMap);

}

//dessa forma pode dar problema na carga por isso tem que usar a opção de lista
//Account newAccount = Trigger.new[0];

//forma correta sem usar o nova classe AccountTriggerHandler
/*List<Account> newAccountList = Trigger.new;

    for ( Account newAccount : newAccountList) {
        if(newAccount.Phone == Null) {
            newAccount.addError('Favor informar o telefone');
        }else if (newAccount.Phone.length() < 11){
            newAccount.addError('Favor informar o telefone com DDD');
        }
    }
*/

/*if(Trigger.isBefore && Trigger.isInsert){
    for(Account a : newAccountList){
        a.Name = a.Name + ' - ' + a.Id;
    }
}*/

}