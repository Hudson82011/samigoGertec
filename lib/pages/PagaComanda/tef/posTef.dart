import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sammi_gov2/mapClasses/Pcmd.dart';
import 'package:sammi_gov2/pages/PagaComanda/Fiscal/nfcePage.dart';
import 'package:sammi_gov2/printer/printer.dart';

import '../../login.dart';
import '../prodsCmd.dart';
import '../selectCmd.dart';
import 'lastTransition.dart';
import 'tefPayOptions.dart';




class PosTef extends StatefulWidget {
  //const PosTef({Key key}) : super(key: key);



  @override
  _PosTefState createState() => _PosTefState();
}

class _PosTefState extends State<PosTef> {



  PrinterService _printer=PrinterService();



  enviaNfce()async{

    /*List itensList=[];
    List formaPagList=[];
    id=randomAlphaNumeric(32).toUpperCase();
    print(id);
    print(forma);

    Map<dynamic, dynamic> pedido = Map();
    pedido["id"]=id;
    pedido["numero"]=_prodscmd[0].DOCUMENTO;
    pedido["tipo"]="Balcão";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
    pedido["datahora"]=formattedDate;
    pedido["total_itens"]=total;
    pedido["total_geral"]=total;
    pedido["valor_acrescimo"]=0;
    pedido["valor_desconto"]=0;
    pedido["valor_frete"]=0;

    for(var x in _prodscmd){
      Map<dynamic, dynamic> itens = Map();
      itens["codigo"] = x.COD_PROD;
      itens["descricao"] = x.DESCRICAO;
      itens["unidade"] = x.FLG_UNIDADE_VENDA;
      itens["valor_unitario"] = x.VLR_PRECO;
      itens["quantidade"] = x.VLR_QTDE;
      itens["valor_total"] = x.VLR_PRECO_CMD;
      itens["valor_desconto"] = 0;
      itens["valor_acrescimo"] = 0;

      itensList.add(itens);
    }

    Map<dynamic, dynamic> formaPag = Map();
    formaPag["id_forma"]=forma;
    formaPag["valor_forma"]=total.toStringAsFixed(2);
    formaPagList.add(formaPag);


    Map<dynamic, dynamic> nota = Map();
    nota["pedido"] = pedido;
    nota["itens"] = itensList;
    nota["forma_pag"] = formaPagList;

    print(nota);
    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ReceberPedido/$banco";
    var response = await http.post(Uri.parse(url),
        headers: {'authorization': auth}, body: json.encode(nota));/*.onError((
          error, stackTrace) {
         showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Falha ao enviar NFCE, verifique o servidor!"));
            });
      });*/*/
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SelectCmd()),
        ModalRoute.withName('/')
    );

  }

  double total_prod=0;



  Codec<String, String> stringToBase64 = utf8.fuse(base64);






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: 35,
                width: 600,
                color: Color.fromRGBO(70, 26, 26,1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      enviaNfce();
                    }
                    ,child: Container(
                    width: 82,
                    height: 70,
                    color: Color.fromRGBO(219,166,86,1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_shopping_cart_sharp),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text("Nova\ncompra",textAlign: TextAlign.center,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),)
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ],
          )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.amber,
                      width: 4
                  )
              ),
              width: 300,
              height: 400,
              child:SingleChildScrollView(
                child: Text('*********** VIA DA LOJA ***********\n'+LastTrasition.params["comprovanteDiferenciadoLoja"].toString()),
              )
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text("Sucesso na execução da função.",
            style: TextStyle(
                fontSize: 22
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  _printer.connectInternalImp();
                  _printer.printerCupomTEF(LastTrasition.params["comprovanteGraficoLojista"]);
                  _printer.jumpLine(5);

                 /* imprimirTexto('*********** VIA DA LOJA ***********\n'+jsonLoja,17);
                  avancaLinhas(150);
                  finalizarImpressao();*/
                },
                child:Container(
                  height: 80,
                  width: 80,
                  color: Color.fromRGBO(165, 206, 255, 1),
                  child: Column(
                    children: [
                      Image.asset("imagens/imp.png"),
                      Text("Via loja",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ) ,
              ),
              Padding(padding: EdgeInsets.only(left: 120)),
              GestureDetector(
                onTap: (){
                  /*imprimirTexto('*********** VIA DA LOJA ***********\n'+jsonCliente,17);
                  avancaLinhas(150);
                  finalizarImpressao();*/
                },
                child:Container(
                  height: 80,
                  width: 80,
                  color: Color.fromRGBO(255, 168, 194, 1),
                  child: Column(
                    children: [
                      Image.asset("imagens/imp.png"),
                      Text("Via cliente")
                    ],
                  ),
                ) ,
              ),

            ],
          )
        ],

      ),
    );
  }
}