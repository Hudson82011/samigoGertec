class Search_t {
  /*String COD_PROD;
  String DESCRICAO;
  String FLG_UNIDADE_VENDA;
  String VLR_PRECO;
  List obs;
  String CODIGO_BARRAS;
  String COD_CATEGORIA;*/
  String cod_prod;
  String descricao;
  String flg_unidade_venda;
  String vlr_preco;
  String codigo_barras;
  String cod_categoria;
  String cod_depart;
  String cod_subdepart;
  String cat_descricao;

  Search_t(
      {
      /*this.COD_PROD, this.DESCRICAO, this.FLG_UNIDADE_VENDA, this.VLR_PRECO, this.obs, this.CODIGO_BARRAS,this.COD_CATEGORIA*/
        required   this.vlr_preco,
        required this.flg_unidade_venda,
        required    this.descricao,
        required  this.cod_prod,
        required  this.cod_categoria,
        required  this.codigo_barras,
        required this.cat_descricao,
        required  this.cod_depart,
      required this.cod_subdepart});

  factory Search_t.fromJson(Map<dynamic, dynamic> json) => Search_t(
      cod_prod: json["cod_prod"]??"",
      descricao: json["descricao"]??"",
      flg_unidade_venda: json["flg_unidade_venda"]??"",
      vlr_preco: json["vlr_preco"]??"",
      codigo_barras: json["codigo_barras"]??"",
      cod_categoria: json["cod_categoria"]??"",
      cod_depart: json["cod_depart"]??"",
      cod_subdepart: json["cod_subdepart"]??"",
      cat_descricao: json["cat_descricao"]??"");
}
