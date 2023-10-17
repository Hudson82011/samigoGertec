import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

import 'PixConfigs.dart';



class PostNewQr{


  Future<Map<String,dynamic>> postCieloOrder(double value)async{

    Map<String,dynamic>_value=Map();
    _value["alias"]=DateTime.now().millisecond*Random().nextInt(100);
    _value["totalAmount"]=value;
    _value["callbackAddress"]="https://api.cardapio.ommini.com.br/v1/callback_pix/forno";
    _value["expirationSeconds"]=3600;

print(_value["alias"]);

    var url="https://sandbox.pensebank.com.br/Pix";

    var response = await http.post(Uri.parse(url),headers:{

      'content-type':'application/json',
      'Authorization': 'Bearer ${PixConfigs.token}',

    }, body: json.encode(_value));


    print(response.statusCode);
    print(response.body);

    Map<String,dynamic>_return=Map();
    _return=json.decode(response.body);

    print(_return);

    return _return;


  }





}