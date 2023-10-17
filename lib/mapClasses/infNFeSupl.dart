class infNFeSupl {
  String qrCode;
  String urlChave;




  infNFeSupl(
      {required this.qrCode,
        required this.urlChave,

      });

  factory infNFeSupl.fromJson(Map<String, dynamic> json) => infNFeSupl(
    qrCode: json["qrCode"],
    urlChave: json["urlChave"],
  );
}

