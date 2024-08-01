public with sharing class TestesSOQL {
   
    public static void inserirSOQL(){
        // Add account and related contact
        Account acct = new Account(
            Name='SFDC Computing',
            Phone='(415)555-1212',
            NumberOfEmployees=50,
            BillingCity='San Francisco');
        insert acct;
        // Once the account is inserted, the sObject will be
        // populated with an ID.
        // Get this ID.
        ID acctID = acct.ID;
        // Add a contact to this account.
        Contact con = new Contact(
            FirstName='Carol',
            LastName='Ruiz',
            Phone='(415)555-1212',
            Department='Wingo',
            AccountId=acctID);
        insert con;
        // Add account with no contact
        Account acct2 = new Account(
            Name='The SFDC Query Man',
            Phone='(310)555-1213',
            NumberOfEmployees=50,
            BillingCity='Los Angeles',
            Description='Expert in wing technologies.');
        insert acct2;
    }

    public static void showResultsSOQL () {

        Account[] accts = [SELECT Name,Phone FROM Account
                        WHERE (Name='SFDC Computing' AND NumberOfEmployees>25)
                        ORDER BY Name
                        LIMIT 10];
        System.debug(accts.size() + ' account(s) returned.');
        // Write all account array info
        System.debug(accts);

    }

    public static void resultsVariableSOQL(){
        String targetDepartment = 'Wingo';
        Contact[] techContacts = [SELECT FirstName,LastName,Department
                          FROM Contact WHERE Department=:targetDepartment];

                          System.debug('Resultado com variavel: ' + techContacts);
    }

    public static void relationSOQL(){
        Account[] acctsWithContacts = [SELECT Name, (SELECT FirstName,LastName FROM Contacts)
                               FROM Account
                               WHERE Name = 'SFDC Computing'];
            // Get child records
            Contact[] cts = acctsWithContacts[0].Contacts;
            System.debug('Name of first associated contact: '
                        + cts[0].FirstName + ', ' + cts[0].LastName);


            for (integer i = 0;i<2;i++){
                System.debug('Lista geral de contatos dessa conta: '
                                + cts[i].FirstName               
                                + ', ' + cts[i].LastName);
            }

            //Você pode percorrer um relacionamento de um objeto filho (contato) a um campo de seu pai (Account.Name) usando a notação de ponto
            Contact[] cts2 = [SELECT Account.Name,FirstName, LastName FROM Contact                
                WHERE Account.Name = 'SFDC Computing'];
            Contact carol = cts2[0];
            String acctName = carol.Account.Name;
            System.debug('Carol\'s account name is ' + acctName + 'Contato: ' + 
                        cts2[0].FirstName + ' - ' + cts2[0].LastName );

            for (Integer i = 0 ; i<2; i++){
                System.debug('Carol\'s account name is ' + cts2[i].Account.Name
                            + 'Contato: ' + cts2[i].FirstName + ' - ' + cts2[i].LastName);
            }

        }

    public static void loteSOQL(){   

        /*    insert new Account[]{new Account(Name = 'for loop 1'),
                            new Account(Name = 'for loop 2'),
                            new Account(Name = 'for loop 3')};
       */
        // The sObject list format executes the for loop once per returned batch
        // of records
        Integer i=0;
        Integer j=0;
        for (Account[] tmp : [SELECT Id, Name FROM Account WHERE Name LIKE 'for loop _' ] ) {
            j = tmp.size();
            System.debug(j);
            i++;
            System.debug(i);
            
            for (Integer n = 0; n < tmp.size();n++){
                System.debug(tmp[n].Name);    
           }
        }
        System.assertEquals(3, j,'The list should have contained the three accounts');
                                // The list should have contained the three accounts
                            // named 'yyy'
        System.assertEquals(1, i,'deveria ter uma conta'); // Since a single batch can hold up to 200 records and,
                            // only three records should have been returned, the
                            // loop should have executed only once
    }


        public static void usingSOSL(){
            String soslFindClause = 'Wingo OR SFDC';
            List<List<sObject>> searchList = [FIND :soslFindClause IN ALL FIELDS
                                RETURNING Account(Name),Contact(FirstName,LastName,Department)];
            Account[] searchAccounts = (Account[])searchList[0];
            Contact[] searchContacts = (Contact[])searchList[1];
            System.debug('Found the following accounts.');
            for (Account a : searchAccounts) {
                System.debug(a.Name);
            }
            System.debug('Found the following contacts.');
            for (Contact c : searchContacts) {
                System.debug(c.LastName + ', ' + c.FirstName);
}        
        }
}
//TestesSOQL.inserirSOQL();
//TestesSOQL.showResultsSOQL();
//TestesSOQL.resultsVariableSOQL();
//TestesSOQL.relationSOQL();
//TestesSOQL.loteSOQL();
//TestesSOQL.usingSOSL();