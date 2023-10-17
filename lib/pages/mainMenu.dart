import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sammi_gov2/Configs/Configs_Options_Screen.dart';
import 'package:sammi_gov2/LocalInfo/EnterpriseConfig.dart';
import 'package:sammi_gov2/LocalInfo/LocalBase.dart';
import 'package:sammi_gov2/back/GetBase.dart';
import 'package:sammi_gov2/back/GetTerminais.dart';
import 'package:sammi_gov2/elginPay/ElginPay.dart';
import 'package:sammi_gov2/pages/CaixaMobile/CartProd.dart';
import '../ball/blue_ball.dart';
import '../printer/printer.dart';
import 'PagaComanda/tef/lastTransition.dart';
import 'configGeral.dart';





class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override

  TextEditingController inputValue = new TextEditingController();

  ElginpayService elginpayService = new ElginpayService();

  String selectedPaymentMethod = "Crédito";
  String selectedInstallmentsMethod = "Avista";

  String boxText = '';
  String retornoUltimaVenda = '';


  Map<String,dynamic>params=Map();


  PrinterService printerService = new PrinterService();




  //Handler para capturar retorno do ElginPay
  Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "elginpayConcluido":
        setState(() {
          this.retornoUltimaVenda = call.arguments['saida'];
        });


        params=json.decode(this.retornoUltimaVenda);

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

  void initState(){
    _getSavedDir();
    GetBase().retornaCard(EnterpriseConfig.cnpj).then((value){

      GetTerminais().retornaTerminais();
      value.forEach((element) {
        if(element.tipo_cartao=="C"){
          LocalBase.cred.add(element);
        }else{
          LocalBase.debt.add(element);
        }
      });



    });
    GetBase().retornaBarras().then((barras){
      GetBase.barras.clear();
      GetBase.barras.addAll(barras);
    });


   GetBase().returnProds().then((value){
     LocalBase.prods.clear();
      setState(() {
        LocalBase.prods.addAll(value);


      });
    });

   GetBase().retornaCate().then((value){
LocalBase.cats.clear();
     setState(() {
       LocalBase.cats.addAll(value);
     });

   });

    ElginpayService().desativaImp();
    BlueBall().connect(EnterpriseConfig.macBall);


    super.initState();
  }

  String dir="";

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
        dir=externalStorageDirPath;
      } catch (err, st) {
        print('failed to get downloads path: $err, $st');

        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    }
    return externalStorageDirPath;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:GestureDetector(child:Image.asset("imagens/sammigo 1.png",scale: 3.5,),onTap: ()async{
          final taskId = await FlutterDownloader.enqueue(
            url: 'https://solucoesmm.com.br/sammiandroid/apk/premobile.v22.pak',
            headers: {}, // optional: header send with url (auth token etc)
            savedDir: dir,
            showNotification: true, // show download progress in status bar (for Android)
            openFileFromNotification: true, // click on notification to open downloaded file (for Android)
          );
        },),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(70, 26, 26, 1),
        actions:[IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) =>ConfigGeral()));
          },
          icon: Icon(Icons.settings),

        ),]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: MediaQuery.of(context).size.width,),
          Column(children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) =>CartProd()));
              },
              child:Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(70, 26, 26, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: Colors.black,width: 2)
                ),
                child: Image.asset("imagens/sammigo 1.png",scale: 4,),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Text("Sammi POS",style: TextStyle(color: Color.fromRGBO(92, 87, 87, 1)),)
          ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 30)),
          Column(children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) =>ConfigOptionsScreen()));
              },
              child:Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: Colors.black,width: 2)
                ),
                child: Icon(Icons.settings,size: 120,color: Color.fromRGBO(70, 26, 26, 1),),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Text("Configurações",style: TextStyle(color: Color.fromRGBO(92, 87, 87, 1)),)
          ],
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                GestureDetector(
                  onTap: (){
                    realizarFuncao("funcoes", tefSelecionado);
                  },
                  child:Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: Colors.black,width: 2)
                    ),
                    child: Image.asset("imagens/sitef.png",scale: 1.5,),
                  ),
                ),
                Text("TEF")
              ],
              ),
              /*Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) =>ConfigGeral()));
                    },
                    child:Icon(Icons.settings,
                        size: 100),
                  ),
                  Text("Configurações")
                ],
              )*/
            ],
          ),*/

        ],

      ),
    );
  }
}
