class enderEmit {
  String xLgr;
  String nro;
  String xBairro;
  String cMun;
  String xMun;
  String UF;
  String CEP;
  String cPais;
  String xPais;
  String fone;


  enderEmit(
      {required this.CEP,
        required this.cMun,
        required this.cPais,
        required this.fone,
        required this.nro,
        required this.UF,
        required  this.xBairro,
        required this.xLgr,
        required this.xMun,
        required this.xPais
      });

  factory enderEmit.fromJson(Map<String, dynamic> json) => enderEmit(
    CEP: json["CEP"],
    cMun: json["cMun"],
    cPais: json["cPais"],
    fone: json["fone"],
    nro: json["nro"],
    UF: json["UF"],
    xBairro: json["xBairro"],
    xLgr: json["xLgr"],
    xMun: json["xMun"],
    xPais: json["xPais"],

  );
}

