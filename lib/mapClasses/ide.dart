
class emit {
  String CNPJ;
  String xNome;
  String xFant;
  String IE;
  String CRT;


  emit(
      {required this.CNPJ,
        required this.CRT,
        required this.IE,
        required  this.xFant,
        required this.xNome,
        });

  factory emit.fromJson(Map<String, dynamic> json) => emit(
    CNPJ: json["CNPJ"],
    xNome: json["xNome"],
    xFant: json["xFant"],
    IE: json["IE"],
    CRT: json["CRT"],

  );
}

