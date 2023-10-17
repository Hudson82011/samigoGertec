
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';



import 'package:sammi_gov2/pages/CaixaMobile/AddProd.dart';

import '../../LocalInfo/LocalBase.dart';
import '../../ball/blue_ball.dart';
import '../../mapClasses/Search_t.dart';
import '../login.dart';


class AddCartProd extends StatefulWidget {
  @override
  _AddCartProdtate createState() => _AddCartProdtate();
}

class _AddCartProdtate extends State<AddCartProd> {

  TextEditingController _prodController=TextEditingController();

  List<Search_t>prodDisplay1=[];
  List<Search_t> prodDisplay=[];



  void initState(){

    setState(() {
      prodDisplay1.addAll(LocalBase.prods);
      prodDisplay.addAll(LocalBase.prods);
    });

    super.initState();
  }

  bool _catOn=false;
  String _cat="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          backgroundColor: Color.fromRGBO(70, 26, 26, 1),
          title: Image.asset("imagens/sammigo 1.png",scale: 3.5,),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Container(
                    height: 60,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0
                          //childAspectRatio: 1,
                          //crossAxisSpacing: 1,
                        ),
                        itemCount: LocalBase.cats.length+1,
                        itemBuilder: (context, index) {
                          return index == 0 ? _allProds() : _category(index - 1);
                        }),
                  ),
                      Container(
                        // color: Colors.blueAccent,
                          width: MediaQuery.of(context).size.width*0.95,
                          height: MediaQuery.of(context).size.height*0.12,
                          child: Row(
                            children: [
                              Expanded(
                                child:TextFormField(

                                    controller: _prodController,
                                    onChanged: (text) {
                                      text = text.toLowerCase();
                                      setState(() {

                                        prodDisplay1 = prodDisplay.where((produto) {
                                          var produtosDesc = produto.descricao.toLowerCase() +
                                              produto.cod_prod.toString();
                                          return produtosDesc.contains(text);
                                        }).toList();});
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
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
                              Icon(Icons.search,size: 35,)

                            ],
                          )
                      ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: prodDisplay1.length,
                        itemBuilder: (context, index) {
                          return _cardProd(index);
                        }),
                  ),

                ])));



  }

  _cardProd(index) {
    return GestureDetector(
      onTap: () {
        BlueBall().priceTrigger();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddProd(prodDisplay1[index])))
            .then((value) {
          setState(() {

            prodDisplay1 = prodDisplay;
          });
        });
        _prodController.text = "";
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              child: Center(
                child: Text(prodDisplay1[index].cod_prod.toString()),
              ),
            ),
            Container(
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prodDisplay1[index].descricao,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
           Container(
             width: 30,
             child:  Text(
               "${prodDisplay1[index].flg_unidade_venda}",
               textAlign: TextAlign.start,
               style: TextStyle(fontSize: 12),
             ),
           ),
            Container(
              width: 40,
              child: Text(
                  double.parse(prodDisplay1[index].vlr_preco.toString())
                      .toStringAsFixed(2),
                  style: TextStyle(fontSize: 13)),
            ),
            Container(
              width: 50,
              height: 25,
              child: Image.asset('imagens/add.png')
            )
          ],
        ),
      ),
    );
  }

  _allProds() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _catOn=false;
            _cat="";
            prodDisplay1=prodDisplay;
            _prodController.text="";
          });
        },
        child: Column(
          children: [
            Container(
                width: 51,
                height: 51,
                child: Image.asset("imagens/todos.png", fit: BoxFit.fill)),
            Container(
              child: Text(
                "Todos",
                style: TextStyle(fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ));
  }

  _category(index) {
    return GestureDetector(
        onTap: () {
          _catOn=true;
          _cat=LocalBase.cats[index].COD_CATEGORIA.toString();
          setState(() {
            /* prodDisplay1 = produtos1.where((produto) {
              var produtosDesc = produto.cod_categoria.toString();
              return produtosDesc
                  .contains(categorias2[index].COD_CATEGORIA.toString());
            }).toList();*/
            prodDisplay1 = prodDisplay.where((produto) {
              var produtosDesc = produto.cod_categoria.toString();
              return produtosDesc==_cat;
            }).toList();
          });
        },
        child: Column(
          children: [
            Container(
                color: Colors.black,
                width: 51,
                height: 51,
                child: LocalBase.cats[index].IMAGEM_BASE64 == null
                    ? Image.asset("images/semfoto.png", fit: BoxFit.fill)
                    : Image.memory(
                    base64Decode(
                      LocalBase.cats[index].IMAGEM_BASE64,
                    ),
                    fit: BoxFit.fill)),
            Container(
              child: Text(
                LocalBase.cats[index].DESCRICAO.toString(),
                style: TextStyle(fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }



}
