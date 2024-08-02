public with sharing class LookupController {

    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {
        String query = '%' + searchTerm + '%';
        return [SELECT Id, Name FROM Account WHERE Name LIKE :query LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccountId(Id accountId) {
        return [SELECT Id, Name, Email FROM Contact WHERE AccountId = :accountId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String accountId, String searchTerm) {
        String query = '%' + searchTerm + '%';
        return [SELECT Id, Name FROM Contact WHERE AccountId = :accountId AND Name LIKE :query LIMIT 10];
    }
}

