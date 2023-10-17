import 'dart:convert';
import 'package:http/http.dart' as http;
import '../LocalInfo/EnterpriseConfig.dart';






class PostAttCmd{


  Future<String>setDocInCmd(String doc,String cupom)async{

    Codec<String, String> stringToBase64 = utf8.fuse(base64);


    String responde="";

    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_AtualizarComanda/${EnterpriseConfig.banco}";

    print(urlL);

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.auth,'Content-Type':'application/json'},
        body: json.encode([
          [
            {"documento":doc,"cupom":cupom},

          ]
          ,
          [
          ]
        ])
    );
    print(response.body);
    responde=response.body;

    return responde;
  }



}