public class ClienteModel {
    public List<Record> records { get; set; }

    public class Record {
        public String id { get; set; }
        public String createdTime { get; set; }
        public Fields fields { get; set; }
    }

    public class Fields {
        public String Sobrenome { get; set; }
        public String Estado { get; set; }
        public String Endereco { get; set; }
        public String Cidade { get; set; }
        public String Nome { get; set; }
        public Integer Codigo { get; set; }
        public String CPF { get; set; }
        public String EstadoCivil { get; set; }
    }

    // Método para fazer o parse do JSON para a classe de modelo ok
    public static ClienteModel parse(String jsonString) {
        return (ClienteModel) JSON.deserialize(jsonString, ClienteModel.class);
    }
}