import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sammi_gov2/Widgets/backPg.dart';
import 'package:sammi_gov2/mapClasses/Pcmd.dart';
import 'package:sammi_gov2/mapClasses/prodXML.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartBack/CartInfo.dart';
import 'package:sammi_gov2/pages/PagaComanda/Fiscal/nfcePage.dart';
import 'package:sammi_gov2/pages/PagaComanda/configPedido/ConfigPedido.dart';

import '../../../LocalInfo/EnterpriseConfig.dart';
import '../../login.dart';
import '../prodsCmd.dart';
import '../selectCmd.dart';



String valorTotal='0';
String trocoGerado='0';
String valorPago='0';

class PagDinheiro extends StatefulWidget {
 // const PagDinheiro({Key key}) : super(key: key);

  @override
  _PagDinheiroState createState() => _PagDinheiroState();
}

class _PagDinheiroState extends State<PagDinheiro> {
  double valorAtrelado = 0;
  double troco = 0;
  TextEditingController _moneyControlle = TextEditingController(text: "0.00");
  int m1 = 0, m05 = 0, m025 = 0, m01 = 0, m005 = 0, m001 = 0;
  int n100 = 0, n50 = 0, n20 = 0, n10 = 0, n05 = 0, n02 = 0;









  bool ativo=true;

  enviaNfce() async{

    if(total-valorAtrelado<=0.01){
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
      pedido["total_itens"]=total;
      pedido["total_geral"]=total;
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
      formaPag["id_forma"]=1;
      formaPag["valor_forma"]=valorAtrelado;
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
      ConfigPedido.dinheiro=true;
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
          Container(
            height: 80,
            width: 200,
            child: TextFormField(
                controller: _moneyControlle,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),],
                style: TextStyle(
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    valorAtrelado = double.parse(value);
                    if(double.parse(valorTotal)>double.parse(value)){
                      troco=double.parse(valorTotal)-double.parse(value);
                      print(troco);
                    }else{
                      troco=0;
                    }
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                  labelStyle: TextStyle(fontStyle: FontStyle.italic),
                  focusColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      width: 3,
                      color: Color.fromRGBO(70, 26, 26, 1),
                    ),
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        valorAtrelado = valorAtrelado + 1;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                        m1++;
                      });
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      child: Image.asset("imagens/moeda1.png"),
                    ),
                  ),
                  m1 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(m1.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        valorAtrelado = valorAtrelado + 0.5;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                        m05++;
                      });
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      child: Image.asset("imagens/moeda50.jpg"),
                    ),
                  ),
                  m05 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(m05.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        n50++;
                        valorAtrelado = valorAtrelado + 50;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      width: 115,
                      height: 57.5,
                      child: Image.asset("imagens/nota50.png"),
                    ),
                  ),
                  n50 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(n50.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        n100++;
                        valorAtrelado = valorAtrelado + 100;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      width: 115,
                      height: 57.5,
                      child: Image.asset("imagens/nota100.jpg"),
                    ),
                  ),
                  n100 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(n100.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        valorAtrelado = valorAtrelado + 0.25;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                        m025++;
                      });
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      child: Image.asset("imagens/moeda25.jpg"),
                    ),
                  ),
                  m025 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(m025.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        m01++;
                        valorAtrelado = valorAtrelado + 0.10;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      child: Image.asset("imagens/moeda10.png",fit: BoxFit.fill,),
                    ),
                  ),
                  m01 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(m01.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        n10++;
                        valorAtrelado = valorAtrelado + 10;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      width: 115,
                      height: 57.5,
                      child: Image.asset("imagens/nota10.jpg"),
                    ),
                  ),
                  n10 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(n10.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        n20++;
                        valorAtrelado = valorAtrelado + 20;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      width: 115,
                      height: 57.5,
                      child: Image.asset("imagens/nota20.jpg"),
                    ),
                  ),
                  n20 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(n20.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        m005++;
                        valorAtrelado = valorAtrelado + 0.05;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                        width: 55,
                        height: 55,
                      child: Image.asset("imagens/moeda5.jpg"),
                    ),
                  ),
                  m005 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(m005.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        m001++;
                        valorAtrelado = valorAtrelado + 0.01;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
    width: 55,
    height: 55,
                      child: Image.asset("imagens/moeda1c.jpg"),
                    ),
                  ),
                  m001 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(m001.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        n02++;
                        valorAtrelado = valorAtrelado + 2;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      width: 115,
                      height: 57.5,
                      child: Image.asset("imagens/nota2.jpg",fit: BoxFit.fill,),
                    ),
                  ),
                  n02 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(n02.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        n05++;
                        valorAtrelado = valorAtrelado + 5;
                        _moneyControlle.text = valorAtrelado.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      width: 115,
                      height: 57.5,
                      child: Image.asset("imagens/nota5.jpg"),
                    ),
                  ),
                  n05 != 0
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red,width: 2),),
                      child: Center(
                        child: Text(n05.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                valorAtrelado > double.parse(total.toString())
                    ? "Troco: "
                    : "Faltam: ",
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
              Text(
                "R\$"+(valorAtrelado - double.parse(total.toString()))
                    .toStringAsFixed(2),
                style: TextStyle(color: Colors.red, fontSize: 22),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          !ativo?Center(child: CircularProgressIndicator(color: Colors.brown,),):Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _moneyControlle.text="0.00";
                      valorAtrelado=0;
                      m1 = 0; m05 = 0; m025 = 0; m01 = 0; m005 = 0;m001 = 0;
                      n100 = 0; n50 = 0; n20 = 0; n10 = 0; n05 = 0; n02 = 0;
                    });

                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width*0.35,
                      height: MediaQuery.of(context).size.height*0.085,
                      child: Center(
                        child: Text("Limpar",style: TextStyle(fontSize: 24),),
                      )
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red))),
              ElevatedButton(
                onPressed: () {
                  if(ativo){
                    setState(() {
                      ativo=false;
                    });
                    valorTotal=total.toStringAsFixed(2);
                    valorPago=valorAtrelado.toStringAsFixed(2);


                    print(valorAtrelado);
                    print(valorTotal);

                    trocoGerado=(valorAtrelado-double.parse(valorTotal)).toStringAsFixed(2);
                    print(troco.toStringAsFixed(2));

                    ConfigPedido.dinheiro=true;
                    enviaNfce();
                  }else{
                    print('processando');


                  }



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
}
