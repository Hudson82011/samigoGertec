import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sammi_gov2/elginPay/ElginPay.dart';
import 'package:sammi_gov2/mapClasses/Pcmd.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartBack/CartInfo.dart';
import 'package:sammi_gov2/pages/CaixaMobile/tef/TefPage.dart';
import 'package:sammi_gov2/pages/PagaComanda/Fiscal/nfcePage.dart';
import 'package:sammi_gov2/pages/PagaComanda/configPedido/ConfigPedido.dart';
import 'package:sammi_gov2/pages/PagaComanda/money/PagDinheiro.dart';
import 'package:sammi_gov2/printer/printer.dart';

import '../../LocalInfo/EnterpriseConfig.dart';
import '../PagaComanda/tef/lastTransition.dart';
import '../login.dart';
import 'PixScreen.dart';
import 'Pos_Payment_Screen.dart';



int forma=0;


class PaymentType extends StatefulWidget {
  @override
  _PaymentTypeState createState() => _PaymentTypeState();
}

class _PaymentTypeState extends State<PaymentType> {


  TextEditingController inputValue = new TextEditingController();

  ElginpayService elginpayService = new ElginpayService();

  String selectedPaymentMethod = "Crédito";
  String selectedInstallmentsMethod = "Avista";

  String boxText = '';
  String retornoUltimaVenda = '';


  Map<String,dynamic>params=Map();


  PrinterService printerService = new PrinterService();









  enviaNfce()async{

    List itensList=[];
    List formaPagList=[];
    CartInfo.cartId=randomAlphaNumeric(32).toUpperCase();
    print(CartInfo.cartId);
    print(forma);

    Map<dynamic, dynamic> pedido = Map();
    pedido["id"]=CartInfo.cartId;
    pedido["numero"]="";
    pedido["tipo"]="Balcão";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
    pedido["datahora"]=formattedDate;
    pedido["total_itens"]=total;
    pedido["total_geral"]=total;
    pedido["valor_acrescimo"]=0;
    pedido["valor_desconto"]=0;
    pedido["valor_frete"]=0;

    for(var x in CartInfo.prods){
      Map<dynamic, dynamic> itens = Map();
      itens["codigo"] = x.COD_PROD;
      itens["descricao"] = x.DESCRICAO;
      itens["unidade"] = x.FLG_UNIDADE_VENDA;
      itens["valor_unitario"] = x.VLR_PRECO;
      itens["quantidade"] = x.VLR_QTDE;
      itens["valor_total"] = x.VLR_TOTAL;
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
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ReceberPedido/$banco/${EnterpriseConfig.deviceId}";
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
      });*/
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Nfce()),
        ModalRoute.withName('/')
    );

  }

 // List<Pcmd> _prodscmd = [];

  double total_prod=0;
  double total=0;


  addvalu() {
    total_prod = CartInfo.prods
        .map<double>((m) => double.parse(m.VLR_TOTAL))
        .reduce((a, b) => a + b);
    total = total_prod;
  }




  //Handler para capturar retorno do ElginPay
  Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "elginpayConcluido":
        setState(() {
          this.retornoUltimaVenda = call.arguments['saida'];
        });


        params=json.decode(this.retornoUltimaVenda);

        if(params["mensagemResultado"]=="Operacao cancelada"){

        }else if(params["mensagemResultado"]=="Transacao autorizada"){

          enviaNfce();
          LastTrasition.params=params;
          LastTrasition.nsu=params["nsuTerminal"];
          LastTrasition.data=params["dataHoraTransacao"];
          LastTrasition.value=inputValue.text = total.toStringAsFixed(2);

        }
        break;
      default:
        throw MissingPluginException();
    }
  }

  sendElginPayParams(String function) async {
    if (function == "SALE") {
      if (selectedPaymentMethod == "Débito") {
        elginpayService.inicializarPagamentoDebito(value: inputValue.text).then(
                (value) => elginpayService.setHandler(_methodCallHandler));
      } else {
        elginpayService.inicializarPagamentoCredito(
            value: inputValue.text,
            installmentMethod: /*this.selectedInstallmentsMethod*/"Avista").then((value) => elginpayService.setHandler(_methodCallHandler));
      }
    } else if (function == "CANCEL") {
      // elginpayService.inicializarCancelamento(value: inputValue.text);
    } else {
      elginpayService.inicializarOperacaoAdministrativa();
    }
  }

  void initState() {
    setState(() {

      addvalu();


    });

    super.initState();
  }



  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: backPg(context),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(70, 26, 26, 1),
        title: Image.asset("imagens/sammigo 1.png",scale: 3.5,),
        centerTitle: true,
      ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Total:",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                Text(
                  "R\$"+total.toStringAsFixed(2),
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold, fontSize: 32,)
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) =>PagDinheiro()));


                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(90,131, 117, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 35,
                              child:   Image.asset('imagens/dinheiro.png'),
                            ),
                            Text(
                              "DINHEIRO",
                              style: TextStyle(fontSize: 38),
                            ),
                          ],
                        )
                    ))),
            ElevatedButton(
                onPressed: () {
                  Elgin().sendSitefParams(
                      Acao.VENDA,
                      CartInfo.total()
                          .toStringAsFixed(2)
                          .replaceAll(".", "")
                          .replaceAll(",", ""),
                      "1",
                      FormaPagamento.DEBITO,
                      context);
                  ConfigPedido.dinheiro = false;
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(64, 59, 51, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 70,
                              height: 35,
                              child: Image.asset("imagens/debt.png"),
                            ),
                            Text(
                              "DÉBITO",
                              style: TextStyle(fontSize: 38),
                            ),
                          ],
                        )
                    ))),

            ElevatedButton(
                onPressed: () {
                  Elgin().sendSitefParams(
                      Acao.VENDA,
                      CartInfo.total()
                          .toStringAsFixed(2)
                          .replaceAll(".", "")
                          .replaceAll(",", ""),
                      "1",
                      FormaPagamento.CREDITO,
                      context);
                  ConfigPedido.dinheiro = false;

                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(211, 100, 59, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 35,
                            child: Image.asset("imagens/cred.png",),
                          ),
                          Text(
                            "CRÉDITO",
                            style: TextStyle(fontSize: 38),
                          ),
                        ],
                      )
                    ))),
            ElevatedButton(
                onPressed: () {
                  // inputValue.text = /*total.toStringAsFixed(2)*/"1.01";
                  // String selectedPaymentMethod = "";
                 // sendElginPayParams("");
                 // ConfigPedido.dinheiro=false;
                /*  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Funcionalidade não implementada."),
                        );
                      });*/
                 Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) =>PixScreen()));
                 /* showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text(
                                "Pix não habilitado!"));
                      });*/
                },

                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(29, 151, 168, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                      child:Row(
                        children: [
                         Container(
                           width: 70,
                           height: 35,
                           child:  Image.asset('imagens/pix.png'),
                         ),
                          Text(
                            "PIX",
                            style: TextStyle(fontSize: 38),
                          ),
                        ],
                      )
                    ))),
            ElevatedButton(
                onPressed: () {
                  // inputValue.text = /*total.toStringAsFixed(2)*/"1.01";
                  // String selectedPaymentMethod = "";
                  // sendElginPayParams("");
                  // ConfigPedido.dinheiro=false;
                  /*  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Funcionalidade não implementada."),
                        );
                      });*/
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) =>PosPaymentScreen()));
                },

                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(185, 79, 79, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                        child:Row(
                          children: [
                            Container(
                              width: 70,
                              height: 35,
                              child:  Image.asset('imagens/outros.png'),
                            ),
                            Text(
                              "OUTROS",
                              style: TextStyle(fontSize: 38),
                            ),
                          ],
                        )
                    ))),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01))
            /*ElevatedButton(
                onPressed: () {
                  precoVenda.text = total.toStringAsFixed(2);
                  realizarFuncao("funcoes", tefSelecionado);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(167, 101, 2, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                      child: Text(
                        "FUNÇÕES",
                        style: TextStyle(fontSize: 38),
                      ),
                    ))),
            ElevatedButton(
                onPressed: () {
                  precoVenda.text = total.toStringAsFixed(2);
                  realizarFuncao("reimpressao", tefSelecionado);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(167, 101, 2, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                      child: Text(
                        "REIMPRESSÃO",
                        style: TextStyle(fontSize: 38),
                      ),
                    )))*/
          ]),
        ));
  }

}
