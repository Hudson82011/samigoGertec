
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BlueBall{

  static BluetoothConnection? connection;
  static String val="";

  static bool error=false;

  void connect(String mac)async{

    try {
      connection = await BluetoothConnection.toAddress(mac);
      print('Connected to the device');


      connection!.input?.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');




        val=ascii.decode(data);

        final startIndex = val.indexOf('');
        final endIndex =val.indexOf('', startIndex + ''.length);

        val=((double.tryParse(val.substring(startIndex + ''.length, endIndex))??0)*0.001).toStringAsFixed(3);



        //connection!.output.add(data); // Sending data


        if (ascii.decode(data).contains('!')) {
          connection!.finish(); // Closing connection
          print('Disconnecting by local host');
        }
      }).onDone(() {
        print('Disconnected by remote request');
      });
    }
    catch (exception) {
      print('Cannot connect, exception occured');
      print(exception.toString());
    }


  }


  void sendPrice(String val){
    var c2 = latin1.decode([0x02]);
    var c3 = latin1.decode([0x03]);


    connection!.output.add(ascii.encode(c2+val.replaceAll(".", "").replaceAll(",", "")+c3));
  }


 void priceTrigger()async{



    Uint8List int32bytes(int value) =>
        Uint8List(4)..buffer.asInt32List()[0] = value;



    connection!.output.add(int32bytes(5));// Sending data


  }






}