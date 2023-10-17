

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';






import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sammi_gov2/ball/blue_ball.dart';
import 'package:sammi_gov2/mapClasses/ProdsCart.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartProd.dart';

import '../../mapClasses/Search_t.dart';
import 'CartBack/CartInfo.dart';



class AddProd extends StatefulWidget {
  final Search_t search_t;

  AddProd(this.search_t);

  @override
  _AddProdState createState() => _AddProdState(search_t);
}

class _AddProdState extends State<AddProd> {

  final Search_t search_t;

  _AddProdState(this.search_t);








  TextEditingController addController = TextEditingController();
  TextEditingController obsController = TextEditingController(text: "");






  double preco=0;
  int contador=0;





 /* void _connect()async{

    try {
     connection = await BluetoothConnection.toAddress("00:16:A4:13:3C:7D");
      print('Connected to the device');


     String source = '0x05';


     var c2 = latin1.decode([0x02]);
     var c3 = latin1.decode([0x03]);


     connection!.output.add(ascii.encode(c2+search_t.vlr_preco.replaceAll(".", "").replaceAll(",", "")+"0"+c3));





      connection!.input?.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');

        _val=ascii.decode(data);
        connection!.output.add(data); // Sending data


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
    }


  }*/

  String _val="";



  void initState() {

    addController.text=search_t.flg_unidade_venda=="UN"?"1":"1.0";
    addController.selection=TextSelection(baseOffset: 0, extentOffset: addController.text.length);
    preco=double.parse(search_t.vlr_preco);
    print(preco);
    print(search_t.vlr_preco);
   // flutterBlue.startScan(timeout: Duration(seconds: 4));
// Listen to scan results


    //_connect();
    if(search_t.flg_unidade_venda=="KG"){
    try{
      BlueBall.val="";
      BlueBall().sendPrice((double.tryParse(search_t.vlr_preco)??0).toStringAsFixed(2));
      BlueBall().priceTrigger();
      Future.delayed(Duration(seconds: 1)).then((value){
        addController.text=BlueBall.val;
      });
    }catch(err){
      print(err);
    }
    }


        //if(r.device.id.id == "00:16:A4:13:3C:7D")

    /*flutterBlue.startScan(timeout: Duration(seconds: 4),allowDuplicates: true);


    var subscription = flutterBlue.scanResults.listen((results) {

      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.device.id}');
      }
    });*/

   /* flutterBlue.connectedDevices.asStream().forEach((element) {
      print(element);
    });*/



    //flutterBlue.stopScan();


    // Some simplest connection :

    super.initState();
  }






  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(70, 26, 26, 1),
            title: Image.asset("imagens/sammigo 1.png",scale: 3.5,),
            centerTitle: true,
          ),
          body: SingleChildScrollView(

            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width:250 ,
                          child: Text("${search_t.descricao}",
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                        ),
                        Text("Cód.: "+search_t.cod_prod.toString(),style: TextStyle(

                        ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 175)),
                            Text(search_t.flg_unidade_venda.toString(),
                              style: TextStyle(
                                  
                              ),),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(preco.toStringAsFixed(2),
                                style: TextStyle(fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(131, 10, 10, 1)
                                )),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 30)),
                    Expanded(
                        child: search_t.flg_unidade_venda=="UN"?TextFormField(
                            autofocus: true,

                            controller: addController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                            decoration: InputDecoration(
                              labelText: "Quantidade",
                              filled: true,
                              fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                              focusColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Color.fromRGBO(88, 160, 178, 1),
                                ),
                              ),
                            )):TextFormField(
                            autofocus: true,
                            controller: addController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Quantidade",
                              filled: true,
                              fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                              focusColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Color.fromRGBO(88, 160, 178, 1),
                                ),
                              ),
                            ))),
                    search_t.flg_unidade_venda=="KG"?IconButton(onPressed: ()async{



                   /*   Uint8List int32bytes(int value) =>
                          Uint8List(4)..buffer.asInt32List()[0] = value;



                      connection!.output.add(int32bytes(5));// Sending data
                      connection!.output.allSent.then((value) => print(_val));

                      final startIndex = _val.indexOf('');
                      final endIndex = _val.indexOf('', startIndex + ''.length);*/
                      BlueBall.val="";
                      BlueBall().priceTrigger();
                      Future.delayed(Duration(seconds: 1)).then((value){
                        addController.text=BlueBall.val;
                      });




                     // print(connection!.output.allSent);



                    }, icon: Image.asset("imagens/ball.png"),iconSize: 80,):Row(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child:  GestureDetector(
                            child:Container(
                              width: MediaQuery.of(context).size.width*0.1,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Image.asset("imagens/less.png"),
                            ),
                            onTap: () {
                              double currentValue = double.parse(addController.text);
                              setState(() {
                                if(currentValue==0){print("a");}
                                else if(currentValue<=1){
                                  currentValue=0.1;

                                }
                                else{
                                  currentValue--;
                                  addController.text = (currentValue).toString();
                                }
                              });
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child:  GestureDetector(
                            child:Container(
                              width: MediaQuery.of(context).size.width*0.1,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Image.asset("imagens/plus.png"),
                            ),
                            onTap: () {
                              double currentValue = double.parse(addController.text);
                              setState(() {
                                currentValue++;
                                addController.text = (currentValue).toString();
                              });
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 60)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [


                  Container(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(228, 10, 10, 1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            )
                        ),
                        child:Container(
                          height: MediaQuery.of(context).size.height*0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Text("Cancelar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                        style:  ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(70, 26, 26, 1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            )
                        ),
                        onPressed: () async {
                          if(contador<1){
                            if(addController.text.contains(',')){
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("Favor utilizar \' . \'"));
                                  });

                            }
                            else if(double.parse(addController.text)<0.001){
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("A quantidade do produto não pode ser menor que 0.001"));
                                  });}
                            else if(double.parse(search_t.vlr_preco)<=0){
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("Produto com o valor igual ou menor a 0 não pode ser inserido na comanda."));
                                  });

                            }
                            else{

                              CartInfo.prods.add(ProdsCart(COD_PROD: search_t.cod_prod,
                                  DESCRICAO:  search_t.descricao,
                                  FLG_UNIDADE_VENDA:  search_t.flg_unidade_venda,
                                  VLR_PRECO:  search_t.vlr_preco,
                                  VLR_QTDE: search_t.flg_unidade_venda=="KG"? double.parse(addController.text).toStringAsFixed(3): double.parse(addController.text).toStringAsFixed(1),
                                  VLR_TOTAL:  (double.parse(search_t.vlr_preco)*double.parse(addController.text)).toStringAsFixed(2),
                                  VLR_ACRESCIMO: "0",
                                  VLR_DESCONTO:  "0",
                                  NUM_COMANDA: "0",
                               DOCUMENTO: "",COD_VEND: "0",BARRAS: search_t.codigo_barras

                              ));
                              contador++;
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }}else{
                            print("não");

                          }

                        },

                        child: Container(
                          height: MediaQuery.of(context).size.height*0.1,

                          decoration: BoxDecoration(
                            //  color:Color.fromRGBO(43, 82, 92, 1),
                            borderRadius: BorderRadius.circular(38),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Adicionar",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white
                                ),
                              ),

                            ],
                          ),
                        )
                    ),
                  )
                ],
              )


             //   ElevatedButton(onPressed: ()async{}, child: Text("Balança"))
              ],
            ),
          ),
        );

      }



}
