import 'dart:async';
import 'dart:convert';
import 'package:string_validator/string_validator.dart';
import 'package:danfe/danfe.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sammi_gov2/elginPay/ElginPay.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartBack/CartInfo.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartProd.dart';
import 'package:sammi_gov2/pages/PagaComanda/configPedido/ConfigPedido.dart';
import 'package:sammi_gov2/pages/PagaComanda/money/PagDinheiro.dart';
import 'package:sammi_gov2/pages/PagaComanda/selectCmd.dart';
import 'package:sammi_gov2/pages/PagaComanda/tef/lastTransition.dart';
import 'package:sammi_gov2/pages/PagaComanda/tef/posTef.dart';
import 'package:sammi_gov2/printer/printer.dart';
import 'package:quiver/async.dart';
import 'package:sammi_gov2/printer/printerGertec.dart';

import '../../../LocalInfo/EnterpriseConfig.dart';
import '../../../Utils/LocalFiles.dart';
import '../../../back/PostAttCmd.dart';
import '../../login.dart';
import '../prodsCmd.dart';
import 'PostNfce.dart';




class Nfce extends StatefulWidget {
  @override
  _NfceState createState() => _NfceState();
}

class _NfceState extends State<Nfce> {

  String xml64="";
  //PrinterService _printer=PrinterService();

  PrinterG _printer=PrinterG();


  bool nfceEmitida=false;
  bool erroNaEmissao=false;
  bool tempExpirado=false;
  bool rej=false;

  String msgReturn="";


String nota="";

  /*verificaNfce()async{


    print(CartInfo.cartId);
    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedido/$banco/id='${CartInfo.cartId}'";
    var response = await http.get(Uri.parse(url), headers: {'authorization': auth});
    print(response.body);
    //print(json.decode(response.body)[0]['msg_interativa']);




    if(tempExpirado==false&&response.body=="[]"||(json.decode(response.body)[0]['status_envio']=='P'||json.decode(response.body)[0]['status_envio']=='E')
        ){
      refresh();


    }else if(json.decode(response.body)[0]['status_envio']=='C'){
      setState(() {
        sub.pause();
        nfceEmitida=true;
        retornaXML();

        CartInfo.prods.where((element) => element.DOCUMENTO!="").map((e) => e.DOCUMENTO).toSet().toList().forEach((doc) {
          baixaComanda(doc);
        });




        //_printer.connectInternalImp();
        print(LastTrasition.params);
        try{
          print(json.decode(response.body)[0]);
          nota=json.decode(response.body)[0]['cod_vnd_nota'];
        }catch(err){
          print(err);
        }

        LocalFiles().saveTempFile(EnterpriseConfig.lastNotes, 'lastNotes');

        setState(() {

        });
        if(!ConfigPedido.dinheiro){
        //_printer.printerCupomTEF(LastTrasition.params["comprovanteGraficoLojista"]);
       //_printer.jumpLine(3);
          }
        ///_current=int.parse(json.decode(response.body)[0]['cod_vnd_nota']);

      });
      print('foi');



      var urlBaixa="http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_BaixarComanda/$banco";
      var responseBaixa=await http.post(Uri.parse(urlBaixa), headers: {'authorization': auth},
          body: "[{documento:$documentoCmd}]"
      );




    }else if(json.decode(response.body)[0]['status_envio']=='E') {
      rej=true;


    }else if(json.decode(response.body)[0]['status_envio']=='R'||json.decode(response.body)[0]['status_envio']=='V'){
      rej=true;
      msgReturn=json.decode(response.body)[0]['msg_interativa'];





    }else{
      refresh();


    }




  }*/


  verificaNfce()async{


    print(CartInfo.cartId);
    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tsammi/func_ConsultarPedido/${EnterpriseConfig.banco}/id='${CartInfo.cartId}'";
    var response = await http.get(Uri.parse(url), headers: {'authorization': EnterpriseConfig.authS});
    print(response.body);
    //print(json.decode(response.body)[0]['msg_interativa']);

    if(tempExpirado){
      return;
    }
    else if(tempExpirado==false&&response.body=="[]"||(json.decode(response.body)[0]['status_envio']=='P'||json.decode(response.body)[0]['status_envio']=='E')
    ){
      Future.delayed(Duration(seconds: 1)).then((value) => refresh());


    }else if(json.decode(response.body)[0]['status_envio']=='N')
    {
      return;


    }else if(json.decode(response.body)[0]['status_envio']=='C'){

      bool haveVnd=true;

      try{

        haveVnd=json.decode(response.body)[0]['cod_vnd_nota'].isNotEmpty;
      }catch(err){
        haveVnd=false;
      }


      if(haveVnd){
        setState(() {
          sub.pause();
          nfceEmitida=true;
          PostNfce().retornaXML(false,CartInfo.cartId).then((value){
            xml64=value;

           // if(CartInfo.prazo){
            //  ImpD2().impCompVendaPrazo(json.decode(response.body)[0]['cod_vnd_nota']);
           // }

           // if(!CartInfo.dinheiro){
              // ImpD2().impCupom(xml64).then((value) =>  ImpD2().impVal(CartInfo.lastCard));
          //  }else{
              //   ImpD2().impCupom(xml64);
           // }


            Map<String,dynamic>note=Map();
            note["note"]=xml64;


            note["card"]=CartInfo.lastCard;
            note['pix']="";
            EnterpriseConfig.lastNotes['notes'].insert(0, note);

            if(EnterpriseConfig.lastNotes['notes'].length>=20){
              EnterpriseConfig.lastNotes['notes'].removeAt(5);
            }



           // LocalFiles().saveTempFile(EnterpriseConfig.lastNotes, 'lastNotes');

          });

          CartInfo.prods.where((element) => element.DOCUMENTO!="").map((e) => e.DOCUMENTO).toSet().toList().forEach((doc) {
            baixaComanda(doc);
            print(response.body);
            PostAttCmd().setDocInCmd(doc,json.decode(response.body)[0]['cod_vnd_nota']);
          });




        //  _printer.connectInternalImp();
          print(LastTrasition.params);
          try{
            print(json.decode(response.body)[0]);
            nota=json.decode(response.body)[0]['cod_vnd_nota'];
          }catch(err){
            print(err);
          }




          setState(() {

          });

          ///_current=int.parse(json.decode(response.body)[0]['cod_vnd_nota']);

        });
        print('foi');
      }else{
        refresh();
      }




      //var urlBaixa="http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_BaixarComanda/${EnterpriseConfig.banco}";
      //  var responseBaixa=await http.post(Uri.parse(urlBaixa), headers: {'authorization': EnterpriseConfig.auth},
      //   body: "[{documento:$documentoCmd}]"
      //  );




    }else if(json.decode(response.body)[0]['status_envio']=='E') {
      rej=true;


    }else if(json.decode(response.body)[0]['status_envio']=='R'||json.decode(response.body)[0]['status_envio']=='V'){
      rej=true;
      msgReturn=json.decode(response.body)[0]['msg_interativa'];





    }else{
      refresh();


    }



  }

  refresh(){
    verificaNfce();
  }


  Future retornaXML() async {
    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedidoXML/$banco/id='${CartInfo.cartId}'/XML";

    ///var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedidoXML/$banco/id='255E1A5AC32D49BC8C6B6810BBC73F1X'/JSON";
    var response = await http.get(
        Uri.parse(url), headers: {'authorization': auth});
    print(response.body);


    Map<String,dynamic> res=Map();
    res=json.decode(response.body.replaceAll("[","").replaceAll("]",""));
    print(res);
    xml64=res["documento_xml_resposta"];
    try{
      nota=json.decode(response.body)[0]['cod_vnd_nota'];
    }catch(err){
      print(err);
    }
    print(xml64);
  }



  void printFicha(){

    CartInfo.prods.forEach((element) {

      String bar='----------------------------';

      double of=5;
      print(of.toStringAsFixed(3));

      for(int x=0;x<double.parse(element.VLR_QTDE);x++){
        PrinterService().sendPrinterText(text:'Padaria tecnopam\n',
          fontSize: 0,align: "Centralizado",font: 'FONT A'
        );
        PrinterService().sendPrinterText(text:'\n'+element.DESCRICAO+'\n'+'R\$'+double.parse(element.VLR_PRECO).toStringAsFixed(2)+'\n',
             fontSize: 1,align: "Centralizado",font: 'FONT C',isBold: true
        );
        PrinterService().sendPrinterBarCode(text:element.COD_PROD, height:120,width:4,barCodeType: "CODE 93",align: "Centralizado" );

        PrinterService().sendPrinterText(text:'\n'+bar+'\n',
            fontSize: 1,align: "Centralizado",isBold: true
        );
      }

    });
    PrinterService().jumpLine(3);



  }


  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String cmpVal(int val){
    String forma="";

    if(val==1){
      forma="Dinheiro";
    }else if(val==03){
      forma="Cartão de Crédito";
    }else if(val==04 ){
      forma="Cartão de Débito";
    }else if(val==05  ){
      forma="Crédito Loja";
    }else if(val==10  ){
      forma="Vale Alimentação";
    }else if(val==11  ){
      forma="Vale Refeição";
    }else if(val==12 ){
      forma="Vale Presente";
    }else if(val==13  ){
      forma="Vale Combustível";
    }else if(val==15  ){
      forma="Boleto Bancário";
    }else if(val==16 ){
      forma="Depósito Bancário";
    } else if(val==17 ){
      forma="Pagamento Instantâneo (PIX)";
    }else if(val==18 ){
      forma="Transferência bancária, Carteira Digital";
    }else if(val==19 ){
      forma="Programa de fidelidade, Cashback, Crédito Virtual";
    }else if(val==99){
      forma="Outros";
    }else{
      forma="Outros";
    }



    return forma;
  }


  sendPrinterNFCe() async {


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









  String _bar=r'\';

  void baixaComanda(String cmd)async{

    Map<String, String> _baixa={
      "documento":"$cmd"
    };

    List cmds=[];
    cmds.add(_baixa);


    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_BaixarComanda/$banco";
    var response = await http.post(Uri.parse(url),
        headers: {'authorization': auth}, body: json.encode(cmds));
    print(response.body);


  }







  int _start = 10;
  int _current = 10;

  late StreamSubscription<CountdownTimer> sub;
  void startTimer() {
    print("chamando o "+CartInfo.cartId);
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );


    sub=countDownTimer.listen(null);

    sub.onData((duration) {

      setState(() {

        _current = _start - duration.elapsed.inSeconds;

      });
    }

    );




    sub.onDone(() {
      print("Done");
      tempExpirado=true;
      sub.cancel();
    });
  }

  chamaMsg(){

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Documento emitido com sucesso!"),

          );});


  }


  void initState() {
    tempExpirado=false;
    erroNaEmissao=false;

    startTimer();
    verificaNfce();


    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () async => false,
          child:
          Scaffold(
              appBar: AppBar(title: GestureDetector(
                onTap: (){
                  retornaXML();

                },

                child: Image.asset("imagens/sammigo 1.png",scale: 3.5,),
              ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                foregroundColor: Color.fromRGBO(70, 26, 26, 1),
                backgroundColor: Color.fromRGBO(70, 26, 26, 1),
              ),
              body:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    double.parse(trocoGerado)<=0?Container():Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Troco: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.black
                          ),
                        ),
                        Text("R\$"+trocoGerado, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Color.fromRGBO(131, 10, 10, 1)
                        ),)
                      ],
                    ),

                    nfceEmitida?Container():rej?Text(msgReturn,
                      textAlign:TextAlign.center,
                      style: TextStyle(
                      fontSize: 28,
                    )): tempExpirado?Text("Não foi possivel\n emitir o documento! Verifique o servidor.",
                        textAlign:TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                        )):Container(),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    rej?Text("Falha ao emitir nfce"):Text(nfceEmitida?"DOCUMENTO EMITIDO\nCOM SUCESSO":"Emitindo DOCUMENTO...",
                      textAlign:TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                      ),),
                    nfceEmitida?Container():tempExpirado?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color.fromRGBO(70, 26, 26,1))
                            ),
                            onPressed: (){
                              if(ConfigPedido.dinheiro){

                                //CartInfo.prods.clear();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (BuildContext context) => CartProd()),
                                    ModalRoute.withName('/')
                                );

                              }else{
                                CartInfo.prods.clear();
                              //  ElginpayService().inicializarCancelamento(value:LastTrasition.value , ref: LastTrasition.nsu, data: LastTrasition.data.replaceAll(_bar,"")).then((value){
                                //  print(value);
                                  ConfigPedido.dinheiro=false;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (BuildContext context) => CartProd()),
                                      ModalRoute.withName('/')
                                  );
                              //  });
                              }

                            }, child: Text("Cancelar")),


                        IconButton(onPressed: (){
                          tempExpirado=false;
                          erroNaEmissao=false;

                          verificaNfce();
                          startTimer();




                        }, icon:Image.asset("imagens/refresh.png"),iconSize: 60,)
                      ],
                    ):Text(nfceEmitida?nota:"$_current",style: TextStyle(
                        fontSize: 28
                    ),),
                    nfceEmitida?Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color.fromRGBO(70, 26, 26,1))
                            ),
                            onPressed: (){
                              retornaXML();
                             // impCupom();
                              sendPrinterNFCe();

                            }, child:Container(
                            width: 150,
                            height: 50,
                            child:Center(
                              child:  Text("Imprimir\nDOCUMENTO",textAlign: TextAlign.center,style: TextStyle(
                                  fontSize: 22
                              ),),
                            )
                        )),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      /*  ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color.fromRGBO(70, 26, 26,1))
                            ),
                            onPressed: (){
                              printFicha();

                            }, child: Container(
                            width: 150,
                            height: 50,
                            child:Center(
                              child:  Text("Imprimir Ficha",style: TextStyle(
                                  fontSize: 22
                              ),),
                            )
                        )),*/
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red)
                            ),
                            onPressed: (){
                              ConfigPedido.dinheiro=false;

                              CartInfo.cartId="";
                              CartInfo.prods.clear();

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => CartProd()),
                                  ModalRoute.withName('/')
                              );


                            }, child: Container(
                          width: 150,
                          height: 50,
                          child:Center(
                             child:  Text("Encerrar",style: TextStyle(
                               fontSize: 24
                             ),),
                          )
                        )),
                      ],
                    ):rej?ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(70, 26, 26,1))
                        ),
                        onPressed: (){
                          if(ConfigPedido.dinheiro){

                            //CartInfo.prods.clear();

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => CartProd()),
                                ModalRoute.withName('/')
                            );

                          }else{
                            CartInfo.prods.clear();
                          //  ElginpayService().inicializarCancelamento(value:LastTrasition.value , ref: LastTrasition.nsu, data: LastTrasition.data.replaceAll(_bar,"")).then((value){
                           //   print(value);
                              ConfigPedido.dinheiro=false;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => CartProd()),
                                  ModalRoute.withName('/')
                              );
                           // });
                          }

                        }, child: Text("Cancelar")):Container(),
                  ],
                ),
              )
          );
  }
}
