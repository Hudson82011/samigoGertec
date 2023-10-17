import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../LocalInfo/EnterpriseConfig.dart';
import 'login.dart';




class ConfigGeral extends StatefulWidget {
  @override
  _ConfigGeralState createState() => _ConfigGeralState();
}

class _ConfigGeralState extends State<ConfigGeral> {


  TextEditingController _codigoController=TextEditingController();
  TextEditingController _ipController=TextEditingController();
  TextEditingController _cnpjController=TextEditingController();
  TextEditingController _comExternaController=TextEditingController();
  TextEditingController _chaveExternaController=TextEditingController();
  TextEditingController _tefController=TextEditingController();
  TextEditingController _commectController=TextEditingController();
  TextEditingController _balancaController=TextEditingController();



  Future<File> _getTempFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/gpos700.json");
  }

  Future<File> _saveTempFile(x) async {
    String data = json.encode(x);
    final file = await _getTempFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getTempFile();
      return file.readAsString();
    } catch (e) {
      print("erro");
      return "erro";
    }
  }

  void initState() {
   _cnpjController.text=CNPJ;
   _codigoController.text=EnterpriseConfig.empresaSitef;;
   _ipController.text=EnterpriseConfig.hostname;
   _comExternaController.text= EnterpriseConfig.comExterna;
   _chaveExternaController.text= EnterpriseConfig.vpn;
   _tefController.text=tefIp;
   _commectController.text=tipoComunic;
   _balancaController.text=macBalanca;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){

          }, icon:Icon(Icons.cloud_download))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Text("1.0.1+4"),
            Padding(padding: EdgeInsets.only(top: 40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Codidgo Empresa"),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                    controller: _codigoController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "Código",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Endereco"),
                Padding(padding: EdgeInsets.only(left: 19),),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                    controller: _ipController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "IP",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Endereço sitef"),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                      controller: _tefController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "Código",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("CNPJ"),
                Padding(padding: EdgeInsets.only(left: 20),),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                    controller: _cnpjController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "CNPJ",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("comExterna"),
                Padding(padding: EdgeInsets.only(left: 0.4),),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                    controller: _comExternaController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "COM",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Chave Externa"),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                      controller: _chaveExternaController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "Código",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ),Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Tipo comunicacao:"),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                      controller: _commectController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "Comnect",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ), Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Balança"),
                Padding(padding: EdgeInsets.only(left: 19),),
                Container(
                  width: 170,
                  height: 60,
                  child: TextFormField(
                      controller: _balancaController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(187, 193, 198, 0.6),
                        labelText: "Balança",
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(88, 160, 178, 1),
                          ),
                        ),
                      )),
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Comunicação web ativa:"),
                Switch(value: comunicaWeb, onChanged:(value){
                 setState(() {
                   comunicaWeb=value;
                 });
                })
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ElevatedButton(onPressed: (){
              EnterpriseConfig.hostname=_ipController.text;
              CNPJ=_cnpjController.text;
              EnterpriseConfig.comExterna=_comExternaController.text;
              EnterpriseConfig.empresaSitef=_codigoController.text;
              EnterpriseConfig.vpn=_chaveExternaController.text;
              tefIp=_tefController.text;
              tipoComunic=_commectController.text;
              macBalanca=_balancaController.text;

              List tempFile=[];
              Map<dynamic, dynamic> tempArquivo = Map();
              tempArquivo["hostname"] = EnterpriseConfig.hostname;
              tempArquivo["CNPJ"] = CNPJ;
              tempArquivo["comExterna"] =  EnterpriseConfig.comExterna;
              tempArquivo["codEmpresa"] = EnterpriseConfig.empresaSitef;
              tempArquivo["chaveExterna"]= EnterpriseConfig.vpn;
              tempArquivo["tefIp"]= tefIp;
              tempArquivo["tipoComunic"]= tipoComunic;
              tempArquivo["comunicaWeb"]=comunicaWeb;
              tempArquivo["balanca"]=macBalanca;

              tempFile.add(tempArquivo);
              _saveTempFile(tempFile);

              Navigator.pop(context);


            }, child: Text("Salvar")),
           /* ElevatedButton(onPressed: (){
      _readData().then((data) {
        var tempAJson = json.decode(data);
        print(tempAJson);


      });


            }, child: Text("Ler"))*/

          ],
        ),
      )


    );
  }
}
