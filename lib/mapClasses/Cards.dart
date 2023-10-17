
class Cards {
  int id;
  String cnpj;
  int id_bandeira;
  String nome;
  String tipo_cartao;
  int ordem;
  String chk_ativo;
  int id_imagem;


  Cards({
      required this.id,
    required this.cnpj,
    required this.id_bandeira,
    required this.nome,
    required this.tipo_cartao,
    required this.ordem,
    required this.chk_ativo,
    required this.id_imagem
  });

  factory Cards.fromJson(Map<String, dynamic> json) => Cards(
    id: json["id"]??0,
    cnpj: json["cnpj"]??"",
    id_bandeira: json["id_bandeira"]??0,
    nome: json["nome"]??"",
    tipo_cartao: json["tipo_cartao"]??"",
    ordem: json["ordem"]??0,
    chk_ativo: json["chk_ativo"]??"",
      id_imagem:json["id_imagem"]??0

  );
}

