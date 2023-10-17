import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sammi_gov2/Size.dart';
import 'package:sammi_gov2/Widgets/backPg.dart';
import 'package:sammi_gov2/mapClasses/Pcmd.dart';
import 'package:sammi_gov2/mapClasses/prodXML.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartBack/CartInfo.dart';
import 'package:sammi_gov2/pages/PagaComanda/Fiscal/nfcePage.dart';
import 'package:sammi_gov2/pages/PagaComanda/configPedido/ConfigPedido.dart';

import '../../LocalInfo/EnterpriseConfig.dart';
import '../../Pix/GetConfirmation.dart';
import '../../Pix/PostNewQr.dart';
import '../PagaComanda/prodsCmd.dart';
import '../login.dart';





String valorTotal='0';
String trocoGerado='0';
String valorPago='0';

class PixScreen extends StatefulWidget {
  // const PagDinheiro({Key key}) : super(key: key);

  @override
  _PixScreenState createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {




  double valorAtrelado = 0;
  double troco = 0;
  TextEditingController _moneyControlle = TextEditingController(text: "0.00");
  String pixKey="CÓDIGO COPIA E COLA DO PIX";
  String hash="";










  bool ativo=true;

  enviaNfce() async{


    if(_total-valorAtrelado<=0.01){
      CartInfo.cartId=randomAlphaNumeric(32).toUpperCase();
      List itensList=[];
      List formaPagList=[];


      Map<dynamic, dynamic> pedido = Map();
      pedido["id"]=CartInfo.cartId;
      pedido["numero"]=Random(999999).nextInt(15).toString();
      pedido["tipo"]="Balcão";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
      pedido["datahora"]=formattedDate;
      pedido["total_itens"]=_total;
      pedido["total_geral"]=_total;
      pedido["valor_acrescimo"]=0;
      pedido["valor_desconto"]=0;
      pedido["valor_frete"]=0;
      pedido["cod_fun"]=codVend;

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
      formaPag["id_forma"]=17;
      formaPag["valor_forma"]=valorAtrelado;
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
      Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>Nfce()));

    }
    else{
      ativo=true;
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "O valor informado precisa ser igual ou maior ao total da compra!"));

          });}

  }

  double total_prod=0;


  ScreenSize _size=ScreenSize();



double _total=0;


  addvalu() {
    total_prod = CartInfo.prods
        .map<double>((m) => double.parse(m.VLR_PRECO)*double.parse(m.VLR_QTDE))
        .reduce((a, b) => a + b);
    _total = total_prod;
    valorAtrelado=total_prod;
  }


  void initState() {


    addvalu();

    PostNewQr().postCieloOrder(_total).then((value){

      setState(() {
        pixKey=value['message']['qrcode'];
        hash=value['message']['hash'];
        print('gerado');
        verificaPagamento();

      });

    });

    super.initState();
  }
  int x=0;



  void verificaPagamento()async{
    x=0;


    while(x<600){

      GetConfirmation().getConf(hash).then((value){
        print(x);

        if(value["message"]["pago"]==true){
          x=x+5000;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(title: Text("Pagamento realizado com sucesso!"));
              }).then((value){
            setState(() {

              enviaNfce();
            });
          });

        }else{

        }



      });

     await Future.delayed(Duration(seconds: 4));
      x++;
    }


  }

  @override
  void dispose() {
    x=x+5000;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: backPg(context),
      body:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: _size.getWidth(context),
                child: Scaffold(
                    appBar: AppBar(
                      title: GestureDetector(onTap: (){},
                        child:Text("Formas de pagamento") ,),
                      centerTitle: true,
                      backgroundColor: Color.fromRGBO(185, 79, 79, 1),
                      foregroundColor: Colors.white,
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          /* Container(
                        height: _size.getHeight(context)*0.05,
                      ),
                      Container(
                        width: _size.getWidth(context)*0.8,
                        child: Text("Pague com segurança via PIX",textAlign: TextAlign.start,style: TextStyle(fontSize: 20),),
                      ),
                      Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.01)),
                      Container(
                        height: _size.getHeight(context)*0.2,
                        width: _size.getWidth(context)*0.8,
                        child: hash.isEmpty?CircularProgressIndicator():Image.network('https://sandbox.pensebank.com.br/QRCode/$hash'),
                      ),
                      Container(
                        height: _size.getHeight(context)*0.2,
                        width: _size.getWidth(context)*0.8,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(214, 214, 214, 1),
                            width: 2.5
                          )
                        ),
                        child: Padding(padding: EdgeInsets.all(4),
                        child: SelectableText(
                          pixKey,

                        ),
                        ),
                      ),
                      Text("Clique no botão copiar código abaixo e efetue o pagamento no seu aplicativo bancário, e retorne para acompanhar o processo.",
                      style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.withOpacity(0.8)),),*/
                          Padding(
                              padding: EdgeInsets.only(
                                  top: _size.getHeight(context) *
                                      0.01)),
                          Text("Pague com segurança via PIX",style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20
                          ),),
                          Padding(
                            padding: EdgeInsets.only(top: _size.getHeight(context) *
                                0.01,),
                          ),
                          Container(
                            width: _size.getWidth(context)*0.9,
                            height: _size.getHeight(context)*0.35,
                            child: Image.network('https://sandbox.pensebank.com.br/QRCode/$hash'),),
                          Container(
                            width: _size.getWidth(context)*0.95,
                            height:  _size.getHeight(context)*0.15,
                            //color: Colors.grey.withOpacity(0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: _size.getHeight(context) *
                                            0.01)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: _size.getWidth(context) *
                                          0.4,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total:",
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: _size.getWidth(context) *
                                          0.4,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "R\$" +
                                                _total.toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: _size.getHeight(context) *
                                            0.01)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.025)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  GetConfirmation().getConf(hash).then((value){

                                    if(value["message"]["pago"]==true){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(title: Text("Pagamento realizado com sucesso!"));
                                          }).then((value){
                                        setState(() {
                                          enviaNfce();
                                        });
                                      });

                                    }else{
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(title: Text("Pagamento não encontado!"));
                                          });
                                    }



                                  });


                                },
                                child: Container(
                                  height: 75,
                                  width: _size.getWidth(context) * 0.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('VERIFICAR PAGAMENTO',style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      Text('CONFIRMAR PAGAMENTO E GERAR NFCE',textAlign: TextAlign.center, style: TextStyle(
                                        fontSize: 14,

                                      ),)
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromRGBO(2, 104, 93, 1))),
                              ),
                              Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.025)),
                              Container(width: _size.getWidth(context),),
                             /* ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: _size.getWidth(context) * 0.3,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                          ),
                                          Text('  Cancelar')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromRGBO(125, 118, 118, 1)),
                                ),
                              ),*/
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.025)),



                        ],
                      ),
                    )
                ))])
    );
  }
}
