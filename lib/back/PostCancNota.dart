import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../LocalInfo/EnterpriseConfig.dart';







class PostCanc{


  Future<String>canc(String cod,String pin,String notaId,String vndNota)async{

    Codec<String, String> stringToBase64 = utf8.fuse(base64);


    String responde="";

    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/TSammi/func_cancelarpedido/${EnterpriseConfig.banco}/${EnterpriseConfig.deviceId}?cod_fun=$cod&senha=${stringToBase64.encode(pin)}";

    print(urlL);

    print(json.encode(
      {
        "cod_fun":"1",
        "cod_vnd_nota": vndNota,
        "id": notaId

      }
    ));

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.authS,'Content-Type':'application/json'},
        body: json.encode(
          {
            "cod_fun":cod,
            "cod_vnd_nota": vndNota,
            "id": notaId

          }
        )
    );
    print(response.body);
    responde=response.body;

    return responde;
  }



}