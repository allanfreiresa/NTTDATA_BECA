public with sharing class TestesObjetos {
    public static void creatAccount() {

        //inseri dados na conta
        // Create the account sObject 
        Account acct = new Account(Name='Acme3', Phone='(415)555-1212', NumberOfEmployees=100);
        // Insert the account by using DML
        insert acct;
        // Get the new ID on the inserted sObject argument
        ID acctID = acct.Id;
        // Display this ID in the debug log
        System.debug('ID = ' + acctID);
        // Debug log result (the ID will be different in your case)
        // DEBUG|ID = 001D000000JmKkeIAF 

    }

    public static void creatContacts() {

        // Create a list of contacts
        List<Contact> conList = new List<Contact> {
                new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
                new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
                new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
                new Contact(FirstName='Kim',LastName='Shain',Department='Education')};
        // Bulk insert all contacts with one DML call
        insert conList;

        for(Contact contatos : conList){
            System.debug('Contatos criados: ' + contatos.FirstName + ' ' + contatos.LastName + ' ' + contatos.Department);
        }        
            
        // List to hold the new contacts to update
        List<Contact> listToUpdate = new List<Contact>();
        // Iterate through the list and add a title only
        //   if the department is Finance
        for(Contact con : conList) {
            if (con.Department == 'Finance') {
                con.Title = 'Financial analyst';
                // Add updated contact sObject to the list.
                listToUpdate.add(con);
            }
        }
        // Bulk update all contacts with one DML call
        update listToUpdate;
    }

    public static void createContacts2() {

        // Insert the Josh contact
        Contact josh = new Contact(FirstName='Josh',LastName='Kaplan',Department='Finance');       
        insert josh;

         // Josh's record has been inserted
        //   so the variable josh has now an ID
        //   which will be used to match the records by upsert
        josh.Description = 'Josh\'s record has been updated by the upsert operation.';
        // Create the Kathy contact, but don't persist it in the database
        Contact kathy = new Contact(FirstName='Kathy',LastName='Brown',Department='Technology');
        // List to hold the new contacts to upsert
        List<Contact> contacts = new List<Contact> { josh, kathy };
        // Call upsert
        upsert contacts;
        // Result: Josh is updated and Kathy is created.
    }

    public static void createContacts3() {

        Contact jane = new Contact(FirstName='Jane',
                                LastName='Smith',
                                Email='jane.smith@example.com',
                                Description='Contact of the day');
        insert jane;
        // 1. Upsert using an idLookup field
        // Create a second sObject variable.
        // This variable doesn’t have any ID set.
        Contact jane2 = new Contact(FirstName='Jane',
                                LastName='Smith',  
                                Email='jane.smith@example.com',
                                Description='Prefers to be contacted by email.');
        // Upsert the contact by using the idLookup field for matching.
        upsert jane2 Contact.fields.Email;
        // Verify that the contact has been updated
        System.assertEquals('Prefers to be contacted by email.',
                        [SELECT Description FROM Contact WHERE Id=:jane.Id].Description);
    }

    public static void deleteContacts() {
        // Delete all contacts with the account name of 'Acme'
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Account.Name='Acme'];
        delete contacts;    
    }       

    //Criação de um metodo com Database Insert 
    
    public static void insertAccountsDB() {
       // Create a list of contacts
        List<Contact> conList = new List<Contact> {
            new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
            new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
            new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
            new Contact()};
        // Bulk insert all contacts with one DML call
        Database.SaveResult[] srList = Database.insert(conList, false);
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
            } else {
                // Operation failed, so get all errors
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                }
            }
        }
    }

    public static void insertRelated() {
        Account acct = new Account(Name='SFDC Account');
            insert acct;
            // Once the account is inserted, the sObject will be 
            // populated with an ID.
            // Get this ID.
            ID acctID = acct.ID;
            // Add a contact to this account.
            Contact mario = new Contact(
                FirstName='Mario',
                LastName='Ruiz',
                Phone='415.555.1212',
                AccountId=acctID);
            insert mario;
    }
    public static void updateAccount(){

            // Query for the contact, which has been associated with an account.
            Contact queriedContact = [SELECT Account.Name 
            FROM Contact 
            WHERE FirstName = 'Mario' AND LastName='Ruiz'
            LIMIT 1];
            // Update the contact's phone number
            queriedContact.Phone = '(415)555-1213';
            // Update the related account industry
            queriedContact.Account.Industry = 'Technology';
            // Make two separate calls 
            // 1. This call is to update the contact's phone.
            update queriedContact;
            // 2. This call is to update the related account's Industry field.
            update queriedContact.Account; 
        
    }

    public static void deleteAccount(){
        Account[] queriedAccounts = [SELECT Id FROM Account WHERE Name='SFDC Account'];
        delete queriedAccounts;
    }
}

//TestesObjetos.creatAccount();
//TestesObjetos.creatContacts();
//TestesObjetos.createContacts2();
//TestesObjetos.createContacts3();
//TestesObjetos.deleteContacts();
//TestesObjetos.insertAccountsDB();
//TestesObjetos.insertRelated(); 
//TestesObjetos.updateAccount();
//TestesObjetos.deleteAccount();

