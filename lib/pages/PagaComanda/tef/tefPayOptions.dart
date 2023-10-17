import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sammi_gov2/elginPay/ElginPay.dart';
import 'package:sammi_gov2/mapClasses/Pcmd.dart';
import 'package:sammi_gov2/pages/PagaComanda/Fiscal/nfcePage.dart';
import 'package:sammi_gov2/printer/printer.dart';

import '../../../LocalInfo/EnterpriseConfig.dart';
import '../../login.dart';
import '../prodsCmd.dart';
import '../selectCmd.dart';
import 'lastTransition.dart';
import 'posTef.dart';


int forma=0;


class PageTefOpt extends StatefulWidget {
  @override
  _PageTefOptState createState() => _PageTefOptState();
}

class _PageTefOptState extends State<PageTefOpt> {


  TextEditingController inputValue = new TextEditingController();

  ElginpayService elginpayService = new ElginpayService();

  String selectedPaymentMethod = "Crédito";
  String selectedInstallmentsMethod = "Avista";

  String boxText = '';
  String retornoUltimaVenda = '';


  Map<String,dynamic>params=Map();


  PrinterService printerService = new PrinterService();


  Future<List<Pcmd>> retornaJsonp() async {

    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_MostrarComandasItens/$banco/$Cmd_nota/";
    var response = await http.get(Uri.parse(url), headers: {'authorization': auth});
    List<Pcmd> prodscmd = [];
    var prodsJson = json.decode(response.body);
    for (var prodJson in prodsJson) {
      prodscmd.add(Pcmd.fromJson(prodJson));

    }

    print(prodscmd);
    return prodscmd;
  }







  enviaNfce()async{

    List itensList=[];
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

  List<Pcmd> _prodscmd = [];



  addvalu() {
    total_prod = _prodscmd
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

      retornaJsonp().then((value) {
        setState(() {
          _prodscmd.addAll(value);
          //addvalu();
        });
      });


    });

    super.initState();
  }



  Widget build(BuildContext context) {
    return Scaffold(
       // bottomNavigationBar: backPg(context),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total:",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                Text(
                 "R\$"+total.toStringAsFixed(2),
                  style: TextStyle(color: Colors.red, fontSize: 22),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ElevatedButton(
                onPressed: () {
                  forma=4;
                  inputValue.text = total.toStringAsFixed(2);
                  selectedPaymentMethod = "Credito";
                  sendElginPayParams("SALE");

                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(167, 101, 2, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                      child: Text(
                        "CRÉDITO",
                        style: TextStyle(fontSize: 38),
                      ),
                    ))),
            ElevatedButton(
                onPressed: () {
                  forma=4;
                  inputValue.text = total.toStringAsFixed(2);
                  selectedPaymentMethod = "Débito";
                  sendElginPayParams("SALE");
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(184, 132, 53, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                      child: Text(
                        "DÉBITO",
                        style: TextStyle(fontSize: 38),
                      ),
                    ))),
            ElevatedButton(
                onPressed: () {
                 // inputValue.text = /*total.toStringAsFixed(2)*/"1.01";
                 // String selectedPaymentMethod = "";
                  sendElginPayParams("");
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(202, 160, 99, 1))),
                child: Container(
                    height: 70,
                    width: 260,
                    child: Center(
                      child: Text(
                        "OUTROS",
                        style: TextStyle(fontSize: 38),
                      ),
                    ))),
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
