trigger Conta on Account (after update) {

//Trigger.new => São os registros que os usuarios estão atualizando  para ter ação neles
//Trigger.old => É como esses registros estão no banco de dados

List<Contact> listaContatos = new List<Contact>();

    for(Account acc : Trigger.new){
        if(acc.Site != null){
            List<Contact> lista = [SELECT Id, Department FROM Contact WHERE AccountId = : acc.Id];
            for(Contact ct: lista){
                ct.Department = acc.Site;
                listaContatos.add(ct);
            }
        }
    }
    update listaContatos;

}