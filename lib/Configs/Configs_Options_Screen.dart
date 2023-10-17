import 'package:flutter/material.dart';
import 'package:sammi_gov2/Configs/geren/Pre_Fecha_Screen.dart';
import 'package:sammi_gov2/Configs/rf/Pagamento_Screen.dart';
import 'package:sammi_gov2/Configs/rf/Sangria_Screen.dart';
import 'package:sammi_gov2/Configs/rf/Suprimento_Screen.dart';

import '../Size.dart';
import 'Canc_Cup_Screen.dart';


class ConfigOptionsScreen extends StatefulWidget {
  //const ConfigOptionsScreen({Key key}) : super(key: key);

  @override
  _ConfigOptionsScreenState createState() => _ConfigOptionsScreenState();
}

class _ConfigOptionsScreenState extends State<ConfigOptionsScreen> {
  ScreenSize _size = ScreenSize();

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
        body:SingleChildScrollView(child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: _size.getHeight(context) * 0.01)),
            Text(
              'Opções do Sistema',
              style: TextStyle(
                  color: Color.fromRGBO(98, 89, 89, 1),
                  fontSize: 24,
                  fontStyle: FontStyle.italic),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: _size.getHeight(context) * 0.03)),
                    _buttonOption(
                        "Gerenciamento de Notas", "cancCp.png", CancCupScreen()),
                    Padding(
                        padding: EdgeInsets.only(top: _size.getHeight(context) * 0.03)),
                    _buttonOption(
                        "Pré Fechamento", "cancCp.png", PreFechaScreen()),
                    Padding(
                        padding: EdgeInsets.only(top: _size.getHeight(context) * 0.03)),
                    _buttonOption("Sangria de Caixa", "sangr.png", SangriaScreen()),
                    Padding(
                        padding: EdgeInsets.only(top: _size.getHeight(context) * 0.03)),
                    _buttonOption("Suprimento de Caixa", "sup.png", SuprimentoScreen()),
                    Padding(
                        padding: EdgeInsets.only(top: _size.getHeight(context) * 0.03)),
                    _buttonOption("Pagamentos", "pag.png", PagamentoScreen()),
                    Padding(
                        padding: EdgeInsets.only(top: _size.getHeight(context) * 0.03)),
                    ElevatedButton(
                      onPressed: () {
                       // Elgin().sendSitefParams(Acao.CONFIGURACAO, "", "1", FormaPagamento.DEBITO, context);

                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: _size.getWidth(context) * 0.15,
                            height: _size.getHeight(context) * 0.1,
                            child: Image.asset(
                              "assets/vectors/cred.png",
                              scale: 2,
                              fit: BoxFit.scaleDown,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            height: _size.getHeight(context) * 0.1,
                          ),
                          Container(
                              height: _size.getHeight(context) * 0.12,
                              width: _size.getWidth(context) * 0.3,
                              child: Center(
                                child: Text(
                                'Tef Adm.',textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontSize: 14),
                                ),
                              ))
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(236, 236, 236, 1)),
                    )
                  ],
                ),

              ],
            ),
          ],
        )) ,
       );
  }

  Widget _buttonOption(String buttonTxt, String asset, var pg) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => pg))
            .then((value) {
          setState(() {});
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: _size.getWidth(context) * 0.15,
            height: _size.getHeight(context) * 0.1,
            child: Image.asset(
              "assets/vectors/$asset",
              scale: 2,
              fit: BoxFit.scaleDown,
            ),
          ),
          Container(
            height: _size.getHeight(context) * 0.1,
          ),
          Container(
              height: _size.getHeight(context) * 0.12,
              width: _size.getWidth(context) * 0.3,
              child: Center(
                child: Text(
                   buttonTxt,textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ))
        ],
      ),
      style:
      ElevatedButton.styleFrom(primary: Color.fromRGBO(236, 236, 236, 1)),
    );
  }
}
