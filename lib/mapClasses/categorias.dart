

class Categorias {

  String COD_CATEGORIA;
  String DESCRICAO;
  String ORDEM;
  String CHK_ATIVO;
  dynamic IMAGEM_BASE64;



  Categorias({
    required this.COD_CATEGORIA,required this.DESCRICAO,required this.ORDEM,required this.IMAGEM_BASE64,required this.CHK_ATIVO
  });

  factory Categorias.fromJson(Map<dynamic, dynamic> json) => Categorias(
    COD_CATEGORIA: json["COD_CATEGORIA"].toString(),
      DESCRICAO: json["DESCRICAO"].toString(),
    ORDEM: json["ORDEM"].toString(),
    IMAGEM_BASE64:json ["IMAGEM_BASE64"].toString(),
      CHK_ATIVO:json["CHK_ATIVO"].toString()
  );
}

