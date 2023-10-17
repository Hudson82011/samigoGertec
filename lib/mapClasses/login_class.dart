class Login {
  String cod_func;
  String nome;
  String ID_SENHA;
  String COD_LOJA;
  String CODIGO;
  String COD_AUTORIZACAO;
  String SENHA;
  String FLG_ORIGEM;
  String CHK_EXCLUIR_ITEM;
  String CHK_EXCLUIR_NOTA;
  String CHK_CAIXA;
  String CHK_LIMITE_CLIENTE;
  String CHK_PRECO_PRODUTO;
  String CHK_EXCLUIR_REGISTROS;
  String CHK_SANGRIAS;
  String CHK_ROT_FISCAIS;
  String CHK_DESCONTOS;
  String CHK_FISCAL;
  String CHK_VENDAS;
  String ACESSOPREAT;
  String CHK_RESTRICAO;

  Login(
      {required this.cod_func,
        required  this.nome,
        required   this.ID_SENHA,
        required  this.COD_LOJA,
        required  this.CODIGO,
        required  this.COD_AUTORIZACAO,
        required  this.SENHA,
        required  this.FLG_ORIGEM,
        required  this.CHK_EXCLUIR_ITEM,
        required  this.CHK_EXCLUIR_NOTA,
        required  this.CHK_CAIXA,
        required    this.CHK_LIMITE_CLIENTE,
        required this.CHK_PRECO_PRODUTO,
        required   this.CHK_EXCLUIR_REGISTROS,
        required    this.CHK_SANGRIAS,
        required  this.CHK_ROT_FISCAIS,
        required this.CHK_DESCONTOS,
        required  this.CHK_FISCAL,
        required this.CHK_VENDAS,
        required  this.ACESSOPREAT,
        required  this.CHK_RESTRICAO});

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    cod_func: json["cod_func"],
    nome: json["nome"],
    ID_SENHA: json["ID_SENHA"],
    COD_LOJA: json["COD_LOJA"],
    CODIGO: json["CODIGO"],
    COD_AUTORIZACAO: json["COD_AUTORIZACAO"],
    SENHA: json["SENHA"],
    FLG_ORIGEM: json["FLG_ORIGEM"],
    CHK_EXCLUIR_ITEM: json["CHK_EXCLUIR_ITEM"],
    CHK_EXCLUIR_NOTA: json["CHK_EXCLUIR_NOTA"],
    CHK_CAIXA: json["CHK_CAIXA"],
    CHK_LIMITE_CLIENTE: json["CHK_LIMITE_CLIENTE"],
    CHK_PRECO_PRODUTO: json["CHK_PRECO_PRODUTO"],
    CHK_EXCLUIR_REGISTROS: json["CHK_EXCLUIR_REGISTROS"],
    CHK_SANGRIAS: json["CHK_SANGRIAS"],
    CHK_ROT_FISCAIS: json["CHK_ROT_FISCAIS"],
    CHK_DESCONTOS: json["CHK_DESCONTOS"],
    CHK_FISCAL: json["CHK_FISCAL"],
    CHK_VENDAS: json["CHK_VENDAS"],
    ACESSOPREAT: json["ACESSOPREAT"],
    CHK_RESTRICAO: json["CHK_RESTRICAO"],
  );
}
