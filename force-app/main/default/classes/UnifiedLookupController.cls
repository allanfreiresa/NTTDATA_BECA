public with sharing class UnifiedLookupController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> searchRecords(String searchTerm) {
        String query = '%' + searchTerm + '%';

        List<Map<String, Object>> results = new List<Map<String, Object>>();

        for (Account acc : [SELECT Id, Name FROM Account WHERE Name LIKE :query LIMIT 10]) {
            results.add(new Map<String, Object>{'Id' => acc.Id, 'Name' => acc.Name, 'ObjectType' => 'Account'});
        }

        for (Contact con : [SELECT Id, Name, Email, AccountId, Account.Name FROM Contact WHERE Name LIKE :query LIMIT 10]) {
            results.add(new Map<String, Object>{'Id' => con.Id, 'Name' => con.Name, 'Email' => con.Email, 'AccountId' => con.AccountId, 'AccountName' => con.Account.Name, 'ObjectType' => 'Contact'});
        }

        for (Lead lead : [SELECT Id, Name, Email, Company FROM Lead WHERE Name LIKE :query LIMIT 10]) {
            results.add(new Map<String, Object>{'Id' => lead.Id, 'Name' => lead.Name, 'Email' => lead.Email, 'Company' => lead.Company, 'ObjectType' => 'Lead'});
        }

        return results;
    }
}
