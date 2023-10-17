import 'dart:convert';

import 'package:http/http.dart' as http;


import '../LocalInfo/EnterpriseConfig.dart';
import '../mapClasses/Series.dart';





class GetTerminais{


  Future<String> retornaTerminais() async {

    print('Segue o retorno');

    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tsammi/func_GetNFeTerminal/${EnterpriseConfig.banco}";
    var response = await http.get(Uri.parse(url), headers: {'authorization': EnterpriseConfig.authS}).timeout(Duration(seconds:15));

    var prodsJson = json.decode(response.body);
    print('Segue o retorno');
    //print(prodsJson);

    List<Series> listaSeries = [];
    for (var prodJson in prodsJson) {
      listaSeries.add(Series.fromJson(prodJson));
    }


   try{
     EnterpriseConfig.serie=listaSeries.where((element) => element.token==EnterpriseConfig.deviceId).first.serieNf.toString();
     EnterpriseConfig.tipoNfce=listaSeries.where((element) => element.token==EnterpriseConfig.deviceId).first.tipoNf.toString();
   }catch(err){
     EnterpriseConfig.serie="1";
     EnterpriseConfig.tipoNfce="65";
   }

    print('segue a serie do caixa:'+EnterpriseConfig.serie);
    String _return="";

    return _return;
  }







}






