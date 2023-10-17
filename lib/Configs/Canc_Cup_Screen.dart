import 'dart:convert';

import 'package:danfe/danfe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';


import '../../utils/Converters.dart';

import '../LocalInfo/EnterpriseConfig.dart';
import '../LocalInfo/LocalBase.dart';
import '../Size.dart';
import '../back/PostCancNota.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../pages/PagaComanda/Fiscal/PostNfce.dart';
import '../printer/printerGertec.dart';


class CancCupScreen extends StatefulWidget {
  //const SangriaScreen({Key key}) : super(key: key);

  @override
  _CancCupScreenState createState() => _CancCupScreenState();
}

class _CancCupScreenState extends State<CancCupScreen> {
  ScreenSize _size=ScreenSize();

  bool _isLoading=false;

  //List<Map<String,dynamic>>_notes=[];


  List _notes=[];

  verificaNfce()async{


    print(LocalBase.lastNote);
    var urlNfe = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedido/${EnterpriseConfig.banco}/seq_cxa ='${EnterpriseConfig.serie}'";
    var urlSat = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedido/${EnterpriseConfig.banco}/seq_cxa ='${EnterpriseConfig.serie}' and DOCUMENTO_XML is not null";
    var response = await http.get(Uri.parse(EnterpriseConfig.tipoNfce=="59"?urlSat:urlNfe), headers: {'authorization': EnterpriseConfig.auth});
    print(response.body);
    //print(json.decode(response.body)[0]['msg_interativa']);

    print(json.decode(response.body));
    setState(() {
      _notes.addAll(json.decode(response.body));
      print(_notes.length);
    });




  }



  PrinterG _printer=PrinterG();


  @override
  void initState() {
    // TODO: implement initState


    verificaNfce();

   // _notes=EnterpriseConfig.lastNotes['notes'];


    //verificaNfce();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          backgroundColor: Color.fromRGBO(116, 0, 0, 1),
          title: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset("imagens/sammigo 1.png",),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: _size.getWidth(context),),
            Padding(padding: EdgeInsets.only(top:_size.getHeight(context)*0.05 )),
            Text('Gerenciamento de Nota(s)',style: TextStyle(
                color: Color.fromRGBO(98, 89, 89, 1),
                fontSize: 24,
                fontStyle: FontStyle.italic
            ),),
            Padding(padding: EdgeInsets.only(top:_size.getHeight(context)*0.05)),
            Container(
              height: _size.getHeight(context)*0.1,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(249, 249, 249, 1)
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.05)),
                  Container(
                    width: _size.getWidth(context)*0.2,
                    child: Text("N°. Cupom",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
                  Container(
                    width: _size.getWidth(context)*0.325,
                    child: Text("Data",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )),
                  ),
                  Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
                  Container(
                    width: _size.getWidth(context)*0.2,
                    child: Text("Ações",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )),
                  ),
                  Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
                  Container(
                    width: _size.getWidth(context)*0.125,
                    child: Text(""),
                  ),
                ],
              ),
            ),
            Expanded(child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return _cupCard(index);
                }))




          ],
        ),
        //bottomSheet:BottomBar()
    );
  }


  /* _cupCard(int index){
    return Container(
      height: _size.getHeight(context)*0.1,
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.05)),
          Container(
            width: _size.getWidth(context)*0.2,
            child: Text(_notes[index]['cod_vnd_nota'],style: TextStyle(
                fontSize: 20,

            ),),
          ),
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          Container(
            width: _size.getWidth(context)*0.325,
            child: Text(_notes[index]['data_resposta'],style: TextStyle(
                fontSize: 20,

            )),
          ),
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          Container(
            width: _size.getWidth(context)*0.1,
            child: Text(LocalBase.total.toStringAsFixed(2),style: TextStyle(
                fontSize: 20,

            )),
          ),
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          Container(
            width: _size.getWidth(context)*0.1,
            child:IconButton(onPressed: (){
              TextEditingController codController = TextEditingController();
              TextEditingController pinController = TextEditingController();

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color.fromRGBO(216, 219, 227, 1),
                      scrollable: true,
                      title:  Text("Gerência - Autorização Cancelamento de Nota"),
                      content: Container(
                        width: _size.getWidth(context)*0.75,
                        height: _size.getHeight(context)*0.175,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            Container(
                              width: _size.getWidth(context)*0.25,
                              child:   TextField(
                                keyboardType: TextInputType.number,
                                controller: codController,
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  labelText: "Código",
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(135, 134, 134, 1),
                                      fontStyle: FontStyle.italic),
                                  filled: true,
                                  fillColor: Color.fromRGBO(237, 234, 234, 1),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      width: 0,
                                      color: Color.fromRGBO(159, 157, 157, 0),
                                    ),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Container(
                              width: _size.getWidth(context)*0.25,
                              child:
                              TextField(
                                obscureText: true,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  labelText: "Senha",
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(135, 134, 134, 1),
                                      fontStyle: FontStyle.italic),
                                  filled: true,
                                  fillColor: Color.fromRGBO(237, 234, 234, 1),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      width: 0,
                                      color: Color.fromRGBO(159, 157, 157, 0),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                controller: pinController,
                              ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Color.fromRGBO(
                                                189, 186, 184, 1))),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar")),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Color.fromRGBO(
                                                126, 0, 0, 1))),
                                    onPressed: () {
                                      PostCanc()
                                          .canc(
                                          codController.text,
                                          pinController.text,
                                          randomAlphaNumeric(32).toUpperCase(),
                                         _notes[index]['cod_vnd_nota'])
                                          .then((ret) {
                                        print(ret);
                                        Map<String, dynamic> _return = Map();
                                        _return = json.decode(ret);
                                        if (_return.containsKey("error")) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text(_return[
                                                    "error"]
                                                        .toString()
                                                        .replaceAll("[", "")
                                                        .replaceAll("]", "")
                                                        .replaceAll("{", "")
                                                        .replaceAll(
                                                        "}", "")));
                                              });
                                        } else if(_return.containsKey("result")&&_return['result'][0]=="777"){
                                          print('foi');
                                          Elgin().printerService.sendPrinterText(
                                              text: 'Padaria TecnoPan LTDA\n'+
                                                  '===========================\n'+
                                                  "Data:${DateTime.now()}\n"+
                                                  "Operado:${FuncInfos.codFunc} ${FuncInfos.funcName}\n"+
                                                  "Autorização:${codController.text} \n"+
                                                  '---------------------------\n'+
                                                  "\n\n"+
                                                  "Cancelamento de nota\n"+
                                                  "Valor: ${LocalBase.total}"
                                                      "\n\n"+
                                                  '---------------------------\n'+
                                                  "Assinatura",align: 'Centralizado',isBold: false,fontSize: 1,font: 'FONT B'

                                          );
                                          Elgin().printerService.cutPaper(15);
                                          LocalBase.total=0;
                                          LocalBase.lastNote="";
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text('Cancelamento efetuado com sucesso.'));
                                              }).then((value){
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });

                                        }else{
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text(_return['result'][0]));
                                              });
                                        }
                                      });
                                    },
                                    child: Text("Confirmar"))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });



            }, icon:Icon(Icons.clear)),
          ),
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          Container(
            width: _size.getWidth(context)*0.1,
            child:IconButton(onPressed: (){

              PostNfce().retornaXML(true,_notes[index]["id"]).then((value){
                setState(() {
                 ImpD2().impCupom(value);
                });
              });





            }, icon:Icon(Icons.print)),
          ),
        ],
      ),
    );

  }*/

  _cupCard(int index){

   // Danfe? danfe = DanfeParser.readFromString(stringToBase64.decode(_notes[index]["note"]));

    //String codVndNota=danfe!.dados!.infAdic!.infCpl!.split(" ")[0].replaceAll("CP:", "");


 /*   if(danfe.tipo=="CFe"){
      int serie=(int.parse(danfe!.dados!.ide!.numeroCaixa!)*1000000);
      int cupom=int.parse(danfe!.dados!.ide!.nNF!);

      codVndNota=(serie+cupom).toString();
    }*/



    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12)
      ),
      height: _size.getHeight(context)*0.095,
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.05)),
          Container(
            width: _size.getWidth(context)*0.2,
            child: Text(_notes[index]["cod_vnd_nota"]??"",style: TextStyle(
              fontSize: 14,

            ),),
          ),
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          Container(
            width: _size.getWidth(context)*0.35,
            child: Text(_notes[index]["data_resposta"]??"",style: TextStyle(
              fontSize: 12,

            ))
          ),
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          /*Container(
            width: _size.getWidth(context)*0.125,
            child: Text("R\$"+danfe.dados!.total!.valorTotal!,style: TextStyle(
              fontSize: 10,

            )),
          ),*/
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          Container(
            width: _size.getWidth(context)*0.1,
            child:IconButton(onPressed: ()async{


              PostNfce().retornaXMLre(false,_notes[index]["cod_vnd_nota"]).then((value){
               String xml64=value;
               sendPrinterNFCe(xml64);

                // if(CartInfo.prazo){
                //  ImpD2().impCompVendaPrazo(json.decode(response.body)[0]['cod_vnd_nota']);
                // }

                // if(!CartInfo.dinheiro){
                // ImpD2().impCupom(xml64).then((value) =>  ImpD2().impVal(CartInfo.lastCard));
                //  }else{
                //   ImpD2().impCupom(xml64);
                // }




                // LocalFiles().saveTempFile(EnterpriseConfig.lastNotes, 'lastNotes');

              });



             // DanfePrinter danfePrinter =
             // DanfePrinter(PaperSize.mm58); // ou  PaperSize.mm50
              //List<int> _dados = await danfePrinter.bufferDanfe(danfe);



             // final profile = await CapabilityProfile.load();

            //  final generator = Generator(PaperSize.mm58, profile);



            //  await ImpD2().impEscPos(_dados);

           //   Map<String,dynamic>note=Map();

           //   await ImpD2().impEscPos(generator.emptyLines(1) +
               //   generator.text(_notes[index]["card"],
               //       styles: PosStyles(align: PosAlign.center)) +
               //   generator.cut());


            }, icon:Icon(Icons.print)),
          ),
          Padding(padding: EdgeInsets.only(left: _size.getWidth(context)*0.025)),
          Container(
            width: _size.getWidth(context)*0.1,
            child:IconButton(onPressed: (){
              TextEditingController codController = TextEditingController();
              TextEditingController pinController = TextEditingController();

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color.fromRGBO(216, 219, 227, 1),
                      scrollable: true,
                      title:  Text("Gerência - Autorização Cancelamento de Nota"),
                      content: Container(
                        width: _size.getWidth(context)*0.75,
                        height: _size.getHeight(context)*0.25,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                ),
                                Container(
                                  width: _size.getWidth(context)*0.25,
                                  child:   TextField(
                                    keyboardType: TextInputType.number,
                                    controller: codController,
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      labelText: "Código",
                                      labelStyle: TextStyle(
                                          color: Color.fromRGBO(135, 134, 134, 1),
                                          fontStyle: FontStyle.italic),
                                      filled: true,
                                      fillColor: Color.fromRGBO(237, 234, 234, 1),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          width: 0,
                                          color: Color.fromRGBO(159, 157, 157, 0),
                                        ),
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 20)),
                                Padding(padding: EdgeInsets.only(top: 5)),
                                Container(
                                  width: _size.getWidth(context)*0.25,
                                  child:
                                  TextField(
                                    obscureText: true,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      labelText: "Senha",
                                      labelStyle: TextStyle(
                                          color: Color.fromRGBO(135, 134, 134, 1),
                                          fontStyle: FontStyle.italic),
                                      filled: true,
                                      fillColor: Color.fromRGBO(237, 234, 234, 1),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          width: 0,
                                          color: Color.fromRGBO(159, 157, 157, 0),
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: pinController,
                                  ),),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.05)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Color.fromRGBO(
                                                189, 186, 184, 1))),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar")),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Color.fromRGBO(
                                                126, 0, 0, 1))),
                                    onPressed: () {
                                      PostCanc()
                                          .canc(
                                          codController.text,
                                          pinController.text,
                                          randomAlphaNumeric(32).toUpperCase(),
                                          _notes[index]["cod_vnd_nota"])
                                          .then((ret) {
                                        print(ret);
                                        Map<String, dynamic> _return = Map();
                                        _return = json.decode(ret);
                                        if (_return.containsKey("error")) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text(_return[
                                                    "error"]
                                                        .toString()
                                                        .replaceAll("[", "")
                                                        .replaceAll("]", "")
                                                        .replaceAll("{", "")
                                                        .replaceAll(
                                                        "}", "")));
                                              });
                                        } else if(_return.containsKey("result")&&_return['result'][0]=="777"){
                                          print('foi');

                                          //   ImpD2().impCanc(codVndNota,danfe.dados!.total!.valorTotal!);
                                          _printer.impressaoDeTexto(texto:"CNPJ: ${EnterpriseConfig.cnpj}  'Padaria TecnoPan LTDA\n\'"+
                                          '===========================\n'+
                                              "Data:${DateTime.now()}\n"+
                                            //  "Operado:${FuncInfos.codFunc} ${FuncInfos.funcName}\n"+
                                              "Autorização:${codController.text} \n"+
                                              '---------------------------\n'+
                                              "\n\n"+
                                              "Cancelamento de nota\n"+
                                              "Valor: ${LocalBase.total}"
                                                  "\n\n"+
                                              '---------------------------\n'+
                                              "Assinatura",
                                              fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
                                            //fontSize: 18,
                                            // alinhar: "LEFT",

                                          );
                                          /*Elgin().printerService.sendPrinterText(
                                              text: 'Padaria TecnoPan LTDA\n'+
                                                  '===========================\n'+
                                                  "Data:${DateTime.now()}\n"+
                                                  "Operado:${FuncInfos.codFunc} ${FuncInfos.funcName}\n"+
                                                  "Autorização:${codController.text} \n"+
                                                  '---------------------------\n'+
                                                  "\n\n"+
                                                  "Cancelamento de nota\n"+
                                                  "Valor: ${LocalBase.total}"
                                                      "\n\n"+
                                                  '---------------------------\n'+
                                                  "Assinatura",align: 'Centralizado',isBold: false,fontSize: 1,font: 'FONT B'

                                          );
                                          Elgin().printerService.cutPaper(15);*/
                                          EnterpriseConfig.lastNotes['notes'].remove(_notes[index]);

                                          //LocalBase.total=0;
                                          //LocalBase.lastNote="";

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text('Cancelamento efetuado com sucesso.'));
                                              }).then((value){
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });

                                        }else{
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text(_return['result'][0]));
                                              });
                                        }
                                      });
                                    },
                                    child: Text("Confirmar"))
                              ],
                            )
                          ],
                        )
                      ),
                    );
                  });



            }, icon:Icon(Icons.clear)),
          ),
        ],
      ),
    );

  }


  sendPrinterNFCe(String xml64) async {


    String space1= " ";
    String space2= "⠀⠀";
    String space4= "⠀⠀⠀⠀";
    String space8= "⠀⠀⠀⠀⠀⠀⠀⠀     ";
    String space5= "⠀⠀⠀⠀⠀     ";
    String zero6="000000";




    _printer.finalizarImpressao();

    Codec<String, String> stringToBase64 = utf8.fuse(base64);


    Danfe danfe = DanfeParser.readFromString(stringToBase64.decode(xml64))!;

    DanfePrinter danfePrinter = DanfePrinter(PaperSize.mm58); // ou  PaperSize.mm50
    // List<int> _dados = await danfePrinter.bufferDanfe(danfe);

    //   Uint8List uintVal=Uint8List.fromList(_dados);


    //print("segue o decode"+ascii.decode(_dados));

    // _dados.remove([27, 97, 48]);
    // _dados.remove([27, 97, 49]);




    //String value= String.fromCharCodes(_dados);

    //value=value.replaceAll("", "");
    // value=value.replaceAll("", "");
    // value=value.replaceAll(, "");

    //value=value.replaceAll(RegExp("[^\u0020-\u007E]"), "");


    // print("Segue o cupom:"+value);


    /*   _printer.impressaoDeTexto(texto:value,
          fontSize: 20,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
        //fontSize: 18,
        // alinhar: "LEFT",

      );*/




    /* _printer.impressaoDeTexto(texto:"CNPJ: ${danfe.dados!.emit!.cnpj} \n ${danfe.dados!.emit!.xNome},\n"
          " ${danfe.dados!.emit!.enderEmit!.nro} ${danfe.dados!.emit!.enderEmit!.xBairro}"
          " - ${danfe.dados!.emit!.enderEmit!.cMun} - ${danfe.dados!.emit!.enderEmit!.uF}"
          " ${danfe.dados!.emit!.enderEmit!.cEP} \nFone: ${danfe.dados!.emit!.enderEmit!.fone} I.E.: ${danfe.dados!.emit!.iE}\n",
          fontSize: 26,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
        //fontSize: 18,
        // alinhar: "LEFT",
        );

      _printer.impressaoDeTexto( texto:"DOCUMENTO AUXILIAR DA NOTA FISCAL\n DE CONSUMIDOR ELETRÔNICO\n"
          ,fontSize: 18,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar:"CENTER",context: context
      );

     // Tectoysunmisdk.setAlignment(TextoAlinhamento.LEFT);

      _printer.impressaoDeTexto( texto: "COD$space4"+"DESC$space5"+"QTD$space2"+"UN"+space2+"VL UNIT."+"TOTAL\n"
          ,fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context);
      for(var prod in danfe.dados!.det!){
        _printer.impressaoDeTexto( texto: ((zero6+prod.prod!.cProd!).substring(prod.prod!.cProd!.length,prod.prod!.cProd!.length+6)+"-"
            +(prod.prod!.xProd!+space8).substring(0,10)+space2+
            (prod.prod!.qCom!.substring(0,4)+prod.prod!.uCom!+space4).substring(0,6)+" "
            +(prod.prod!.vUnCom!+space4).substring(0,4))+"  "+(prod.prod!.vProd!+space4).substring(0,4)+"\n",fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,true],alinhar: "CENTER",context: context

        );
      }

      //Tectoysunmisdk.setAlignment(TextoAlinhamento.CENTER);
       _printer.impressaoDeTexto( texto: "FORMA DE PAGAMENTO"+space2+"Valor Pago\n"
        ,fontSize: 22,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context);
      _printer.impressaoDeTexto( texto:"Dinheiro"+space8+"50,00\n",
          fontSize: 22,fontFamily: "DEFAULT",selectedOptions: [false,false,false],alinhar: "CENTER",context: context);

      _printer.impressaoDeTexto( texto: "Troco R\$"+space8+"20,00\n",  fontSize: 14,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context);
      _printer.impressaoDeTexto( texto: "Consulte pela Chave de Acesso em\n",
          fontSize: 22,fontFamily: "DEFAULT",selectedOptions: [false,false,false],alinhar: "CENTER",context: context);
      _printer.impressaoDeTexto( texto: danfe.dados!.sVersao!+'\n',
          fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [false,false,false],alinhar: "CENTER",context: context);
      _printer.impressaoDeTexto( texto:   danfe.dados!.chaveNota!+'\n',
          fontSize: 20,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context);
      _printer.impressaoDeCodigoDeBarra( texto: danfe.qrcodePrinter.toString(), barCode: "QR_CODE",height: 300,width: 300,context: context);

      _printer.impressaoDeTexto( texto: "\n\n\n\n\n",  fontSize: 14,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context);*/






    //---------------------------




    _printer.impressaoDeTexto(texto:"CNPJ: ${danfe.dados!.emit!.cnpj}  ${danfe.dados!.emit!.xNome},\n"
        " ${danfe.dados!.emit!.enderEmit!.nro} ${danfe.dados!.emit!.enderEmit!.xBairro}"
        " - ${danfe.dados!.emit!.enderEmit!.cMun} - ${danfe.dados!.emit!.enderEmit!.uF}"
        " ${danfe.dados!.emit!.enderEmit!.cEP} \nFone: ${danfe.dados!.emit!.enderEmit!.fone} I.E.: ${danfe.dados!.emit!.iE}\n",
        fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
      //fontSize: 18,
      // alinhar: "LEFT",

    );
    _printer.impressaoDeTexto(texto:"DOCUMENTO AUXILIAR DA NOTA FISCAL\n DE CONSUMIDOR ELETRÔNICO\n",
        fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    );

    //Tectoysunmisdk.setAlignment(TextoAlinhamento.LEFT);

    _printer.impressaoDeTexto( texto:"COD$space4"+"DESC$space5"+"QTD$space2"+"UN"+space2+"VL UNIT."+"TOTAL\n",
        fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context);
    for(var prod in danfe.dados!.det!){
      _printer.impressaoDeTexto(texto:((zero6+prod.prod!.cProd!).substring(prod.prod!.cProd!.length,prod.prod!.cProd!.length+6)+"-"
          +(prod.prod!.xProd!+space8).substring(0,10)+space2+
          (prod.prod!.qCom!.substring(0,4)+prod.prod!.uCom!+space4).substring(0,6)+" "
          +(prod.prod!.vUnCom!+space4).substring(0,4))+"  "+(prod.prod!.vProd!+space4).substring(0,4)+"\n",
          fontSize: 20,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context

      );
    }

    //_printer.impressaoDeTexto(TextoAlinhamento.CENTER);
    _printer.impressaoDeTexto(texto:"FORMA DE PAGAMENTO"+space2+"Valor Pago\n",
        fontSize: 20,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    );
    _printer.impressaoDeTexto(texto:"${danfe.dados!.pgto!.formas![0].cMP!}"+space8+"${danfe.dados!.pgto!.formas![0].vMP}\n",
        fontSize: 24,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    );

    danfe.dados!.pgto!.vTroco!="0.00"&&danfe.dados!.pgto!.formas![0].cMP=="1"?_printer.impressaoDeTexto(  texto:"Troco R\$"+space8+"${danfe.dados!.pgto!.vTroco}\n",
        fontSize: 24,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    ):_printer.impressaoDeTexto(texto:  "\n",
        fontSize: 24,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    );

    _printer.impressaoDeTexto( texto:"Consulte pela Chave de Acesso em\n",
        fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    );
    _printer.impressaoDeTexto(texto: danfe.dados!.sVersao!+'\n',
        fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    );
    _printer.impressaoDeTexto( texto: danfe.dados!.chaveNota!+'\n',
        fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context
    );
    _printer.impressaoDeTexto( texto:"Total: \R\$ ${danfe.dados!.total!.valorTotal}\n",
      fontSize: 16,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context,);

    _printer.impressaoDeCodigoDeBarra( texto: danfe.qrcodePrinter.toString(), barCode: "QR_CODE",height: 300,width: 300,context: context);

    _printer.impressaoDeTexto( texto: "\n\n\n\n\n",  fontSize: 14,fontFamily: "DEFAULT",selectedOptions: [true,false,false],alinhar: "CENTER",context: context);




























    //-------------------------------




    // Tectoysunmisdk.print3Line();

    //Tectoysunmisdk.printQr(
    //  danfe.qrcodePrinter!, 5,0
    //);
    //_printer.*/

    //finalizarImpressao();
    //avancaLinhas(20);*/
    _printer.finalizarImpressao();


  }


}
