public with sharing class HelloWorld {
    public static void printMessage() {
        String msg = 'Hello World';
        System.debug(msg);   

        List<String> myStrings = new List<String>();
        myStrings.add('String1');
        myStrings.add('String2');
        myStrings.add('String3');

        for (integer x = 0;x<=2; x++) {            
            System.debug(myStrings[x]);
        }

        for(String teste : myStrings){
            System.debug('Testando mystrings ' + teste);
        }

        List<String> tea = new List<String>{'Black Tea', 'Green Tea', 'Chai Tea'};
        for (String t : tea) {
            System.debug('We have' + t);
        }

        // Create a list and add elements to it in one step
        List<String> colors = new List<String> { 'red', 'green', 'blue' };
        // Add elements to a list after it has been created
        List<String> moreColors = new List<String>();
        moreColors.add('orange');
        moreColors.add('purple');

        // Get elements from a list
        String color1 = moreColors.get(0);
        String color2 = moreColors[0];
        System.assertEquals(color1, color2);
        // Iterate over a list to read elements
        for(Integer i=0;i<colors.size();i++) {
            // Write value to the debug log
            System.debug(colors[i]);
        }
          
    }
    public class AccountListExample {
        public List<Account> getAccountList() {
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
}

//HelloWorld.printMessage();