public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
      return [SELECT Id, Name, Phone FROM Account];
    }
  
    @AuraEnabled
    public static void saveAccount(String name, String phone) {
      Account newAccount = new Account(Name=name, Phone=phone);
      insert newAccount;
    }
  }

//Criacao dos componentes
//sfdx force:lightning:component:create --type lwc --componentname accountList --outputdir force-app/main/default/lwc
//sfdx force:lightning:component:create --type lwc --componentname accountForm --outputdir force-app/main/default/lwc
