public with sharing class LookupController {

    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {
        String query = '%' + searchTerm + '%';
        return [SELECT Id, Name FROM Account WHERE Name LIKE :query LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchTerm) {
        String query = '%' + searchTerm + '%';
        return [SELECT Id, Name, Email, AccountId, Account.Name FROM Contact WHERE Name LIKE :query LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccountId(Id accountId) {
        return [SELECT Id, Name, Email FROM Contact WHERE AccountId = :accountId];
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountByContactId(Id contactId) {
        Contact contact = [SELECT AccountId, Account.Name FROM Contact WHERE Id = :contactId LIMIT 1];
        return [SELECT Id, Name FROM Account WHERE Id = :contact.AccountId LIMIT 1];
    }
}