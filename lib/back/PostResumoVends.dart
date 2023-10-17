import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../LocalInfo/EnterpriseConfig.dart';







class PostResumoVends{


  Future<String>resumoVendas(String cod,String pin,String dataIni,String dataFim,String serie)async{

    Codec<String, String> stringToBase64 = utf8.fuse(base64);


    String responde="";

    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/TSammi/func_RetornaResumoDeVendas/${EnterpriseConfig.banco}?cod_fun=$cod&senha=${stringToBase64.encode(pin)}";

    print( {
      "data_ini":dataIni,
      "data_fin":dataFim,
      "token":EnterpriseConfig.deviceId,
      "serie":serie
    });

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.authS,'Content-Type':'application/json'},
        body: json.encode(
          {
            "data_ini":dataIni,
            "data_fin":dataFim,
            "token":EnterpriseConfig.deviceId,
            "serie":int.parse(serie)
          }
        )
    );
    print(response.body);
    responde=response.body;

    return responde;
  }


  Future<String>resumoVendasSintetico(String cod,String pin,String dataIni,String serie)async{

    Codec<String, String> stringToBase64 = utf8.fuse(base64);


    String responde="";

    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/TSammi/func_RetornaPreFechamentoSintetico/${EnterpriseConfig.banco}?cod_fun=$cod&senha=${stringToBase64.encode(pin)}";

    print(urlL);

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.authS,'Content-Type':'application/json'},
        body: json.encode(
            {
              "data":dataIni,
              "token":EnterpriseConfig.deviceId,
              "serie":serie
            }
        )
    );
    print(response.body);
    responde=response.body;

    return responde;
  }


  Future<String>resumoVendasAnalitico(String cod,String pin,String dataIni,String serie)async{

    Codec<String, String> stringToBase64 = utf8.fuse(base64);


    String responde="";

    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/TSammi/func_RetornaPreFechamentoAnalitico/${EnterpriseConfig.banco}?cod_fun=$cod&senha=${stringToBase64.encode(pin)}";

    print(urlL);

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.authS,'Content-Type':'application/json'},
        body: json.encode(
            {
              "data":dataIni,
              "token":EnterpriseConfig.deviceId,
              "serie":serie
            }
        )
    );
    print(response.body);
    responde=response.body;

    return responde;
  }


}