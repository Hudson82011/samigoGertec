
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'PixConfigs.dart';



class GetConfirmation{


  Future<Map<String,dynamic>> getConf(String hash)async{



    var url="https://sandbox.pensebank.com.br/Payment/$hash";

    var response = await http.get(Uri.parse(url),headers:{
      'content-type':'application/json',
      'Authorization': 'Bearer ${PixConfigs.token}',

    });


    print(response.statusCode);
    print(response.body);

    Map<String,dynamic>_return=Map();
    _return=json.decode(response.body);

    print(_return);

    return _return;


  }





}