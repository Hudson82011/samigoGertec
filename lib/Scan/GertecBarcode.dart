
import 'package:flutter/services.dart';

class GertecBarcode{


  static const _platform =
  const MethodChannel('samples.flutter.dev/gedi');


  static List<String> resultadosBardCod = [];



  Future<String> leitorCodigoDeBarra() async {
    String barcode="";
    try {
      barcode = await _platform.invokeMethod('leitorCodigoV2');

      print('Deu certo trazer pro nível do fluter'+barcode);

     //   resultadosBardCod.add(teste);

    } on PlatformException catch (e) {
      print(e.message);
    }
    return barcode;

  }


}