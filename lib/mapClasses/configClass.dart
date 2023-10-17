class configClass {
  String hostname;
  String CNPJ;
  String comExterna;
  String codEmpresa;
  String chaveExterna;
  String tefIp;
  String tipoComunic;
  bool comunicaWeb;


  configClass(
      {required this.hostname,
        required this.CNPJ,
        required  this.comExterna,
        required  this.codEmpresa,
        required this.chaveExterna,
        required this.tefIp,
        required this.tipoComunic,
        required this.comunicaWeb});

  factory configClass.fromJson(Map<String, dynamic> json) => configClass(
    hostname: json["hostname"],
    CNPJ: json["CNPJ"],
    comExterna: json["comExterna"],
    codEmpresa: json["codEmpresa"],
    chaveExterna: json["chaveExterna"],
      tefIp:json["tefIp"],
      tipoComunic:json["tipoComunic"],
      comunicaWeb:json["comunicaWeb"]

  );
}
