import 'package:http/http.dart' as http;



class GetQr{


  Future<dynamic> getQrImg(String hash)async{



    var url="https://sandbox.pensebank.com.br/QRCode/$hash";


    var response = await http.get(Uri.parse(url),headers:{
      'content-type':'application/json',


    });


    print(response.statusCode);



    dynamic _return=response.body;



    return _return;


  }





}