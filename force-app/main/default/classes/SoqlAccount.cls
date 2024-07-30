public with sharing class SoqlAccount {
    public static void geraSoqlAccount() {

        List<Account> accounts = [SELECT Id, Name, Phone FROM Account];
            for (Account acc : accounts) {
                System.debug('Account Name: ' + acc.Name);
            }

            AggregateResult[] results = [SELECT COUNT(Id) totalAccounts FROM Account];
            Integer total = (Integer)results[0].get('totalAccounts');
            System.debug('Total Accounts: ' + total);
            
        List<Account> accounts2 = [SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account];
            for (Account acc2 : accounts2) {
                System.debug('Account Name2: ' + acc2.Name);
                for (Contact con : acc2.Contacts) {
                    System.debug('Contact Name2: ' + con.FirstName + ' ' + con.LastName);
                }
            }

        //String query = 'SELECT Id, Name, Phone FROM Account WHERE Name LIKE \'Acme%\' ORDER BY Name LIMIT 10';
        String query = 'SELECT Id, Name, Phone FROM Account  ORDER BY Name LIMIT 10';
        List<Account> accounts3 = Database.query(query);
        for (Account acc3 : accounts3) {
            System.debug('Account Name3: ' + acc3.Name);
        }


    }
}

//SoqlAccount.geraSoqlAccount();


