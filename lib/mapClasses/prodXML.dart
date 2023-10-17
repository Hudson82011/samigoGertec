class ProdXML {
  String cProd;
  String cEAN;
  String xProd;
  String NCM;
  String CEST;
  String CFOP;
  String uCom;
  String qCom;
  String vUnCom;
  String vProd;
  String cEANTrib;
  String uTrib;
  String qTrib;
  String vUnTrib;
  String indTot;


  ProdXML({
     required this.cProd,
    required  this.cEAN,
    required this.xProd,
    required this.NCM,
    required this.CEST,
    required this.CFOP,
    required this.uCom,
    required this.qCom,
    required this.vUnCom,
    required this.vProd,
    required this.cEANTrib,
    required this.uTrib,
    required this.qTrib,
    required this.vUnTrib,
    required this.indTot});

  factory ProdXML.fromJson(Map<String, dynamic> json) => ProdXML(
    cProd: json["cProd"],
    cEAN: json["cEAN"],
    xProd: json["xProd"],
    NCM: json["NCM"],
    CEST: json["CEST"],
    CFOP: json["CFOP"],
    uCom: json["uCom"],
    qCom: json["qCom"],
    vUnCom: json["vUnCom"],
    vProd: json["vProd"],
    cEANTrib: json["cEANTrib"],
    uTrib: json["uTrib"],
    qTrib: json["qTrib"],
    vUnTrib: json["vUnTrib"],
    indTot: json["indTot"],



  );
}

