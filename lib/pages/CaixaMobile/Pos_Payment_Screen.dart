import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sammi_gov2/LocalInfo/LocalBase.dart';
import 'package:sammi_gov2/Widgets/backPg.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartBack/CartInfo.dart';
import 'package:sammi_gov2/pages/PagaComanda/Fiscal/nfcePage.dart';
import 'package:sammi_gov2/pages/PagaComanda/configPedido/ConfigPedido.dart';
import 'package:sammi_gov2/printer/printer.dart';

import '../../LocalInfo/EnterpriseConfig.dart';
import '../PagaComanda/prodsCmd.dart';
import '../login.dart';





class PosPaymentScreen extends StatefulWidget {
  // const PagDinheiro({Key key}) : super(key: key);

  @override
  _PosPaymentScreenState createState() => _PosPaymentScreenState();
}

class _PosPaymentScreenState extends State<PosPaymentScreen> {





  double troco = 0;
  TextEditingController _moneyControlle = TextEditingController(text: "0.00");
 // int m1 = 0, m05 = 0, m025 = 0, m01 = 0, m005 = 0, m001 = 0;
 // int n100 = 0, n50 = 0, n20 = 0, n10 = 0, n05 = 0, n02 = 0;




int forma=3;




  bool ativo=true;

  enviaNfce() async{


    if(_selected['type'].isEmpty){

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Selecione uma bandeira para prosseguir!"));});

    }else {
      if (_selected['type'] == "cred") {
        forma = 3;
      } else {
        forma = 4;
      }


      CartInfo.cartId = randomAlphaNumeric(32).toUpperCase();
      List itensList = [];
      List formaPagList = [];


      Map<dynamic, dynamic> pedido = Map();
      pedido["id"] = CartInfo.cartId;
      pedido["numero"] = Random(999999).nextInt(15).toString();
      pedido["tipo"] = "Balcão";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
      pedido["datahora"] = formattedDate;
      pedido["total_itens"] = total;
      pedido["total_geral"] = total;
      pedido["valor_acrescimo"] = 0;
      pedido["valor_desconto"] = 0;
      pedido["valor_frete"] = 0;
      pedido["cod_fun"] = codVend;

      for (var x in CartInfo.prods) {
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
      formaPag["id_forma"] = forma;
      formaPag["valor_forma"] = total;
      formaPagList.add(formaPag);


      Map<dynamic, dynamic> nota = Map();
      nota["pedido"] = pedido;
      nota["itens"] = itensList;
      nota["forma_pag"] = formaPagList;

      print(nota);

      var url =
          "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ReceberPedido/$banco/${EnterpriseConfig.deviceId}";
      print(url);
      var response = await http.post(Uri.parse(url),
          headers: {'authorization': auth}, body: json.encode(nota)); /*.onError((
          error, stackTrace) {
         showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Falha ao enviar NFCE, verifique o servidor!"));
            });
      });*/
      ConfigPedido.dinheiro = true;
      Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Nfce()));
    }

  }

  double total_prod=0;








  addvalu() {
    total_prod = CartInfo.prods
        .map<double>((m) => double.parse(m.VLR_PRECO)*double.parse(m.VLR_QTDE))
        .reduce((a, b) => a + b);
    total = total_prod;
  }


  void initState() {


    addvalu();

    super.initState();
  }


  Map<String,dynamic>_selected={
    "type":"",
    "id":-1
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: backPg(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total: ",
                style: TextStyle(color: Colors.black, fontSize: 26),
              ),
              Text(
                "R\$"+total.toStringAsFixed(2),
                style: TextStyle(
                    color: Color.fromRGBO(228, 10, 10, 1), fontSize: 38,fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left:7.5)),
              Text("Crédito",style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(24, 44, 221, 1),
                fontWeight: FontWeight.bold
              ),),
            ],
          ),
          Container(
            height: 150,
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 3),
            child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:0.9,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 2.5
                  //childAspectRatio: 1,
                  //crossAxisSpacing: 1,
                ),
                itemCount: LocalBase.cred.length,
                itemBuilder: (context, index) {
                  return  _cred(index);
                }),)
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left:7.5)),
              Text("Débito",style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(218, 22, 22, 1),
                fontWeight: FontWeight.bold
              ),),
            ],
          ),
          Container(
              height: 150,
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 3),
                child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:0.9,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 2.5
                      //childAspectRatio: 1,
                      //crossAxisSpacing: 1,
                    ),
                    itemCount:LocalBase.debt.length,
                    itemBuilder: (context, index) {
                      return  _debt(index);
                    }),)
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            /*  ElevatedButton(
                  onPressed: () {
                   Navigator.pop(context);

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.35,
                    height: MediaQuery.of(context).size.height*0.085,
                    child: Center(
                      child: Text("Limpar",style: TextStyle(fontSize: 24),),
                    )
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red))),*/
              ElevatedButton(
                onPressed: () {

                  enviaNfce();


                },
                child:Container(
                    width: MediaQuery.of(context).size.width*0.35,
                    height: MediaQuery.of(context).size.height*0.085,
                    child: Center(
                      child: Text("Finalizar",style: TextStyle(fontSize: 24),),
                    )
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(70, 26, 26, 1))),
              ),
            ],
          )

        ],
      ),
    );
  }

  Widget _cred(index){
    return GestureDetector(
      onTap: (){
        setState(() {
          _selected={
            "type":"cred",
            "id":LocalBase.cred[index].id
          };
        });
      },
      child: Column(
        children: [
        Container(
        width: 100,
        decoration: BoxDecoration(
            border: Border.all(
                color: _selected["type"]=="cred"?_selected["id"]==LocalBase.cred[index].id?Colors.red:Colors.transparent:Colors.transparent,
                width: 3.5
            ),
            borderRadius: BorderRadius.circular(12)
        ),

        child: Image.asset("imagens/cards/${LocalBase.cred[index].id_imagem.toString()}.png",fit: BoxFit.fill,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Icon(Icons.credit_card);
          },),

      ), Text(LocalBase.cred[index].nome,style: TextStyle(
              fontSize: 10
          ),)
        ],
      ));
  }



  Widget _debt(index){
    return GestureDetector(
      onTap: (){
        setState(() {
          _selected={
            "type":"debt",
            "id":LocalBase.debt[index].id
          };
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
                border: Border.all(
                    color: _selected["type"]=="debt"?_selected["id"]==LocalBase.debt[index].id?Colors.red:Colors.transparent:Colors.transparent,
                    width: 3.5
                ),
                borderRadius: BorderRadius.circular(12)
            ),
            child:  Image.asset("imagens/cards/${LocalBase.debt[index].id_imagem.toString()}.png",fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Column(
                  children: [
                    Text(LocalBase.debt[index].nome),
                    Icon(Icons.credit_card)
                  ],
                );
              },),

          ),Text(LocalBase.debt[index].nome,style: TextStyle(
            fontSize: 10
          ),)
        ],
      )
    );
  }


}
