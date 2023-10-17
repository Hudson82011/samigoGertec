import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sammi_gov2/printer/printerGertec.dart';

import '../../LocalInfo/EnterpriseConfig.dart';
import '../../Size.dart';
import '../../back/PostResumoVends.dart';


class PreFechaScreen extends StatefulWidget {
  //const SangriaScreen({Key key}) : super(key: key);

  @override
  _PreFechaScreenState createState() => _PreFechaScreenState();
}

class _PreFechaScreenState extends State<PreFechaScreen> {
  ScreenSize _size = ScreenSize();

  bool _isLoading = false;

  TextEditingController _valController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    _valController.text=UtilData.obterDataDDMMAAAA(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(116, 0, 0, 1),
          title: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset("imagens/sammigo 1.png",),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: _size.getWidth(context),
              ),
              Padding(
                  padding:
                  EdgeInsets.only(top: _size.getHeight(context) * 0.05)),
              Text(
                'Pré Fechamento',
                style: TextStyle(
                    color: Color.fromRGBO(98, 89, 89, 1),
                    fontSize: 24,
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                  padding:
                  EdgeInsets.only(top: _size.getHeight(context) * 0.04)),
              Text(
                'Selecione a data que\ndeseja retirar o relatorio:',textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(98, 89, 89, 1),
                  fontSize: 22,
                ),
              ),
              Padding(
                  padding:
                  EdgeInsets.only(top: _size.getHeight(context) * 0.02)),
              Container(
                width: _size.getWidth(context) * 0.7,
                child: Material(
                  elevation: 5.0,
                  shadowColor: Colors.black,
                  child: TextFormField(
                      controller: _valController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DataInputFormatter(),


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
                  padding:
                  EdgeInsets.only(top: _size.getHeight(context) * 0.04)),
              /* Row(
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
            ),*/
              Padding(
                  padding:
                  EdgeInsets.only(top: _size.getHeight(context) * 0.04)),
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
                              title:
                              Text("Preencha uma data para prosseguir!"));
                        });
                  } else {
                    TextEditingController codController =
                    TextEditingController();
                    TextEditingController pinController =
                    TextEditingController();

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color.fromRGBO(216, 219, 227, 1),
                            scrollable: true,
                            title: Text("Gerência - Autorização Sangria"),
                            content: Container(
                              width: _size.getWidth(context) * 0.75,
                              height: _size.getHeight(context) * 0.275,
                              child:Column(children:[ Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                  ),
                                  Container(
                                    width: _size.getWidth(context) * 0.25,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: codController,
                                      decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        labelText: "Código",
                                        labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                135, 134, 134, 1),
                                            fontStyle: FontStyle.italic),
                                        filled: true,
                                        fillColor:
                                        Color.fromRGBO(237, 234, 234, 1),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(6),
                                          borderSide: BorderSide(
                                            width: 0,
                                            color: Color.fromRGBO(
                                                159, 157, 157, 0),
                                          ),
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Padding(padding: EdgeInsets.only(left: 50)),
                                  Container(
                                    width: _size.getWidth(context) * 0.25,
                                    child: TextField(
                                      obscureText: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        labelText: "Senha",
                                        labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                135, 134, 134, 1),
                                            fontStyle: FontStyle.italic),
                                        filled: true,
                                        fillColor:
                                        Color.fromRGBO(237, 234, 234, 1),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(6),
                                          borderSide: BorderSide(
                                            width: 0,
                                            color: Color.fromRGBO(
                                                159, 157, 157, 0),
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: pinController,
                                    ),
                                  ),

                                ],
                              ), Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.025)),Row(
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
                                        PostResumoVends()
                                            .resumoVendas(
                                            codController.text,
                                            pinController.text,
                                            _valController.text,
                                            _valController.text,
                                            EnterpriseConfig.serie)
                                            .then((ret) {
                                          print(ret);
                                          List _return = [];
                                          _return = json.decode(ret);

                                          if(_return.first["Erro"]!=null){
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title:
                                                      Text(_return.toString().replaceAll("[", "")
                                                          .replaceAll("]", "")
                                                          .replaceAll("{", "")
                                                          .replaceAll("}", "")));
                                                });
                                          }else{
                                            Map<String, dynamic> _cabecalho =
                                            Map();
                                            List _impost =[];
                                            Map<String, dynamic> _vals =
                                            Map();

                                            _cabecalho = _return.first;
                                            _impost=_return[1];
                                            _vals = _return.last;

                                            print('foi');
                                            PrinterG().impressaoDeTexto(   fontSize: 20,fontFamily: "DEFAULT",
                                                selectedOptions: [true,false,false],alinhar: "CENTER",context: context,texto:
                                                //_return.toString()
                                                "Relatorio de vendas" +
                                                    '\n' +
                                                    '===========================\n' +
                                                    _cabecalho['cnpj'] +
                                                    "\n" +
                                                    _cabecalho['razao'] +
                                                    "\n" +
                                                    "Data Emis.: " +
                                                    _cabecalho[
                                                    'data_emissao'] +
                                                    "\n" +
                                                    "Autorizado: " +
                                                    _cabecalho['autorizado'] +
                                                    "\n" +
                                                    '---------------------------\n' +
                                                    "Periodo: " +
                                                    _cabecalho['data_ini'] +
                                                    " a " +
                                                    _cabecalho['data_fin'] +
                                                    "\n" +
                                                    "Serie: " +
                                                    _cabecalho['serie'] +
                                                    "\n" +
                                                    "NF Inicial: " +
                                                    _cabecalho['nfini'] +
                                                    "\n" +
                                                    "NF Final: " +
                                                    _cabecalho['nffin'] +
                                                    "\n" +
                                                    '---------------------------\n' +
                                                    "Por Aliquotas\n" +
                                                    "SIT.TRIBU  VLR.TOTAL  IMPOSTO\n" +
                                                    geraLinhImposto(_impost)+
                                                    '\n---------------------------\n' +
                                                    "Por Formas de Pagamento\n\n" +
                                                    "Dinheiro:" + calcula30('Dinheiro:' + _retornaValDouble(_vals["vlr_dinheiro"])) + "${_retornaValDouble(_vals["vlr_dinheiro"])}\n" +
                                                    "Pix:" + calcula30('Pix:' + _retornaValDouble(_vals["vlr_cheque"])) + "${_retornaValDouble(_vals["vlr_cheque"])}\n" +
                                                    "CARTAO/POS:" + calcula30('CARTAO/POS:' + _retornaValDouble(_vals["vlr_cartao"])) + "${_retornaValDouble(_vals["vlr_cartao"])}\n" +
                                                    "CARTAO TEF:" + calcula30('CARTAO TEF:' + _retornaValDouble(_vals["vlr_cartao"])) + "${_retornaValDouble(_vals["vlr_cartao"])}\n" +
                                                    "PRAZO:" + calcula30('PRAZO:' + _retornaValDouble(_vals["vlr_prazo"])) + "${_retornaValDouble(_vals["vlr_prazo"])}\n" +
                                                    "VOUNCHER:" + calcula30('VOUNCHER:' + _retornaValDouble(_vals["vlr_vale"])) + "${_retornaValDouble(_vals["vlr_vale"])}\n\n" +
                                                    "  DESCONTO:" + calcula30('  DESCONTO:' + _retornaValDouble(_vals["vlr_desconto"])) + "${_retornaValDouble(_vals["vlr_desconto"])}\n" +
                                                    "  ACRESCIMO:" + calcula30('  ACRESCIMO:' + _retornaValDouble(_vals["vlr_acrescimo"])) + "${_retornaValDouble(_vals["vlr_acrescimo"])}\n" +
                                                    "  CANCELADO:" + calcula30('  CANCELADO:' +_retornaValDouble( _vals["total_cancelado"])) + "${_retornaValDouble(_vals["total_cancelado"])}\n" +
                                                    '\n---------------------------\n' +
                                                    "TOTAL DO PERIODO:" + calcula30("TOTAL DO PERIODO:" +_retornaValDouble( _vals["total"])) + "${_retornaValDouble(_vals["total"])}\n");
                                            PrinterG().finalizarImpressao();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            // Navigator.pop(context);
                                          }

                                        });
                                      },
                                      child: Text("Confirmar"))
                                ],
                              )])
                            ),
                          );
                        });
                  }
                },
                child: Container(
                  width: _size.getWidth(context) * 0.45,
                  height: _size.getHeight(context) * 0.1,
                  child: Center(
                    child: Text(
                      'Confirmar',
                      style: TextStyle(fontSize: 24),
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

  String calcula30(String val) {
    String empty = "";

    int value = 30 - val.length;

    for (int i = 0; i < value; i++) {
      empty = empty + " ";
    }

    return empty;
  }

  String _retornaValDouble(String val){



    return (double.tryParse(val)??0).toStringAsFixed(2);



  }

  String geraLinhImposto(List imps){

    String impsVal="";

    imps.forEach((element) {

      impsVal+= (element["flg_situacao_trib"]+"  ")+((double.tryParse(element["perc_icms"])??0).toStringAsFixed(2)+"           ").substring(0,8)+"  "+double.parse(element["vlr_total"]).toStringAsFixed(2)+"       "+double.parse(element["vlr_icms"]).toStringAsFixed(2)+"\n";
      //"F           41,30        0,00\n" +

    });



    return impsVal;
  }


}
