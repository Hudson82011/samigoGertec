class ProdsCart {
  String NUM_COMANDA;
  String COD_PROD;
  String DESCRICAO;
  String FLG_UNIDADE_VENDA;
  String VLR_PRECO;
  String VLR_QTDE;
  String VLR_TOTAL;
  String VLR_DESCONTO;
  String VLR_ACRESCIMO;
  String DOCUMENTO;
  String COD_VEND;
  String BARRAS;


  ProdsCart(
      {required this.COD_PROD,
        required this.DESCRICAO,
        required this.FLG_UNIDADE_VENDA,
        required this.VLR_PRECO,
        required this.VLR_QTDE,
        required this.VLR_TOTAL,
      required this.VLR_ACRESCIMO,
        required this.VLR_DESCONTO,
        required this.NUM_COMANDA,
        required this.DOCUMENTO,
        required this.COD_VEND,
        required this.BARRAS

      });

  factory ProdsCart.fromJson(Map<dynamic, dynamic> json) => ProdsCart(
      COD_PROD: json["COD_PROD"]??"",
      DESCRICAO: json["DESCRICAO"]??"",
      FLG_UNIDADE_VENDA: json["FLG_UNIDADE_VENDA"]??"",
      VLR_PRECO: json["VLR_PRECO"]??"",
      VLR_QTDE: json["VLR_QTDE"]??"",
      VLR_TOTAL:json["VLR_TOTAL"]??"",
      VLR_ACRESCIMO:json["VLR_ACRESCIMO"]??"",
      VLR_DESCONTO:json["VLR_DESCONTO"]??"",
      NUM_COMANDA: json["CMD_NUM"]??"",
    DOCUMENTO: json["DOCUMENTO"]??"",
      COD_VEND:json["COD_VEND"]??"",
      BARRAS:json["BARRAS"]??""









  );
}
