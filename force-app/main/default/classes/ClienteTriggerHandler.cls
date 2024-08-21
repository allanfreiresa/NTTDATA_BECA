public class ClienteTriggerHandler {
    // Define o Bearer Token (normalmente você obteria isso de um armazenamento seguro)
    public static String token = 'patsES68vUcmeLrjj.cca4e57aa1a68c7df0be28e88db3a9f7abf43a70eae48558db0b535f8e21313a';
    public static String workspaceId = 'appcdvYADPGDYd6jy';
    
    // Método handler que prepara os dados e chama o método future o
    public static void handleAfterInsert(List<Cliente__c> clientes) {
        // Cria um mapa de CPFs para IDs dos clientes inseridos
        Map<Id, String> clienteIdCpfMap = new Map<Id, String>();
        for (Cliente__c cliente : clientes) {
            clienteIdCpfMap.put(cliente.Id, cliente.CPF__c);
        }
        
        // Chama o método future para fazer a requisição HTTP GET de forma assíncrona
        makeHttpGetRequestAsync(clienteIdCpfMap);
    }

    // Método handler que prepara os dados e chama o método future para deletions
    public static void handleAfterDelete(List<Cliente__c> clientes) {
        // Cria um mapa de Id Externo para IDs dos clientes deletados
        Map<Id, String> clienteIdExternoMap = new Map<Id, String>();
        for (Cliente__c cliente : clientes) {
            clienteIdExternoMap.put(cliente.Id, cliente.IdExterno__c);
        }
        
        // Chama o método future para fazer a requisição HTTP DELETE de forma assíncrona
        makeHttpDeleteRequestAsync(clienteIdExternoMap);
    }
    
    // Método future que faz a requisição HTTP GET
    @future(callout=true)
    public static void makeHttpGetRequestAsync(Map<Id, String> clienteIdCpfMap) {

        // Define a URL para a requisição GET
        String url = 'https://api.airtable.com/v0/'+workspaceId+'/Cliente';
        
        // Cria a requisição HTTP
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token);
        
        // Cria um objeto HTTP para enviar a requisição
        Http http = new Http();
        
        // Tenta enviar a requisição e captura a resposta
        try {
            HttpResponse res = http.send(req);
            
            // Verifica o status da resposta
            if (res.getStatusCode() == 200) {
                // Processa a resposta JSON
                ClienteModel response = ClienteModel.parse(res.getBody());
                System.debug('Http Response => ' + response);
                
                // Lista para armazenar clientes a serem atualizados
                List<Cliente__c> clientesParaAtualizar = new List<Cliente__c>();
                
                // Procura os clientes inseridos na resposta com base no CPF
                for (ClienteModel.Record record : response.records) {
                    for (Id clienteId : clienteIdCpfMap.keySet()) {
                        if (clienteIdCpfMap.get(clienteId).equals(record.fields.CPF)) {
                            // Cria um novo registro Cliente__c para atualização
                            Cliente__c clienteAtual = new Cliente__c(
                                Id = clienteId,
                                Sobrenome__c = record.fields.Sobrenome,
                                Estado__c = record.fields.Estado,
                                Endereco__c = record.fields.Endereco,
                                Cidade__c = record.fields.Cidade,
                                Nome__c = record.fields.Nome,
                                CPF__c = record.fields.CPF,
                                Estado_Civil__c = record.fields.EstadoCivil,
                                idExterno__c = record.id
                            );
                            clientesParaAtualizar.add(clienteAtual);
                        }
                    }
                }
                
                // Atualiza os registros no Salesforce
                if (!clientesParaAtualizar.isEmpty()) {
                    update clientesParaAtualizar;
                }
            } else {
                System.debug('Failed with status code: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }

    // Método future que faz a requisição HTTP DELETE
    @future(callout=true)
    public static void makeHttpDeleteRequestAsync(Map<Id, String> clienteIdExternoMap) {
        
        // Define a URL base para a requisição DELETE
        String urlBase = 'https://api.airtable.com/v0/'+workspaceId+'/cliente/';
        
        // Cria um objeto HTTP para enviar a requisição
        Http http = new Http();
        
        // Itera sobre os registros para deletar
        for (String idExterno : clienteIdExternoMap.values()) {
            String url = urlBase + idExterno;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('DELETE');
            req.setHeader('Authorization', 'Bearer ' + token);
            
            // Tenta enviar a requisição e captura a resposta
            try {
                HttpResponse res = http.send(req);
                
                // Verifica o status da resposta
                if (res.getStatusCode() == 200) {
                    System.debug('Cliente deletado com sucesso: ' + idExterno);
                } else {
                    System.debug('Failed with status code: ' + res.getStatusCode());
                }
            } catch (Exception e) {
                System.debug('Error: ' + e.getMessage());
            }
        }
    }
}