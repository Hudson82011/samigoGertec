import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Size.dart';
import '../../back/PostSaidaCaixa.dart';

class SangriaScreen extends StatefulWidget {
  //const SangriaScreen({Key key}) : super(key: key);

  @override
  _SangriaScreenState createState() => _SangriaScreenState();
}

class _SangriaScreenState extends State<SangriaScreen> {
  ScreenSize _size = ScreenSize();

  bool _isLoading = false;

  TextEditingController _valController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(116, 0, 0, 1),
          title:  Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset("imagens/sammigo 1.png",),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _size.getWidth(context),
            ),
            Padding(
                padding: EdgeInsets.only(top: _size.getHeight(context) * 0.05)),
            Text(
              'Sangria de Caixa',
              style: TextStyle(
                  color: Color.fromRGBO(98, 89, 89, 1),
                  fontSize: 24,
                  fontStyle: FontStyle.italic),
            ),
            Padding(
                padding: EdgeInsets.only(top: _size.getHeight(context) * 0.04)),
            Text(
              'Valor de retirada:',
              style: TextStyle(
                color: Color.fromRGBO(98, 89, 89, 1),
                fontSize: 22,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: _size.getHeight(context) * 0.02)),
            Container(
              width: _size.getWidth(context) * 0.35,
              child: Material(
                elevation: 5.0,
                shadowColor: Colors.black,
                child: TextFormField(
                    controller: _valController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[-*()+=/\\]')),
                      //CentavosInputFormatter()
                    ],
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      //labelText: "Pesquisar produtos...",
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
                    )),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: _size.getHeight(context) * 0.04)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _valController.text =
                          ((double.tryParse(_valController.text.replaceAll(",", ".")) ?? 0) + 1)
                              .toStringAsFixed(2);
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: const Text("1+",
                      style: TextStyle(color: Color.fromRGBO(126, 0, 0, 1))),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: _size.getWidth(context) * 0.05)),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _valController.text =
                          ((double.tryParse(_valController.text.replaceAll(",", ".")) ?? 0) + 10)
                              .toStringAsFixed(2);
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: const Text("10+",
                      style: TextStyle(color: Color.fromRGBO(126, 0, 0, 1))),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: _size.getWidth(context) * 0.05)),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _valController.text =
                          ((double.tryParse(_valController.text.replaceAll(",", ".")) ?? 0) + 100)
                              .toStringAsFixed(2);
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: const Text("100+",
                      style: TextStyle(color: Color.fromRGBO(126, 0, 0, 1))),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: _size.getHeight(context) * 0.04)),
            ElevatedButton(
              onPressed: () {

                setState(() {
                  _isLoading = true;
                });

                if (_valController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Preencha um valor para prosseguir!"));
                      });
                } else {
                  TextEditingController codController = TextEditingController();
                  TextEditingController pinController = TextEditingController();

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color.fromRGBO(216, 219, 227, 1),
                          scrollable: true,
                          title:  Text("Gerência - Autorização Sangria"),
                          content: Container(
                            width: _size.getWidth(context)*0.75,
                            height: _size.getHeight(context)*0.175,
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
                                    Padding(padding: EdgeInsets.only(left: 5)),
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
                                ),  Row(
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
                                          PostSaidaCaixa()
                                              .saida(
                                              codController.text,
                                              pinController.text,
                                              "S",
                                              'SANGRIA DE CAIXA',
                                              _valController.text)
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
                                              /*  ImpD2().impVal(
                                                  'StackVile\n'+
                                                      '===========================\n'+
                                                      "Data:${DateTime.now()}\n"+
                                                      "Operado:${FuncInfos.codFunc} ${FuncInfos.funcName}\n"+
                                                      "Autorização:${codController.text} \n"+
                                                      '---------------------------\n'+
                                                      "\n\n"+
                                                      "SANGRIA DE CAIXA\n"+
                                                      "Valor: ${_valController.text}"
                                                          "\n\n"+
                                                      '---------------------------\n'+
                                                      "Assinatura\n"

                                              );*/

                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                        title: Text('Sangria efetuada com sucesso.'));
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
                }
              },
              child: Container(
                width: _size.getWidth(context) * 0.2,
                height: _size.getHeight(context) * 0.1,
                child: Center(
                  child: Text(
                    'Confirmar',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(126, 0, 0, 1)),
            )
          ],
        ),
        //bottomSheet: BottomBar()
    ));
  }
}
