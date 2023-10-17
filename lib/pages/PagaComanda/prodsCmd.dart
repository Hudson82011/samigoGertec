import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sammi_gov2/mapClasses/Pcmd.dart';
import 'package:sammi_gov2/pages/PagaComanda/selectCmd.dart';
import 'package:sammi_gov2/pages/PagaComanda/tef/tefPayOptions.dart';
import 'package:sammi_gov2/printer/printer.dart';


import '../../LocalInfo/EnterpriseConfig.dart';
import '../login.dart';
import 'money/PagDinheiro.dart';



double total=0;
int cmdLen=0;
var documentoCmd;
double total_prod=0;
String id="";

class ProdsCmd extends StatefulWidget {
  @override
  _ProdsCmdState createState() => _ProdsCmdState();
}

class _ProdsCmdState extends State<ProdsCmd> {
  List<Pcmd> _prodscmd = [];

  PrinterService _printer=PrinterService();

  Future<List<Pcmd>> retornaJsonp() async {

    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_MostrarComandasItens/$banco/$Cmd_nota/";
    var response = await http.get(Uri.parse(url), headers: {'authorization': auth});
    List<Pcmd> prodscmd = [];
    print(response.body);
    var prodsJson = json.decode(response.body);
    for (var prodJson in prodsJson) {
      prodscmd.add(Pcmd.fromJson(prodJson));

    }

    print(prodscmd);
    return prodscmd;
  }

  addvalu() {
    total_prod = _prodscmd
        .map<double>((m) => double.parse(m.VLR_PRECO)*double.parse(m.VLR_QTDE))
        .reduce((a, b) => a + b);
    total = total_prod;
    print(total);
  }





  connectInternalImp() async {
    int result = await _printer.connectInternalImp();
    print("Internal: " + result.toString());
  }




  String space1= " ";
String space2= "⠀⠀";
String space4= "⠀⠀⠀⠀";
String space8= "⠀⠀⠀⠀⠀⠀⠀⠀     ";
String space5= "⠀⠀⠀⠀⠀     ";
String zero6="000000";


  impCupom(){



 //  print(_printer.getStatusPrinter());

   // _printer.connectInternalImp();


    _printer.sendPrinterText( text: "TECNOWEB INFORMATICA\n",
      fontSize: 17,
        font: "FONT B",
      align: 'Centralizado',
      isBold: false
    );
    _printer.sendPrinterText( text: "Relatorio de comanda\n",
        fontSize: 17,
        font: "FONT B",
        align: 'Centralizado',
        isBold: false
    );
    _printer.sendPrinterText( text: "--------------------\n",
        fontSize: 17,
        font: "FONT B",
        align: 'Centralizado',
        isBold: false
    );
    _printer.sendPrinterText( text: "COMANDA $Cmd_nota\n",
        fontSize: 17,
        font: "FONT B",
        align: 'Centralizado',
        isBold: false
    );
    _printer.sendPrinterText( text: _prodscmd[0].DATA+"\n",
        fontSize: 17,
        font: "FONT B",
        align: 'Centralizado',
        isBold: false
    );
    _printer.sendPrinterText( text: "--------------------\n",
        fontSize: 17,
        font: "FONT B",
        align: 'Centralizado',
        isBold: false
    );
    _printer.sendPrinterText( text: "COD   "+"DESC  "+"QTD "+"TOTAL\n",
        fontSize: 17,
        font: "FONT B",
        align: 'Esquerda',
        isBold: false);
    for(var prod in _prodscmd){
      _printer.sendPrinterText(text:((zero6+prod.COD_PROD).substring(prod.COD_PROD.length,prod.COD_PROD.length+6)+"-"+(prod.DESCRICAO+space8).substring(0,12)+space2+(double.parse(prod.VLR_QTDE).toStringAsFixed(3)+space4).substring(0,5)+" "+(double.parse(prod.VLR_TOTAL).toStringAsFixed(2))+"\n"),
          fontSize: 0,
          font: "FONT A",
          align: 'Centralizado',
          isBold: true
      );
    }
    _printer.sendPrinterText( text: "--------------------\n",
        fontSize: 17,
        font: "FONT B",
        align: 'Centralizado',
        isBold: false
    );
    _printer.sendPrinterText( text: "Total: \R\$ ${total.toStringAsFixed(2)}",
        fontSize: 17,
        font: "FONT B",
        align: 'Centralizado',
        isBold: false);


    //finalizarImpressao();


    _printer.sendPrinterBarCode(
      barCodeType: "CODE 39",
      align: "Centralizado",
      text: Cmd_nota,
      height: 200,
      width: 6

    ).then((value) => print(value));
    _printer.jumpLine(5);


  }





  refreshPage() {
    _prodscmd=[];
    retornaJsonp().then((value) {
      setState(() {
        _prodscmd.addAll(value);
        addvalu();
        cmdLen=_prodscmd.length;
        documentoCmd=_prodscmd[0].DOCUMENTO;

      });
    });

  }





  void initState() {
    connectInternalImp();
    retornaJsonp().then((value) {
      setState(() {
        _prodscmd.addAll(value);
        addvalu();
        cmdLen=_prodscmd.length;
        documentoCmd=_prodscmd[0].DOCUMENTO;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: (){
           /* Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) =>Nfce()));*/
          },
          child: Image.asset("imagens/sammigo 1.png",scale: 1.8,),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar:BottomAppBar(
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
                  onTap: (){   if(_prodscmd.isNotEmpty){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) =>PageTefOpt()));}else{print('aguarde');}}
                  ,child: Container(
                  width: 82,
                  height: 70,
                  color: Color.fromRGBO(219,166,86,1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("imagens/card.png",scale: 3.5),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text("CARTÃO",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),)
                    ],
                  ),
                ),
                ),
                GestureDetector(
                  onTap: (){
                   if(_prodscmd.isNotEmpty){
                   /*  Navigator.push(
                         context,
                         MaterialPageRoute(builder: (BuildContext context) =>PagDinheiro()));*/
                   }else{
                     print('aguarde');
                   }

                  }
                  ,child: Container(
                  width: 82,
                  height: 70,
                  color: Color.fromRGBO(219,166,86,1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("imagens/money.png",scale: 5),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text("DINHEIRO",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),)
                    ],
                  ),
                ),
                ),
                GestureDetector(
                  onTap: () {  if(_prodscmd.isNotEmpty){impCupom();}}
                  ,child: Container(
                  width: 82,
                  height: 70,
                  color: Color.fromRGBO(219,166,86,1),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("imagens/imp.png",scale: 1),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      Text("IMPRIMIR",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),)
                    ],
                  ),
                ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  }
                  ,child: Container(
                  width: 82,
                  height: 70,
                  color: Color.fromRGBO(219,166,86,1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("imagens/voltar.png",scale: 3),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text("VOLTAR",style: TextStyle(
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
      body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
             Row(
               children: [
                 Padding(padding: EdgeInsets.only(left: 5)),
                 Text(
                   "Produtos consumidos na Comanda: ",
                   style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold),
                 ),
                 Text(
                   Cmd_nota,
                   style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold,
                   color: Color.fromRGBO(169, 36, 18,1)),
                 ),
               ],
             ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Text(
                    "Cód.",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  Container(
                    width: 170,
                    child: Text(
                      "Descrição",
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                  ),
                  Text(
                    "Qtde.",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  Text(
                    "Valor",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  /*Text(
                  "Exc.",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),*/
                ],
              ),
              FutureBuilder<List<Pcmd>>(
                future: retornaJsonp(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapshot.hasError) {
                        Center(
                          child: Text("Erro de conexão, verifique a rede!"),
                        );
                      } else {
                        return Expanded(
                            child: Container(
                                height: 290,
                                child: ListView.builder(
                                    itemCount: _prodscmd.length,
                                    itemBuilder: (context, index) {
                                      return _cardprod(index);
                                    })));
                      }
                  }
                  return Container(
                    child:  Center(
                      child:Column(
                      children: [
                      Text("Erro de conexão, verifique sua rede!"
                  ),
                  IconButton(icon: Icon(Icons.refresh), onPressed: (){
                  setState(() {
                  refreshPage();

                  });
                  })
                  ],
                  )
                  ));
                },
              ),


            ],
          )),
    );
  }

  _cardprod(index) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          /*Container(
            height: 30,
            width: 30,
            child:Center(
              child:  Text(_prodscmd[index].NUM_COMANDA,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green
            ),
          ),*/
          Container(
            height: 30,
            width: 40,
            child:Center(
              child:  Text(_prodscmd[index].COD_PROD,
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ),
          ),
          Container(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _prodscmd[index].DESCRICAO,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  _prodscmd[index].OBS==null?"Sem observação":_prodscmd[index].OBS.toString(),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 9),
                ),
              ],
            ),
          ),
          Text(
            "${_prodscmd[index].VLR_QTDE}${_prodscmd[index].FLG_UNIDADE_VENDA}",
            style: TextStyle(fontSize: 12),
          ),
          Text(double.parse(_prodscmd[index].VLR_TOTAL).toStringAsFixed(2),
              style: TextStyle(fontSize: 13)),
          /*Container(
            child: Image.asset(
              "images/cancel.png",
              scale: 12,
            ),
          )*/
        ],
      ),
    );
  }
}
