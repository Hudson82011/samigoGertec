import 'dart:math';

import 'package:flutter/services.dart';

class ElginpayService {
  final _platform = const MethodChannel('samples.flutter.dev/gedi');

  setHandler(_methodCallHandler) async {
    _platform.setMethodCallHandler(_methodCallHandler);
  }


  void desativaImp()async{

    Map<String, dynamic> mapParam = new Map();
    mapParam['Value'] = "2";
    mapParam['typeElginpay'] = 'ImpDesativa';


    // _platform.invokeMethod("elginpay", {"args": mapParam});

    print('ABAIXO O RESULTADO DO DESATIVA IMP');
    print(await _platform.invokeMethod("elginpay", {"args": mapParam}));


  }


  Future<String> inicializarPagamentoDebito({required String value}) async {
    Map<String, dynamic> mapParam = new Map();

    mapParam['Value'] = value;
    mapParam['typeElginpay'] = 'IniciarPagamentoDébito';

    return await _platform.invokeMethod("elginpay", {"args": mapParam});
  }

  Future<String> inicializarPagamentoCredito(
      {required String value, required String installmentMethod}) async {
    Map<String, dynamic> mapParam = new Map();

    mapParam['Value'] = value;
    mapParam['typeElginpay'] = 'IniciarPagamentoCrédito';
    mapParam['installmentMethod'] = installmentMethod;

    return await _platform.invokeMethod("elginpay", {"args": mapParam});
  }

  Future<String> inicializarCancelamento({required String value,required String ref,required String data}) async {
    Map<String, dynamic> mapParam = new Map();

    mapParam['Value'] = value;
    mapParam['ref']=ref;
    mapParam['data']=data;
    mapParam['typeElginpay'] = 'IniciarCancelamento';

    return await _platform.invokeMethod("elginpay", {"args": mapParam});
  }

  Future<String> inicializarOperacaoAdministrativa() async {
    Map<String, dynamic> mapParam = new Map();

    mapParam['typeElginpay'] = 'IniciarOperacaoAdministrativa';

    return await _platform.invokeMethod("elginpay", {"args": mapParam});
  }
}
