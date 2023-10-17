class TEFReturn {
  final String? COD_AUTORIZACAO;
  final String? VIA_ESTABELECIMENTO;
  final String? COMP_DADOS_CONF;
  final String? BANDEIRA;
  final String? NUM_PARC;
  final String? RELATORIO;
  final String? REDE_AUT;
  final String? NSU_SITEF;
  final String? VIA_CLIENTE;
  final String? TIPO_PARC;
  final String? CODRESP;
  final String? NSU_HOST;
  final String? TIPO_CAMPOS;

  TEFReturn(
      this.COD_AUTORIZACAO,
      this.VIA_ESTABELECIMENTO,
      this.COMP_DADOS_CONF,
      this.BANDEIRA,
      this.NUM_PARC,
      this.RELATORIO,
      this.REDE_AUT,
      this.NSU_SITEF,
      this.VIA_CLIENTE,
      this.TIPO_PARC,
      this.CODRESP,
      this.NSU_HOST,this.TIPO_CAMPOS);

  TEFReturn._(
      this.COD_AUTORIZACAO,
      this.VIA_ESTABELECIMENTO,
      this.COMP_DADOS_CONF,
      this.BANDEIRA,
      this.NUM_PARC,
      this.RELATORIO,
      this.REDE_AUT,
      this.NSU_SITEF,
      this.VIA_CLIENTE,
      this.TIPO_PARC,
      this.CODRESP,
      this.NSU_HOST,this.TIPO_CAMPOS);

  factory TEFReturn.fromJson(Map<String, dynamic> json) {
    return TEFReturn._(
        json['COD_AUTORIZACAO'],
        json['VIA_ESTABELECIMENTO'],
        json['COMP_DADOS_CONF'],
        json['BANDEIRA'],
        json['NUM_PARC'],
        json['RELATORIO'],
        json['REDE_AUT'],
        json['NSU_SITEF'],
        json['VIA_CLIENTE'],
        json['TIPO_PARC'],
        json['CODRESP'],
        json['NSU_HOST'],
        json['TIPO_CAMPOS']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COD_AUTORIZACAO'] =  this.COD_AUTORIZACAO;
     data['VIA_ESTABELECIMENTO'] =  this.VIA_ESTABELECIMENTO;
    data['COMP_DADOS_CONF'] =  this.COMP_DADOS_CONF;
    data['BANDEIRA'] =  this.BANDEIRA;
    data['NUM_PARC'] =   this.NUM_PARC;
    data['RELATORIO'] =   this.RELATORIO;
    data['REDE_AUT'] =  this.REDE_AUT;
    data['NSU_SITEF'] =  this.NSU_SITEF;
    data['VIA_CLIENTE'] =  this.VIA_CLIENTE;
    data['TIPO_PARC'] =   this.TIPO_PARC;
    data['CODRESP'] =  this.CODRESP;
    data['NSU_HOST'] =  this.NSU_HOST;
    data['TIPO_CAMPOS']=this.TIPO_CAMPOS;
    return data;
  }

}
