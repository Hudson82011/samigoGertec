import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sammi_gov2/mapClasses/LoginClass.dart';
import 'package:sammi_gov2/mapClasses/configClass.dart';

import '../LocalInfo/EnterpriseConfig.dart';
import '../Utils/LocalFiles.dart';
import '../printer/printerGertec.dart';
import 'configGeral.dart';
import 'mainMenu.dart';

String tokenTw="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAwMCwiaWF0IjoxNjU4MjU2NzIwLCJleHAiOjE2NTgzNDMxMjB9.7aIMhLuiaftlB9RM92c9oLtnInWuDKU-fE49jdvkAOk";

String CNPJ="14237989000166";
String codEmpresa="00000001";
String comExterna="02";
String chaveExterna="1234567";
String tefIp="127.0.0.1";
String tipoComunic="GERTEC";
String macBalanca="00:16:A4:13:3C:7D";
var codVend;
var atendente;
var banco="T";

///var hostname="192.168.10.39";
var port="8075";
var auth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
var username = 'preatend';
var password = "preatend";
bool mesa=false;
int fInicial=1;
int fFinal=1;
bool comunicaWeb=false;
var dadosWeb;
Map<String, dynamic> mapConfigWeb=Map();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {




  _getAndroidId()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
   EnterpriseConfig.deviceId = androidInfo.androidId!;
   print(EnterpriseConfig.deviceId);


  }


  login() async {

   if(codController.text==""||pinController.text==""){
     showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             title: Text("Preencha o código e a senha."),
           );
         });
   }else{
     print(EnterpriseConfig.hostname);
     var url =
         "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_LoginFunc/$banco";
     var response = await http.post(Uri.parse(url), headers: {'authorization': auth},
         body: json.encode(
             {"cod_func": codController.text, "senha": pinController.text})

     );
     print(response.body);
     if (response.body == "[]") {
       showDialog(
           context: context,
           builder: (BuildContext context) {
             return AlertDialog(
               title: Text("Código ou senha incorretos."),
             );
           });
       setState(() {
         infoText = "Error";
       });
     }
     else {
       List<LoginClass> login = [];
       var logsJson = json.decode(response.body);
       for (var logJson in logsJson) {
         login.add(LoginClass.fromJson(logJson));
         atendente = login[0].nome;
         codVend = login[0].cod_func;
       }
       FocusScope.of(context).unfocus();

       return Navigator.push(
           context,
           MaterialPageRoute(builder: (BuildContext context) => MainMenu()));
     }
   }
  }



    /*if(codController.text=="1000"&&pinController.text=="372177"){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>MainMenu()));

    }else{
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Usuario ou senha incorretos."));
          });*/





  Future<String> _readData() async {
    try {
      final file = await _getTempFile();
      return file.readAsString();
    } catch (e) {
      print("erro");
      return "erro";
    }

  }



  Future<File> _getTempFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/pos.json");
  }





  TextEditingController codController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  final pageController2 = PageController(initialPage: 0);

  String infoText = "";

  var dpId;





  Future<String> getToken()async{

    Map<String, String> _body = {
      "email":"tecnoweb.bh@gmail.com",
      "senha":"t3cn0w3b"
    };


    var url="https://twapi.ommini.com.br/users/login";
    var responde= await http.post(Uri.parse(url),
        body: _body);
    var token=json.decode(responde.body)['token'];
    print(token);
    tokenExt=token;
    tokenTw=tokenExt;

    return token;

  }

  String tokenExt='';


  void getConfigDevice(String token)async{



    _getAndroidId();
    Map<String, String> _body = {
      "token":EnterpriseConfig.deviceId,
      "app":"POS"

    };



    var url = "https://twapi.ommini.com.br/sistema/cfgdispositivo";
    var response = await http.post(Uri.parse(url), headers: {'authorization': "Bearer $token"},
    body: _body);

     print(response.body);



    try{
      String data=json.decode(response.body)["params"];

      mapConfigWeb=json.decode(data);

      EnterpriseConfig.cnpj=json.decode(response.body)["cnpj"];











      EnterpriseConfig.hostname=mapConfigWeb["hostname"].toString();
      EnterpriseConfig.macBall=mapConfigWeb["macBalanca"].toString();
      EnterpriseConfig.tamanhoCodBall=mapConfigWeb["tamanhoCodigoBalanca"].toString();
      EnterpriseConfig.vpn=mapConfigWeb["vpn"].toString();
      EnterpriseConfig.comExterna=mapConfigWeb["comExterna"].toString();
      EnterpriseConfig.empresaSitef=mapConfigWeb["empresaSitef"].toString();

    }catch(err){
      print(err);


    }




  }




  void initState() {

    LocalFiles().readData2('lastNotes').then((value){
      EnterpriseConfig.lastNotes=json.decode(value);

    });


    _getAndroidId();
    getToken().then((t){
      getConfigDevice(t);

    });



   /* _readData().then((data) {
      var tempAJson = json.decode(data);
      print(tempAJson);

      List<configClass> configSalvas = [];
      var configJson = json.decode(data);
      for (var x in configJson) {
        configSalvas.add(configClass.fromJson(x));
       // print(configSalvas[0].hostname);

       EnterpriseConfig.hostname=configSalvas[0].hostname;
       comExterna=configSalvas[0].comExterna;
       codEmpresa=configSalvas[0].codEmpresa;
       CNPJ=configSalvas[0].CNPJ;
       chaveExterna=configSalvas[0].chaveExterna;
       tefIp=configSalvas[0].tefIp;
       tipoComunic=configSalvas[0].tipoComunic;
       comunicaWeb=configSalvas[0].comunicaWeb;


      }


    });*/

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child:Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(9, 42, 71, 1),
                image: DecorationImage(
                    image: AssetImage('imagens/back.png'),
                    fit: BoxFit.fitHeight,
                    repeat: ImageRepeat.repeat,
                  opacity: 50

                )),
            padding: EdgeInsets.fromLTRB(55, 100, 55, 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(EnterpriseConfig.deviceId),
                          );
                        });
                  },
                  child: Container(
                    width: 200,
                    child: Image.asset("imagens/sammigo 1.png",
                    ),
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 60)),
                TextField(
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  /// textInputAction:TextInputAction.next,
                  ///onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(255, 255, 255,0.85),
                      labelText: "Usuário",
                      labelStyle: TextStyle(color: Colors.black54,fontStyle: FontStyle.italic),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color.fromRGBO(147, 102, 102, 1),width: 2),
                      )),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  controller: codController,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child:TextField(
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    ///textInputAction:TextInputAction.continueAction,
                    ///focusNode: node,
                    onEditingComplete: (){
                      login();
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(255, 255, 255,0.85),
                        labelText: "Senha",
                        labelStyle: TextStyle(color: Colors.black54,fontStyle: FontStyle.italic),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color.fromRGBO(147, 102, 102, 1),width: 2),
                        )),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    controller: pinController,
                  ),),
               /* Text("Mesmo código e senha do Sistema Lince",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),),*/
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 25, 0.0, 25),
                  child: Container(
                    height: 80.0,
                    width: 249.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: ElevatedButton(
                      onPressed:(){
                        login();


                      },
                      child: Text("Entrar",style: TextStyle(color: Colors.white,fontSize: 28),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(245, 134, 52, 1),),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                              )
                          )
                      ),
                    ),
                  ),
                ),
                Text(
                  infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                ),
                Padding(padding: EdgeInsets.only(bottom: 50)),
                GestureDetector(
                  child: Image.asset("imagens/tecno.png"),
                  onLongPress: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) =>ConfigGeral()));



                  },
                )
              ],
            ),
          ),
        )
    );
  }
}

