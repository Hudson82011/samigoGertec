import 'dart:convert';

Codec<String, String> stringToBase64 = utf8.fuse(base64);


String arredondaAbnt(String val){

  String decimalPoint = (double.parse(val) - double.parse(val).toInt()).toStringAsFixed(3);

  //print(decimalPoint);


  if(decimalPoint.length>=5){
    decimalPoint=decimalPoint.substring(0,5);
    double valueT=double.parse(decimalPoint.substring(decimalPoint.length-2,decimalPoint.length-1));
    print(valueT);




    if(decimalPoint.substring(decimalPoint.length-1,decimalPoint.length)=="5"){

      if(valueT%2!=0||valueT==0){
        valueT++;
        decimalPoint=decimalPoint.replaceRange(decimalPoint.length-2,decimalPoint.length-1,valueT.toStringAsFixed(0));
        decimalPoint=decimalPoint.replaceRange(decimalPoint.length-1,decimalPoint.length,"");
      }else{
        decimalPoint=decimalPoint.replaceRange(decimalPoint.length-2,decimalPoint.length-1,valueT.toStringAsFixed(0));
        decimalPoint=decimalPoint.replaceRange(decimalPoint.length-1,decimalPoint.length,"");
      }

    }else{
      decimalPoint=double.parse(decimalPoint).toStringAsFixed(2);
    }
  }else{
    print('não aplica');
  }

  val=(double.parse(val).toInt()+double.parse(decimalPoint)).toStringAsFixed(2);

  return val;
}
