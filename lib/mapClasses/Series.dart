class Series {
  String? id;
  String? codCli;
  String? token;
  String? tipoToken;
  String serieNf ="1";
  String? tipoNf;
  String? dataImplantacao;
  String? ultimoDocumento;
  String? chkAtivo;

  Series(
      {this.id,
        this.codCli,
        this.token,
        this.tipoToken,
       required this.serieNf,
        this.tipoNf,
        this.dataImplantacao,
        this.ultimoDocumento,
        this.chkAtivo});

  Series.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codCli = json['cod_cli'];
    token = json['token'];
    tipoToken = json['tipo_token'];
    serieNf = json['serie_nf']??"1";
    tipoNf = json['tipo_nf'];
    dataImplantacao = json['data_implantacao'];
    ultimoDocumento = json['ultimo_documento'];
    chkAtivo = json['chk_ativo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cod_cli'] = this.codCli;
    data['token'] = this.token;
    data['tipo_token'] = this.tipoToken;
    data['serie_nf'] = this.serieNf;
    data['tipo_nf'] = this.tipoNf;
    data['data_implantacao'] = this.dataImplantacao;
    data['ultimo_documento'] = this.ultimoDocumento;
    data['chk_ativo'] = this.chkAtivo;
    return data;
  }
}