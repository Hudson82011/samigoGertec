import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sammi_gov2/mapClasses/Comanda.dart';
import 'package:sammi_gov2/pages/PagaComanda/prodsCmd.dart';
import 'package:sammi_gov2/pages/PagaComanda/scanner/service_barcodeScanner.dart';




import '../../LocalInfo/EnterpriseConfig.dart';
import '../login.dart';
import 'package:http/http.dart' as http;

var Cmd_nota;

class SelectCmd extends StatefulWidget {
  @override
  _SelectCmdState createState() => _SelectCmdState();
}

class _SelectCmdState extends State<SelectCmd> {


  TextEditingController _cmdController=TextEditingController();
  List<Comanda>cmdt=[];


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
    });

    setState(() {
      retornaJson().then((value) {
        if (this.mounted) {
          setState(() {
            cmdt.addAll(value);


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
      Cmd_nota=_cmdController.text;
      Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>ProdsCmd())).then((value){
        setState(() {
          cmdt=[];
          retornaJson().then((value) {
            if(this.mounted){setState(() {
              cmdt.addAll(value);
            });}
          });

        });
      });

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
      });
    }
  }


  void initState() {

    retornaJson().then((value) {
      if(this.mounted){setState(() {
        cmdt.addAll(value);
      });}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("imagens/sammigo 1.png", scale: 1.5,),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text("Informe o número da comanda",style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,

            ),),
            Row(
              children: [
                Container(
                  width: 300,
                  child:TextField(
                    keyboardType: TextInputType.number,
                    ///textInputAction:TextInputAction.continueAction,
                    ///focusNode: node,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Comanda",
                        labelStyle: TextStyle(color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.black),
                        )),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    controller: _cmdController,
                  ),),
                IconButton(onPressed: (){
                  barCodeRead();
                }, icon:Icon(Icons.qr_code))
              ],
            ),
            Row(
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
            ),

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
                        height: 340,
                          width: 340,
                          child: GridView.builder(
                              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 1.0,
                                crossAxisSpacing: 1.0,

                              ),
                              itemCount: cmdt.length,
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

        Cmd_nota = cmdt[index].NUM_COMANDA;
        Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) =>ProdsCmd())).then((value) =>refreshPage());
      },
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(180.0)),
        color: Color.fromRGBO(123, 2, 2, 1),
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
                      child: Text(cmdt[index].QtdeItens,textAlign:TextAlign.center,
                        style: TextStyle(color: Colors.white),),
                    )
                ),
                Padding(padding: EdgeInsets.only(left: 8))
              ],
            ),
            mesa?Text(cmdt[index].MESA,
                style: TextStyle(fontSize: 14, color: Colors.white)):Container(),
            Text(
              cmdt[index].NUM_COMANDA.toString(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(double.parse(cmdt[index].Total).toStringAsFixed(2),
                style: TextStyle(fontSize: 12, color: Colors.white,
                    fontStyle: FontStyle.italic
                )),
          ],
        ),
      ),
    );
  }


}
