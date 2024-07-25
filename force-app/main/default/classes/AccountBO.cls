public with sharing class AccountBO {
    public static void updateDescription(List<Account> accountList) {
        for(Account acc : accountList) {
           acc.Description = 'Description Beca Teste';
        }
    }
  
}