public class AccountTriggerHandler {
   
    public static void onBeforeInsert(List<Account> newAccountList, Map<Id,Account> newAccountMap) {
        for ( Account newAccount : newAccountList) {
            if(newAccount.Phone == Null) {
                newAccount.addError('Favor informar o telefone');
            }else if (newAccount.Phone.length() < 11){
                newAccount.addError('Favor informar o telefone com DDD');
            }else{
                AccountTriggerHelper.formatPhone(newAccount);
            }
        }

    }
}