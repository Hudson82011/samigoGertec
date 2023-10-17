import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../LocalInfo/EnterpriseConfig.dart';







class PostSaidaCaixa{


  Future<String>saida(String cod,String pin,String status,String desc,String vall)async{

    Codec<String, String> stringToBase64 = utf8.fuse(base64);


    String responde="";

    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/TSammi/func_inserirsaidacaixa/${EnterpriseConfig.banco}?cod_fun=$cod&senha=${stringToBase64.encode(pin)}";

    print(urlL);

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.authS,'Content-Type':'application/json'},
        body: json.encode([
          {
            "cod_func":"1",
            "func_autorizado":cod,
            "status":status,
            "descricao":desc,
            "valor":vall,
            "data":"2022-12-07",
            "movimento":"2022-12-07",
            "hora":"10:37:58.000",
            "serie_ecf":"NFC001",
            "forma_pag":"1"
          }
        ])
    );
    print(response.body);
    responde=response.body;

  return responde;
  }



}