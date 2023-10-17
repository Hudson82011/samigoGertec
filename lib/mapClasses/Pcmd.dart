class Pcmd {
  String COD_PROD;
  String DESCRICAO;
  String FLG_UNIDADE_VENDA;
  String VLR_PRECO;
  String AUTONUM;
  String VLR_QTDE;
  String DOCUMENTO;
  String NUM_COMANDA;
  String DATA;
  String HORA;
  String VLR_PRECO_CMD;
  String ACRESCIMO;
  String MESA;
  String CRE;
  String OBS;
  String VLR_TOTAL;
  String COD_VEND;

  Pcmd(
      {required this.COD_PROD,
        required this.DESCRICAO,
        required this.FLG_UNIDADE_VENDA,
        required this.VLR_PRECO,
        required  this.AUTONUM,
        required this.VLR_QTDE,
        required  this.NUM_COMANDA,
        required  this.HORA,
        required  this.ACRESCIMO,
        required  this.CRE,
        required  this.DATA,
        required this.DOCUMENTO,
        required this.MESA,
        required  this.VLR_PRECO_CMD,
        required this.OBS,
        required   this.VLR_TOTAL,
      required this.COD_VEND
      });

  factory Pcmd.fromJson(Map<dynamic, dynamic> json) => Pcmd(
      COD_PROD: json["COD_PROD"]??"",
      DESCRICAO: json["DESCRICAO"]??"",
      FLG_UNIDADE_VENDA: json["FLG_UNIDADE_VENDA"]??"",
      VLR_PRECO: json["VLR_PRECO"]??"",
      AUTONUM: json["AUTONUM"]??"",
      VLR_QTDE: json["VLR_QTDE"]??"",
      VLR_PRECO_CMD:json["VLR_PRECO_CMD"]??"",
      MESA:json["MESA"]??"",
      DOCUMENTO:json["DOCUMENTO"]??"",
      DATA:json["DATA"]??"",
      CRE:json["CRE"]??"",
      ACRESCIMO:json["ACRESCIMO"]??"",
      HORA:json["HORA"]??"",
      NUM_COMANDA:json["NUM_COMANDA"]??"",
      OBS:json["OBS"]??"",
      VLR_TOTAL:json["VLR_TOTAL"]??"",
      COD_VEND:json["COD_VEND"]??""







  );
}
