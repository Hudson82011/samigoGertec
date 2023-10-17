import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sammi_gov2/mapClasses/Comanda.dart';
import 'package:sammi_gov2/mapClasses/ProdsCart.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartBack/CartInfo.dart';
import 'package:sammi_gov2/pages/PagaComanda/prodsCmd.dart';
import 'package:sammi_gov2/pages/PagaComanda/scanner/service_barcodeScanner.dart';




import '../../LocalInfo/EnterpriseConfig.dart';
import '../../mapClasses/Pcmd.dart';
import '../login.dart';
import 'package:http/http.dart' as http;

var Cmd_nota;

class CmdList extends StatefulWidget {
  @override
  _CmdListState createState() => _CmdListState();
}

class _CmdListState extends State<CmdList> {


  TextEditingController _cmdController=TextEditingController();
  List<Comanda>cmdt=[];

  List<Comanda>cmdtShow=[];


  Future<List<Comanda>> retornaJson() async {

    var url="http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_MostrarComandasAbertas/$banco/cmd_nota.NUM_COMANDA between 1 and 10000";
    var response= await http.get(Uri.parse(url),
        headers: {'authorization': auth}).timeout(Duration(seconds:15));
    List<Comanda> comandas = [];
    var cmdsJson = json.decode(response.body);
    for (var cmdJson in cmdsJson) {
      comandas.add(Comanda.fromJson(cmdJson));

    }

    return comandas;
  }

  refreshPage(){
    setState(() {
      cmdt=[];
      cmdtShow=[];
    });

    setState(() {
      retornaJson().then((value) {
        if (this.mounted) {
          setState(() {
            cmdt.addAll(value);
            cmdtShow.addAll(value);


          });
        }
      });
    });


  }

  searchCmd(){
    var res;
    var tam;
    var consumi;
    var cmtt;
    var m;
    List<Comanda> contasFiltradas = cmdt.where((item) => item.NUM_COMANDA==_cmdController.text.toString()).toList();
    for (var x=0; x<contasFiltradas.length; x++) {
      res=contasFiltradas[x].NUM_COMANDA;
      tam=contasFiltradas[x].QtdeItens;
      consumi=contasFiltradas[x].CONTATO;
      cmtt=contasFiltradas[x].HORA;
      m=contasFiltradas[x].MESA;
      print(m);

    }
    if(_cmdController.text==""){
      return showDialog(
          context: context,
          builder: (BuildContext context) { return AlertDialog(
              title: Text(
                  "Informe o número da comanda para continuar."));});

    }
    /*  else if(int.parse(_toDoController.text)<fInicial || int.parse(_cmdController.text)>fFinal){
      return showDialog(
          context: context,
          builder: (BuildContext context) { return AlertDialog(
              title: Text(
                  "Comanda fora de intervalo!"));});

    }*/
    else if(res==_cmdController.text) {
      if(CartInfo.prods.map((e) => e.NUM_COMANDA).contains(res)){
        showDialog(
            context: context,
            builder: (BuildContext context) { return AlertDialog(
                title: Text(
                    "Comanda já adicionada!"));});

      }else{
        retornaJsonp(res).then((value){

          value.forEach((element) {
            CartInfo.prods.add(ProdsCart(COD_PROD: element.COD_PROD,
                DESCRICAO: element.DESCRICAO,
                FLG_UNIDADE_VENDA: element.FLG_UNIDADE_VENDA,
                VLR_PRECO: element.VLR_PRECO,
                VLR_QTDE: element.VLR_QTDE,
                VLR_TOTAL: (double.parse(element.VLR_PRECO)*double.parse(element.VLR_QTDE)).toStringAsFixed(2),
                VLR_ACRESCIMO: element.ACRESCIMO,
                VLR_DESCONTO: "0",
                NUM_COMANDA: element.NUM_COMANDA,
              DOCUMENTO: element.DOCUMENTO,COD_VEND: element.COD_VEND,BARRAS:""

            ));

          });
          Navigator.pop(context);

        });
      }

    } else{
      return showDialog(
          context: context,
          builder: (BuildContext context) { return AlertDialog(
              title: Text(
                  "Comanda não encontrada!"));});

    }

  }

  BarcodeScannerService barcodeScannerService = new BarcodeScannerService();

  barCodeRead() async {
    String result = await barcodeScannerService.initializeScanner();
    print(result);
    if (result != "error") {
      setState(() {
        List<String> codeAndType = result.split(":+-");
        print(codeAndType);
        //barcodeResult.text = codeAndType[0];
        //typeOfBarcode.text = codeAndType[1];
        _cmdController.text=(int.tryParse(codeAndType[0].replaceAll(RegExp(r"\D"), ""))??0).toString();
        searchCmd();
      });
    }
  }

  Future<List<Pcmd>> retornaJsonp(String cmd) async {

    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_MostrarComandasItens/$banco/$cmd/";
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


  void initState() {

    retornaJson().then((value) {
      if(this.mounted){setState(() {
        cmdt.addAll(value);
        cmdtShow.addAll(value);
      });}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("imagens/sammigo 1.png", scale: 3.5,),
        backgroundColor: Color.fromRGBO(70, 26, 26,1),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text("Selecione ou digite uma comanda",style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,

            ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.65,
                  child:TextFormField(

                      controller: _cmdController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                      onChanged: (value){
                        setState(() {
                          cmdtShow = cmdt.where((val) {
                            var produtosDesc = val.NUM_COMANDA.toString();
                            return produtosDesc
                                .contains(value);
                          }).toList().where((element) => element.NUM_COMANDA.toLowerCase().contains((int.parse(value)).toStringAsFixed(0))).toList();
                        });
                      },
                      decoration: InputDecoration(
                        //labelText: "Código de barras",
                        focusColor: Colors.white,
                        //labelText: "Pesquisar produtos...",
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(135, 134, 134, 1),
                            fontStyle: FontStyle.italic
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            barCodeRead();
                          },
                          icon: Image.asset("imagens/scan.png"),
                        ),
                        filled: true,
                        fillColor: Color.fromRGBO(237, 234, 234, 1),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromRGBO(159, 157, 157, 1),
                          ),
                        ),
                      )),
                ),
                IconButton(onPressed: (){
                  refreshPage();

                }, icon:Image.asset("imagens/refresh.png"))
              ],
            ),
          /*  Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: (){
                  searchCmd();

                }, child: Text("Buscar comanda"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(61, 5, 5, 1))
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 65)),
                IconButton(onPressed: (){
                  refreshPage();

                }, icon:Icon(Icons.refresh))
              ],
            ),*/

            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            FutureBuilder<List<Comanda>>(
              future: retornaJson(),
              builder:(context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child:  CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError){Center(
                      child: Text("Erro de conexão, verifique a rede!"),
                    );
                    }else{
                      return Container(
                          height: 500,
                          width: 340,
                          child: GridView.builder(
                              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 1.0,
                                crossAxisSpacing: 1.0,

                              ),
                              itemCount: cmdtShow.length,
                              itemBuilder: (context, index) {
                                return Padding(padding: EdgeInsets.all(5),
                                  child:  GridTile(child:
                                  _comandaCard(context, index)),
                                );

                              }));
                    }
                }
                return  Container(
                  child: Center(
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
                  ),

                );
              },

            ),



          ],
        ),
      ),
    );
  }

  Widget _comandaCard(BuildContext context, int index){
    return GestureDetector(
      onTap: () {

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Tem certeza que deseja adicionar a comanda \"${cmdtShow[index].NUM_COMANDA}\" ?"),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);},
                      child: Text("Não")),
                  TextButton(onPressed: (){
                    retornaJsonp(cmdtShow[index].NUM_COMANDA).then((value){

                      value.forEach((element) {
                        CartInfo.prods.add(ProdsCart(COD_PROD: element.COD_PROD,
                            DESCRICAO: element.DESCRICAO,
                            FLG_UNIDADE_VENDA: element.FLG_UNIDADE_VENDA,
                            VLR_PRECO: element.VLR_PRECO,
                            VLR_QTDE: element.VLR_QTDE,
                            VLR_TOTAL: (double.parse(element.VLR_PRECO)*double.parse(element.VLR_QTDE)).toStringAsFixed(2),
                            VLR_ACRESCIMO: element.ACRESCIMO,
                            VLR_DESCONTO: "0",
                            NUM_COMANDA: element.NUM_COMANDA,
                          DOCUMENTO: element.DOCUMENTO,COD_VEND: element.COD_VEND,BARRAS: ""

                        ));

                      });
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                      child: Text("Sim"))
                ],
              );
            });





      },
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(180.0)),
        color: Color.fromRGBO(92, 50, 22, 1),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red
                    ),
                    height: 25,
                    width: 25,
                    child: Center(
                      child: Text(cmdtShow[index].QtdeItens,textAlign:TextAlign.center,
                        style: TextStyle(color: Colors.white),),
                    )
                ),
                Padding(padding: EdgeInsets.only(left: 8))
              ],
            ),
            mesa?Text(cmdtShow[index].MESA,
                style: TextStyle(fontSize: 14, color: Colors.white)):Container(),
            Text(
              cmdtShow[index].NUM_COMANDA.toString(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(double.parse(cmdtShow[index].Total).toStringAsFixed(2),
                style: TextStyle(fontSize: 12, color: Colors.white,
                    fontStyle: FontStyle.italic
                )),
          ],
        ),
      ),
    );
  }


}
