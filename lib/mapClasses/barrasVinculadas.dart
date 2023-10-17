

class Barras {
  String codigo_barras;
  String cod_prod;




  Barras(
      { required this.cod_prod,
        required this.codigo_barras,

      });

  factory Barras.fromJson(Map<dynamic, dynamic> json) => Barras(
    cod_prod: json["cod_prod"]??"",
    codigo_barras: json["codigo_barras"]??""


  );
}
