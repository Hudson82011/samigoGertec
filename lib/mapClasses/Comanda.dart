class Comanda {

  String DOCUMENTO;
  String NUM_COMANDA;
  String DATA;
  String HORA;
  String QtdeItens;
  String Total;
  String MESA;
  String CONTATO;




  Comanda( {
    required this.DOCUMENTO,required this.NUM_COMANDA,required this.DATA,required this.HORA,required this.QtdeItens,required this.Total, required this.MESA,required this.CONTATO
  });

  factory Comanda.fromJson(Map<String, dynamic> json) => Comanda(
      DOCUMENTO: json["DOCUMENTO"],
      NUM_COMANDA: json["NUM_COMANDA"],
      DATA:json ["DATA"].toString(),
      HORA: json ["HORA"].toString(),
      QtdeItens:json["QtdeItens"],
      Total:json["Total"],
      MESA:json["MESA"]??"0",
      CONTATO:json["CONTATO"]??""

  );
}

