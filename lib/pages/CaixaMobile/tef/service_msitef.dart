import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sammi_gov2/LocalInfo/EnterpriseConfig.dart';

import '../../../TEF/TEFReturn.dart';
import 'TefPage.dart';

class MSitefService {
  static const _platform =
      const MethodChannel('samples.flutter.dev/gedi');

  static Future<String> _sendFunctionToAndroid(
      Map<String, dynamic> args) async {
    return await _platform.invokeMethod("TEF", {"args": args});
  }

  //Constante que representa um possível erro que o android jogará caso a transação não tenha ocorrido corretamente.
  static const String _ERROR = "transaction_error";

  static Future<TEFReturn?> sendOptionSale(
      {required String enderecoSitef,
      required String valor,
      required FormaPagamento formaPagamento,
      required FormaFinanciamento
          formaFinanciamento, //No caso de uma venda a débito não seŕa necessário passar o tipo de parcelamento..
      required String numParcelas}) async {
    Map<String, dynamic> mapParam = new Map();

    mapParam['opcaoTef'] = TEF.M_SITEF.toString();
    mapParam['acaoTef'] = Acao.VENDA.toString();
    mapParam['enderecoSitef'] = enderecoSitef;
    mapParam['valor'] = valor;
    mapParam['formaPagamento'] = formaPagamento.toString();
    mapParam['formaFinanciamento'] = formaFinanciamento.toString();
    mapParam['numParcelas'] = numParcelas;

    mapParam["comExterna"] = EnterpriseConfig.comExterna;

    mapParam["empresaSitef"] = EnterpriseConfig.empresaSitef;

    mapParam["operador "] = "4";
    mapParam["data"] =  DateFormat("yyyy/MM/dd")
        .format(DateTime.now())
        .toString()
        .replaceAll("/", "");
    mapParam["hora"] = DateFormat("HH:mm:ss")
        .format(DateTime.now())
        .toString()
        .replaceAll(":", "");
    mapParam["numeroCupom"] = randomNumeric(6).toString();
    mapParam["CNPJ_CPF"] = EnterpriseConfig.cnpj;
    mapParam["pinpadMac"] = "00:00:00:00:00";
    mapParam['chaveExterna'] =EnterpriseConfig.vpn;

    /*
    _args["doc"] = randomNumeric(6).toString();
        _args["data"] = DateFormat("yyyy/MM/dd")
            .format(DateTime.now())
            .toString()
            .replaceAll("/", "");
        _args["hora"] = DateFormat("HH:mm:ss")
            .format(DateTime.now())
            .toString()
            .replaceAll(":", "");

        print(_args['hora']);

        _args["op"] = "4";

    */

    print(mapParam);



    String retorno = await _sendFunctionToAndroid(mapParam);

    return retorno == _ERROR ? null : TEFReturn.fromJson(jsonDecode(retorno));
  }

  static Future<TEFReturn?> sendOptionCancel({
    required String enderecoSitef,
    required String valor,
  }) async {
    Map<String, dynamic> mapParam = new Map();

    mapParam['opcaoTef'] = TEF.M_SITEF.toString();
    mapParam['acaoTef'] = Acao.CANCELAMENTO.toString();
    mapParam['enderecoSitef'] = enderecoSitef;
    mapParam['valor'] = valor;
    mapParam["comExterna"] = EnterpriseConfig.comExterna;
    mapParam['chaveExterna'] =EnterpriseConfig.vpn;


    String retorno = await _sendFunctionToAndroid(mapParam);

    return retorno == _ERROR ? null : TEFReturn.fromJson(jsonDecode(retorno));
  }

  static Future<TEFReturn?> sendOptionConfigs({
    required String enderecoSitef,
    required String valor,
  }) async {
    Map<String, dynamic> mapParam = new Map();

    mapParam['opcaoTef'] = TEF.M_SITEF.toString();
    mapParam['acaoTef'] = Acao.CONFIGURACAO.toString();
    mapParam['enderecoSitef'] = enderecoSitef;
    mapParam['valor'] = valor;
    mapParam["comExterna"] = EnterpriseConfig.comExterna;
    mapParam['chaveExterna'] =EnterpriseConfig.vpn;


    String retorno = await _sendFunctionToAndroid(mapParam);

    return retorno == _ERROR ? null : TEFReturn.fromJson(jsonDecode(retorno));
  }
}
