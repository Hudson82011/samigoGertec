class infProt {
  String tpAmb;
  String verAplic;
  String chNFe;
  String dhRecbto;
  String nProt;
  String digVal;
  String cStat;
  String xMotivo;
  String nNF;
  String serie;



  infProt(
      {required this.chNFe,
        required this.cStat,
        required this.dhRecbto,
        required this.digVal,
        required  this.nProt,
        required  this.tpAmb,
        required this.verAplic,
        required this.xMotivo,
        required this.nNF,
        required this.serie,
      });

  factory infProt.fromJson(Map<String, dynamic> json) => infProt(
    chNFe: json["chNFe"],
    cStat: json["cStat"],
    dhRecbto: json["dhRecbto"],
    digVal: json["digVal"],
    nProt: json["nProt"],
    tpAmb: json["tpAmb"],
    verAplic: json["verAplic"],
    xMotivo: json["xMotivo"],
    nNF :json['nfe'].toString(),
    serie: json['serie']


  );
}

