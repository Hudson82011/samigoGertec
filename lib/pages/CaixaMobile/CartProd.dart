import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sammi_gov2/LocalInfo/EnterpriseConfig.dart';
import 'package:sammi_gov2/LocalInfo/LocalBase.dart';
import 'package:sammi_gov2/Scan/GertecBarcode.dart';
import 'package:sammi_gov2/Size.dart';
import 'package:sammi_gov2/pages/CaixaMobile/Cmd_List.dart';
import 'package:sammi_gov2/pages/login.dart';
import '../../back/GetBase.dart';
import '../../back/PostLogin.dart';
import '../../back/getCmd.dart';
import '../../ball/blue_ball.dart';
import '../../mapClasses/ProdsCart.dart';
import '../../mapClasses/Search_t.dart';
import '../PagaComanda/scanner/service_barcodeScanner.dart';
import 'AddCartProd.dart';
import 'CartBack/CartInfo.dart';
import 'PaymentType.dart';



class CartProd extends StatefulWidget {
  const CartProd({Key? key}) : super(key: key);

  @override
  _CartProdState createState() => _CartProdState();
}

class _CartProdState extends State<CartProd> {


TextEditingController _addContreller=TextEditingController();


ScreenSize _size=ScreenSize();


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
      _addContreller.text=codeAndType[0];

      if(LocalBase.prods.map((e) => e.codigo_barras).toList().contains(_addContreller.text)){

        Search_t _prod=LocalBase.prods.where((element) => element.codigo_barras==_addContreller.text).first;

        setState(() {
          CartInfo.prods.add(
              ProdsCart(COD_PROD: _prod.cod_prod,
                  DESCRICAO: _prod.descricao,
                  FLG_UNIDADE_VENDA: _prod.flg_unidade_venda,
                  VLR_PRECO: _prod.vlr_preco,
                  VLR_QTDE: "1",
                  VLR_TOTAL: _prod.vlr_preco,
                  VLR_ACRESCIMO: "0",
                  VLR_DESCONTO: "0",
                  NUM_COMANDA: "0",
                  DOCUMENTO: "",COD_VEND: "0",BARRAS: "")
          );
        });
        _addContreller.clear();


      }else if (_addContreller.text.startsWith("2")) {
        String cod = int.parse(_addContreller.text.substring(1, 5)).toString();
        String precoTotal =
            _addContreller.text.substring(6, 10) + "." + _addContreller.text.substring(10, 12);

        if (LocalBase.prods
            .where((element) => element.cod_prod == cod)
            .isNotEmpty) {
          Search_t _myProd =
              LocalBase.prods.where((element) => element.cod_prod == cod).first;

          setState(() {
            CartInfo.prods.add(ProdsCart(
                COD_PROD: _myProd.cod_prod,
                DESCRICAO: _myProd.descricao,
                FLG_UNIDADE_VENDA: _myProd.flg_unidade_venda,
                VLR_PRECO: _myProd.vlr_preco,
                VLR_QTDE:
                (double.parse(precoTotal) / double.parse(_myProd.vlr_preco))
                    .toStringAsFixed(3),
                VLR_TOTAL: double.parse(precoTotal).toStringAsFixed(2),
                VLR_DESCONTO: "0",
                VLR_ACRESCIMO: "0",
                NUM_COMANDA: "0",
                DOCUMENTO: "",COD_VEND: "0",BARRAS: ""));
            _addContreller.clear();
          });

        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Produto não encontrado."),
                );
              });
        }

      }else{
        _addContreller.clear();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Produto não encontrado."),
              );
            });
      }


    });
  }
}


balBarcode(String _value) {

  int _counter=0;
  String _preco="";


  if(EnterpriseConfig.digBalanca==6){
    _counter =int.parse( _value.substring(1, 7));
    _preco = (_value.substring(7, 10)+"."+_value.substring(10,12));

  }else if(EnterpriseConfig.digBalanca==4){
    _counter =int.parse( _value.substring(1, 5));
    _preco = (_value.substring(5, 10)+"."+_value.substring(10,12));
  }else{
    _counter =int.parse( _value.substring(1, 6));
    _preco = (_value.substring(6, 10)+"."+_value.substring(10,12));
  }



  print(_preco);
 double preco=double.parse(_preco);


  _addContreller.text=_counter.toString();
  setState(() {

  });
}

Future<void> barcodeCall() async {

 String barcode=await GertecBarcode().leitorCodigoDeBarra();

 //List<Search_t>prodDisplay1=LocalBase.prods;

 veriProd(barcode);

  /*if (barcode.startsWith("2"))
    balBarcode(barcode);
  else{
    _addContreller.text = barcode;
    setState(() {
      prodDisplay1 = prodDisplay1.where((produto) {
       var produtosDesc = produto.codigo_barras;
       return produtosDesc.contains(barcode);
      }).toList();
   });

  }*/

}

bool _modal = false;
Timer _timer = Timer(Duration(microseconds: 0), () {});
veriProd(String barcode) {
  TextEditingController _prodCtr = TextEditingController();
  TextEditingController _quantCtr = TextEditingController();

  _prodCtr.text = barcode;

  if (barcode.length <= 7 ||
      barcode.substring(0) == "C") {
    // int cmd = int.parse(barcode.substring(1, barcode.length));

    final intInStr = RegExp(r'\d+');

    int cmd = int.parse(intInStr
        .allMatches(barcode)
        .map((m) => m.group(0))
        .first!);

    GetCmd().retornaJsonp(cmd).then((value) {
      if (value.isEmpty) {
        setState(() {
          _prodCtr.clear();
          _quantCtr.clear();
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              _modal = true;
              _timer =
                  Timer(Duration(seconds: 4), () {
                    _modal = false;
                    Navigator.of(context).pop();
                  });
              return AlertDialog(
                title: Text(
                    "Esta comanda está vazia."),
              );
            }).then((val) {
          if (_timer.isActive) {
            _modal = false;
            _timer.cancel();
          }
        });
      } else if (CartInfo.prods
          .map((e) => e.NUM_COMANDA.toString())
          .toList()
          .contains(value.first.NUM_COMANDA)) {
        setState(() {
          _prodCtr.clear();
          _quantCtr.clear();
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              _timer =
                  Timer(Duration(seconds: 4), () {
                    Navigator.of(context).pop();
                  });
              return AlertDialog(
                title: Text(
                    "Comanda já adicionada."),
              );
            }).then((val) {
          if (_timer.isActive) {
            _timer.cancel();
          }
        });
      } else if (value.isNotEmpty) {
        value.forEach((element) {
          CartInfo.prods.add(
              ProdsCart(
                  COD_PROD: element.COD_PROD,
                  DESCRICAO: element.DESCRICAO,
                  FLG_UNIDADE_VENDA:
                  element.FLG_UNIDADE_VENDA,
                  VLR_PRECO: element.VLR_PRECO,
                  VLR_QTDE: element.VLR_QTDE,
                  VLR_TOTAL: (double.tryParse(
                      element
                          .VLR_PRECO)! *
                      double.tryParse(
                          element.VLR_QTDE)!)
                      .toStringAsFixed(2),
                  VLR_DESCONTO: element.ACRESCIMO,
                  VLR_ACRESCIMO:
                  element.ACRESCIMO,
                  NUM_COMANDA: cmd.toString(),
                  BARRAS: LocalBase.prods
                      .where((val) =>
                  val.cod_prod ==
                      element.COD_PROD)
                      .first
                      .codigo_barras,
                  COD_VEND: "",
                  DOCUMENTO: element.DOCUMENTO));

          // controller.jumpTo(controller.position.maxScrollExtent);
        });

        setState(() {
          CartInfo.prods.sort((a, b) =>
              b
                  .NUM_COMANDA
                  .compareTo(a.NUM_COMANDA));
        });

        setState(() {
          _prodCtr.clear();
          _quantCtr.clear();
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Um erro ocorreu."),
              );
            });
        setState(() {
          _prodCtr.clear();
          _quantCtr.clear();
        });
      }
    });
  } else if (barcode.startsWith("2")) {
    String cod =
    int.parse(barcode.substring(1, 5))
        .toString();
    print(cod);
    String precoTotal = barcode.substring(6, 10) +
        "." +
        barcode.substring(10, 12);

    print(precoTotal);

    print(LocalBase.prods
        .where(
            (element) => element.cod_prod == cod)
        .toList()
        .isNotEmpty);

    if (LocalBase.prods
        .where(
            (element) => element.cod_prod == cod)
        .toList()
        .isNotEmpty) {
      setState(() {
        Search_t _myProd = LocalBase.prods
            .where((element) =>
        element.cod_prod == cod)
            .first;

        CartInfo.prods.add(

            ProdsCart(
                COD_PROD: _myProd.cod_prod,
                DESCRICAO: _myProd.descricao,
                FLG_UNIDADE_VENDA:
                _myProd.flg_unidade_venda,
                VLR_PRECO: _myProd.vlr_preco,
                VLR_QTDE: (double.parse(
                    precoTotal) /
                    double.parse(
                        _myProd.vlr_preco))
                    .toStringAsFixed(3),
                VLR_TOTAL:
                double.parse(precoTotal)
                    .toStringAsFixed(2),
                VLR_DESCONTO: "0",
                VLR_ACRESCIMO: "0",
                NUM_COMANDA: '0',
                DOCUMENTO: "",
                COD_VEND: "",
                BARRAS: _myProd.codigo_barras));

//                                      controller.jumpTo(controller.position.maxScrollExtent);
        _prodCtr.clear();
        _quantCtr.clear();
      });
    } else {
      setState(() {
        _modal = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
              Text("Produto não encontrado."),
            );
          }).then((value) {
        _modal = false;
      });
    }
  } else if (_prodCtr.text.isEmpty ||
      _prodCtr.text == "") {
    setState(() {
      CartInfo.prod = ProdsCart(
          COD_PROD: "",
          DESCRICAO: "",
          FLG_UNIDADE_VENDA: "",
          VLR_PRECO: "",
          VLR_QTDE: "",
          VLR_TOTAL: "",
          VLR_ACRESCIMO: "",
          VLR_DESCONTO: "",
          NUM_COMANDA: "",
          DOCUMENTO: "",
          COD_VEND: "",
          BARRAS: '');
      _quantCtr.text = "";
    });
  } else if (GetBase.barras.map((e) => e.codigo_barras).contains(barcode)) {
    String codProd = GetBase.barras
        .where((barras) => barras.codigo_barras == barcode)
        .first
        .cod_prod;

    Search_t myProd =
        LocalBase.prods
            .where((element) => element.cod_prod == codProd)
            .first;

    //Search_t myProd = ;


    setState(() {
      CartInfo.prod = ProdsCart(
          COD_PROD: myProd.cod_prod,
          DESCRICAO: myProd.descricao,
          FLG_UNIDADE_VENDA:
          myProd.flg_unidade_venda,
          VLR_PRECO: myProd.vlr_preco,
          VLR_QTDE: _quantCtr.text.isNotEmpty ? _quantCtr.text :
          (myProd.flg_unidade_venda == "KG"
              ? "1.000"
              : "1"),
          VLR_TOTAL: (_quantCtr.text.isNotEmpty ? (double.parse(
              _quantCtr.text) *
              double.parse(myProd.vlr_preco)) : (double.parse(
              myProd.flg_unidade_venda ==
                  "KG"
                  ? "1.000"
                  : "1")) *
              double.parse(myProd.vlr_preco))
              .toStringAsFixed(2),
          VLR_ACRESCIMO: "0",
          VLR_DESCONTO: "0",
          NUM_COMANDA: "0",
          COD_VEND: "",
          DOCUMENTO: "",
          BARRAS: myProd.codigo_barras);
      _quantCtr.text = CartInfo.prod.VLR_QTDE;
      if (myProd.flg_unidade_venda == "KG") {
        BlueBall().sendPrice(
            (double.tryParse(myProd.vlr_preco) ?? 0).toStringAsFixed(2));
      }

        CartInfo.prods.add(CartInfo.prod);

        //  controller.jumpTo(controller.position.maxScrollExtent);
        CartInfo.prod = ProdsCart(
            COD_PROD: "",
            DESCRICAO: "",
            FLG_UNIDADE_VENDA: "",
            VLR_PRECO: "",
            VLR_QTDE: "",
            VLR_TOTAL: "",
            VLR_ACRESCIMO: "",
            VLR_DESCONTO: "",
            NUM_COMANDA: "",
            DOCUMENTO: "",
            COD_VEND: "",
            BARRAS: '');
        _prodCtr.clear();
        _quantCtr.clear();

    });
  } else if (LocalBase.prods
      .where((produto) {
    var produtosDesc =
    produto.codigo_barras.toString();
    return produtosDesc
        .contains(_prodCtr.text);
  })
      .toList()
      .where((element) =>
      element.codigo_barras
          .toLowerCase()
          .contains(_prodCtr.text))
      .toList()
      .isEmpty) {
    setState(() {
      _modal = true;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
            Text("Produto não encontrado."),
          );
        }).then((value) {
      _modal = false;
      _prodCtr.clear();
    });
  } else {
    Search_t myProd = LocalBase.prods
        .where((produto) {
      var produtosDesc =
      produto.codigo_barras.toString();
      return produtosDesc
          .contains(_prodCtr.text);
    })
        .toList()
        .where((element) =>
        element.codigo_barras
            .toLowerCase()
            .contains(_prodCtr.text))
        .toList()
        .first;
    setState(() {
      CartInfo.prod = ProdsCart(
          COD_PROD: myProd.cod_prod,
          DESCRICAO: myProd.descricao,
          FLG_UNIDADE_VENDA:
          myProd.flg_unidade_venda,
          VLR_PRECO: myProd.vlr_preco,
          VLR_QTDE: _quantCtr.text.isNotEmpty ? _quantCtr.text :
          (myProd.flg_unidade_venda == "KG"
              ? "1.000"
              : "1"),
          VLR_TOTAL: (_quantCtr.text.isNotEmpty ? (double.parse(
              _quantCtr.text) *
              double.parse(myProd.vlr_preco)) : (double.parse(
              myProd.flg_unidade_venda ==
                  "KG"
                  ? "1.000"
                  : "1")) *
              double.parse(myProd.vlr_preco))
              .toStringAsFixed(2),
          VLR_ACRESCIMO: "0",
          VLR_DESCONTO: "0",
          NUM_COMANDA: "0",
          COD_VEND: "",
          DOCUMENTO: "",
          BARRAS: myProd.codigo_barras);
      _quantCtr.text = CartInfo.prod.VLR_QTDE;
      if (myProd.flg_unidade_venda == "KG") {
        BlueBall().sendPrice(
            (double.tryParse(myProd.vlr_preco) ?? 0).toStringAsFixed(2));
      }

        CartInfo.prods.add(CartInfo.prod);

        //  controller.jumpTo(controller.position.maxScrollExtent);
        CartInfo.prod = ProdsCart(
            COD_PROD: "",
            DESCRICAO: "",
            FLG_UNIDADE_VENDA: "",
            VLR_PRECO: "",
            VLR_QTDE: "",
            VLR_TOTAL: "",
            VLR_ACRESCIMO: "",
            VLR_DESCONTO: "",
            NUM_COMANDA: "",
            DOCUMENTO: "",
            COD_VEND: "",
            BARRAS: '');
        _prodCtr.clear();
        _quantCtr.clear();

    });
  }
}





void initState(){

  CartInfo.prods.reversed.toList();

  CartInfo.prods.sort((a, b) => a.NUM_COMANDA.compareTo(b.NUM_COMANDA));


  super.initState();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(70, 26, 26, 1),
        title: Image.asset("imagens/sammigo 1.png",scale: 3.5,),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Tem certeza que deseja fazer logoff?"),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);},
                          child: Text("Não")),
                      TextButton(onPressed: (){
                        CartInfo.prods.clear();

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => Login()),
                        ModalRoute.withName('/'));
                      },
                          child: Text("Sim"))
                    ],
                  );
                });



          }, icon: Image.asset("imagens/logoff.png",scale: 1.4,))
        ],
        leading: IconButton(onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Tem certeza que deseja sair e limpar o carrinho?"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);},
                        child: Text("Não")),
                    TextButton(onPressed: (){
                      CartInfo.prods.clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                        child: Text("Sim"))
                  ],
                );
              });


        }, icon: Image.asset("imagens/home.png")),
      ),
      body:  Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                // color: Colors.blueAccent,
                  width: MediaQuery.of(context).size.width*0.95,
                  height: MediaQuery.of(context).size.height*0.12,
                  child: Row(
                    children: [
                      Expanded(
                        child:TextFormField(

                            controller: _addContreller,
                            onEditingComplete: (){
                              if(LocalBase.prods.map((e) => e.codigo_barras).toList().contains(_addContreller.text)){

                                Search_t _prod=LocalBase.prods.where((element) => element.codigo_barras==_addContreller.text).first;

                              setState(() {
                                CartInfo.prods.add(
                                    ProdsCart(COD_PROD: _prod.cod_prod,
                                        DESCRICAO: _prod.descricao,
                                        FLG_UNIDADE_VENDA: _prod.flg_unidade_venda,
                                        VLR_PRECO: _prod.vlr_preco,
                                        VLR_QTDE: "1",
                                        VLR_TOTAL: _prod.vlr_preco,
                                        VLR_ACRESCIMO: "0",
                                        VLR_DESCONTO: "0",
                                        NUM_COMANDA: "0",
                                    DOCUMENTO: "",COD_VEND: "0",BARRAS: _prod.codigo_barras)
                                );
                              });
                                _addContreller.clear();


                              }else if (_addContreller.text.startsWith("2")) {
                                String cod = int.parse(_addContreller.text.substring(1, 5)).toString();
                                String precoTotal =
                                    _addContreller.text.substring(6, 10) + "." + _addContreller.text.substring(10, 12);

                                if (LocalBase.prods
                                    .where((element) => element.cod_prod == cod)
                                    .isNotEmpty) {
                                  Search_t _myProd =
                                      LocalBase.prods.where((element) => element.cod_prod == cod).first;

                                  setState(() {
                                    CartInfo.prods.add(ProdsCart(
                                        COD_PROD: _myProd.cod_prod,
                                        DESCRICAO: _myProd.descricao,
                                        FLG_UNIDADE_VENDA: _myProd.flg_unidade_venda,
                                        VLR_PRECO: _myProd.vlr_preco,
                                        VLR_QTDE:
                                        (double.parse(precoTotal) / double.parse(_myProd.vlr_preco))
                                            .toStringAsFixed(3),
                                        VLR_TOTAL: double.parse(precoTotal).toStringAsFixed(2),
                                        VLR_DESCONTO: "0",
                                        VLR_ACRESCIMO: "0",
                                        NUM_COMANDA: "0",
                                        DOCUMENTO: "",COD_VEND: "0",BARRAS: _myProd.codigo_barras));
                                    _addContreller.clear();
                                  });

                                } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Produto não encontrado."),
                                          );
                                    });
                                  }

                              }else{
                                _addContreller.clear();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Produto não encontrado."),
                                      );
                                    });
                              }
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                            decoration: InputDecoration(
                              suffixIcon: IconButton(onPressed: ()async{
                               barcodeCall();


                              }, icon: Image.asset("imagens/scan.png")),
                              //labelText: "Código de barras",
                              focusColor: Colors.white,
                              labelText: "Pesquisar produtos...",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(135, 134, 134, 1),
                                fontStyle: FontStyle.italic
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

                    ],
                  )
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    "Qtde. produtos na cesta: ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    CartInfo.prods.length.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(169, 36, 18,1)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                 Container(
                   width: 40,
                   child:  Text(
                     "  Cód.",
                     style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                   ),
                 ),
                  Container(
                    width: 140,
                    child: Text(
                      " Descrição",
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                  ),
                 Container(
                   width: 60,
                   child:  Text(
                     "Qtde.",
                     style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                   ),
                 ),
                 Container(
                   width: 70,
                   child:  Text(
                     "Valor",
                     style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                   ),
                 ),
                  Container(
                    width: 50,
                    child: Text(
                      "Ação.",
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                  )
                ],
              ),
               Expanded(
                            child: ListView.builder(
                                    itemCount: CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList().length,
                                    itemBuilder: (context, index) {
                                      return _cmdSection(index);
                                    })),

              Padding(padding: EdgeInsets.only(top: 60))



            ])),
    bottomSheet: BottomAppBar(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              height: 35,
              width: 600,
              color: Color.fromRGBO(70, 26, 26,1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){ Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCartProd())).then((value){
                            setState(() {
                              CartInfo.prods.reversed.toList();

                              CartInfo.prods.sort((a, b) => a.NUM_COMANDA.compareTo(b.NUM_COMANDA));
                            });
                  });  }
                  ,child: Container(
                  width: 110,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(245,134,52,1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)
                    )
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("imagens/scan.png",scale: 12,color: Colors.white),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text("PRODUTOS",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,color: Colors.white
                      ),)
                    ],
                  ),
                ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CmdList())).then((value){
                      setState(() {
                        CartInfo.prods.reversed.toList();

                        CartInfo.prods.sort((a, b) => a.NUM_COMANDA.compareTo(b.NUM_COMANDA));
                      });
                    });

                  }
                  ,child: Container(
                  width: 110,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(245,134,52,1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)
                      )
                  ),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Image.asset("imagens/cmd.png",scale: 12,color: Colors.white),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      Text("COMANDAS",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        color: Colors.white
                      ),)
                    ],
                  ),
                ),
                ),

                GestureDetector(
                  onTap: () {

                    if(CartInfo.prods.isEmpty){

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Adicione algum produto para continuar."),
                            );
                          });

                    }else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  PaymentType())).then((value){
                        setState(() {
                          CartInfo.prods.reversed.toList();

                          CartInfo.prods.sort((a, b) => a.NUM_COMANDA.compareTo(b.NUM_COMANDA));

                        });
                      });
                    }


                  }
                  ,child: Container(
                  width: 110,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(245,134,52,1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)
                      )
                  ),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("imagens/cart.png",scale: 12,color: Colors.white),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      Text("FINALIZAR",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,color: Colors.white
                      ),)
                    ],
                  ),
                ),
                ),
                /*GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Tem certeza que deseja limpar o carrinho e sair?"),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);},
                                  child: Text("Não")),
                              TextButton(onPressed: (){
                                CartInfo.prods.clear();
                                Navigator.pop(context);
                                Navigator.pop(context);

                              },
                                  child: Text("Sim"))
                            ],
                          );
                        });

                  }
                  ,child: Container(
                  width: 82,
                  height: 70,
                  color: Color.fromRGBO(245,134,52,1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("imagens/goback.png",scale: 12),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text("VOLTAR",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),)
                    ],
                  ),
                ),
                ),*/
              ],
            ),
          ],
        )
    ),


    );
  }




  Widget _cardprod(index,String myCmd) {
    return Container(
      height: MediaQuery.of(context).size.height*0.075,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /*Container(
            height: 30,
            width: 30,
            child:Center(
              child:  Text(_prodscmd[index].NUM_COMANDA,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green
            ),
          ),*/
          Container(
            height: 30,
            width: 40,
            child:Center(
              child:  Text(CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index].COD_PROD,
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ),
          ),
          Container(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index].DESCRICAO+" - "+CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index].FLG_UNIDADE_VENDA,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              /*  Text(
                  CartInfo.prods[index].OBS==null?"Sem observação":_prodscmd[index].OBS.toString(),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 9),
                ),*/
              ],
            ),
          ),
          Container(
            width: 60,
            child: Text(
              "${(double.tryParse(CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index].VLR_QTDE)??0).toStringAsFixed(CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index].FLG_UNIDADE_VENDA=="KG"?3:0)}",
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
         Container(
           width: 70,
           child:  Text(" "+double.parse(CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index].VLR_TOTAL).toStringAsFixed(2),
               style: TextStyle(fontSize: 13)),
         ),
          myCmd=="0"?GestureDetector(
            onTap: (){
              setState(() {

                TextEditingController codController = TextEditingController();
                TextEditingController pinController = TextEditingController();
              //  _modal=true;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Color.fromRGBO(216, 219, 227, 1),
                          scrollable: true,
                          title:  Text("Autorização para exclusão do produto:",style: TextStyle(
                              color: Color.fromRGBO(172, 0, 0, 1)
                          ),),
                          content: Container(
                              width: _size.getWidth(context)*0.9,
                              height: _size.getHeight(context)*0.4,
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text(CartInfo.prods[index].DESCRICAO,style: TextStyle(
                                        fontSize: 20,fontWeight: FontWeight.bold
                                    ),),
                                    Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.025)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(CartInfo.prods
                                            .where((element) => element.NUM_COMANDA == myCmd)
                                            .toList()[index].FLG_UNIDADE_VENDA),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Text(CartInfo.prods
                                            .where((element) => element.NUM_COMANDA == myCmd)
                                            .toList()[index].VLR_PRECO),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Text("QT" +
                                            CartInfo.prods
                                                .where((element) => element.NUM_COMANDA == myCmd)
                                                .toList()[index].VLR_QTDE +
                                            CartInfo.prods
                                                .where((element) => element.NUM_COMANDA == myCmd)
                                                .toList()[index].FLG_UNIDADE_VENDA
                                                .toLowerCase()),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Text(CartInfo.prods
                                            .where((element) => element.NUM_COMANDA == myCmd)
                                            .toList()[index].VLR_TOTAL),


                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.025)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 20),
                                        ), Container(
                                          width: _size.getWidth(context)*0.25,
                                          child:
                                          TextField(
                                            keyboardType: TextInputType.number,
                                            controller: codController,
                                            textInputAction: TextInputAction.next,
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
                                          ),),
                                        Padding(padding: EdgeInsets.only(top: 5)),
                                        Container(
                                          width: _size.getWidth(context)*0.25,
                                          child:TextField(
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
                                            keyboardType: TextInputType.visiblePassword,
                                            controller: pinController,
                                          ),),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(top: _size.getHeight(context)*0.025)),
                                    Row(
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
                                            child: Container(
                                              height:_size.getHeight(context)*0.105,
                                              child:  Center(
                                                child: Text("Cancelar"),
                                              ),
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                        ),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromRGBO(126, 0, 0, 1))),
                                            onPressed: () {
                                              if(pinController.text.isEmpty||codController.text.isEmpty){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                          title: Text(
                                                              "Preencha um usuario e senha para continuar."));
                                                    });
                                              }else{
                                                PostLogin().loginFunc(context, codController.text, pinController.text, "CHK_EXCLUIR_ITEM","remover itens").then((value){
                                                  if(value){
                                                    setState(() {
                                                      Navigator.pop(context);
                                                      CartInfo.prods.remove(CartInfo.prods
                                                          .where((element) => element.NUM_COMANDA == myCmd)
                                                          .toList()[index]);
                                                    });}else{

                                                  }
                                                });

                                              }

                                            },
                                            child: Container(
                                                height:_size.getHeight(context)*0.105,
                                                child:  Center(
                                                    child:Text("Confirmar"))))
                                      ],
                                    )
                                  ])));
                    }).then((value){
               //   _modal=false;
                });




              /*  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Tem certeza que deseja remover o produto \"${CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index].DESCRICAO}?\""),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);},
                              child: Text("Não")),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                         setState(() {
                           CartInfo.prods.reversed.toList();

                           CartInfo.prods.sort((a, b) => a.NUM_COMANDA.compareTo(b.NUM_COMANDA));
                           CartInfo.prods.remove(CartInfo.prods.where((element) => element.NUM_COMANDA==myCmd).toList()[index]);
                         });
                            },
                              child: Text("Sim"))
                        ],
                      );
                    });*/



              });
            },
            child: Container(
                width: 50,
                height: 25,
                child: Image.asset('imagens/rem.png')
            ),
          ):Container(
            width: 50,
          ),
          /*Container(
            child: Image.asset(
              "images/cancel.png",
              scale: 12,
            ),
          )*/
        ],
      ),
    );
  }

  Widget _cmdSection(int index){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]=="0"?Text("  Produtos adicionados",style: TextStyle(
    fontWeight: FontWeight.bold,
        color: Color.fromRGBO(169, 36, 18, 1)
    )):Container(
            height: 45,
            color: Color.fromRGBO(217, 217, 217, 0.5),
            child: Row(
              children: [
                Text("  Comanda: ",style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
                Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: Text(CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index],style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(169, 36, 18, 1)
                  ),),
                ),
                Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.43)),
                CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]!="0"?GestureDetector(
                  onTap: (){
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Tem certeza que deseja remover a comanda \"${CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]}\"?"),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);},
                                    child: Text("Não")),
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                  setState(() {
                                    CartInfo.prods.reversed.toList();

                                    CartInfo.prods.sort((a, b) => a.NUM_COMANDA.compareTo(b.NUM_COMANDA));
                                    CartInfo.prods.removeWhere((element) => element.NUM_COMANDA==CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]);
                                  });
                                },
                                    child: Text("Sim"))
                              ],
                            );
                          });



                    });
                  },
                  child: Container(
                      width: 50,
                      height: 25,
                      child: Image.asset('imagens/rmvcmd.png')
                  ),
                ):Container(
                  width: 50,
                ),

              ],
            ),
          ),
          Container(
            color: CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]=="0"?Colors.transparent:Color.fromRGBO(217, 217, 217, 0.2),
              height: CartInfo.prods.where((cmd) => cmd.NUM_COMANDA==CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]).length*50,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
              itemCount: CartInfo.prods.where((cmd) => cmd.NUM_COMANDA==CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]).length,
              itemBuilder: (context, index2) {
                return _cardprod(index2,CartInfo.prods.map((e) => e.NUM_COMANDA).toSet().toList()[index]);
              }))
        ],
      ),
    );


  }


}
