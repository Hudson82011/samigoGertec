import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sammi_gov2/mapClasses/Pcmd.dart';

import '../LocalInfo/EnterpriseConfig.dart';
import '../mapClasses/Comanda.dart';






class GetCmd{


  Future<List<Pcmd>> retornaJsonp(int cmd) async {

    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_MostrarComandasItens/${EnterpriseConfig.banco}/$cmd";
    var response = await http.get(Uri.parse(url), headers: {'authorization': EnterpriseConfig.auth}).timeout(Duration(seconds:15));
    List<Pcmd> prodscmd = [];
    var prodsJson = json.decode(response.body);
    print(prodsJson);
    for (var prodJson in prodsJson) {
      prodscmd.add(Pcmd.fromJson(prodJson));
    }

    return prodscmd;
  }







}






