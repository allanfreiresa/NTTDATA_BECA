public with sharing class AccountListExample {
    public static List<Account> getAccountList() {
        // Consulta SOQL para buscar as contas
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        
        // Criar uma nova lista para armazenar as contas
        List<Account> accountList = new List<Account>();
        
        // Loop for para iterar sobre as contas retornadas pela consulta
        for (Account acc : accounts) {
            // Adicionar cada conta na lista accountList
            accountList.add(acc);
        }
        
        // Retornar a lista de contas
        return accountList;
    }
}

//AccountListExample conta = new AccountListExample();
//conta.getAccountList();
//AccountListExample.getAccountList();