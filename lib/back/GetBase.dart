import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:sammi_gov2/pages/CaixaMobile/AddProd.dart';

import '../../mapClasses/Search_t.dart';
import '../LocalInfo/EnterpriseConfig.dart';
import '../mapClasses/Cards.dart';
import '../mapClasses/barrasVinculadas.dart';
import '../mapClasses/categorias.dart';
import '../pages/login.dart';


class GetBase{

  static List<Barras> barras=[];

  Future<List<Search_t>> returnProds() async {
    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_GetProdutos/T";
    var response = await http.get(Uri.parse(url),
      headers: {'authorization': auth},
    );
    ///print(response.statusCode);
    /// var response = await http.get(url);
    List<Search_t> produtos = [];
    var prodJson = json.decode(response.body);
    for (var prodJson in prodJson) {
      produtos.add(Search_t.fromJson(prodJson));
    }
    return produtos;
  }




  Future<List<Categorias>> retornaCate() async {
    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_GetCategorias/T";
    var response = await http.get(Uri.parse(url), headers: {'authorization': auth});
    //var response = await http.get(url);
    List<Categorias> categorias =[];
    var catJson = json.decode(response.body);
    for (var catsJson in catJson) {
      categorias.add(Categorias.fromJson(catsJson));
    }

    return categorias;
  }


  Future <List<Cards>>retornaCard(String cnpj) async {

    print('chamando cartões');

    print(auth);


    var url = "https://twapi.ommini.com.br/sammi/getsammibandeiras?cnpj=$cnpj";
    var response = await http.get(Uri.parse(url), headers: {'authorization': 'Bearer '+tokenTw});

    print(response.body);
    List<Cards> cards =[];
    var catJson = json.decode(response.body)["bandeiras"];
    for (var catsJson in catJson) {
      cards.add(Cards.fromJson(catsJson));
   }

    return cards;
  }

  Future<List<Barras>> retornaBarras() async {


    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_GetBarrasVinculadas/${EnterpriseConfig.banco}";
    var response = await http.get(
      Uri.parse(url),
      headers: {'authorization': EnterpriseConfig.auth},
    );

    print(response.body);

    List<Barras> produtos = [];

    try{
      var prodJson = json.decode(response.body);
      for (var prodJson in prodJson) {
        produtos.add(Barras.fromJson(prodJson));
      }
    }catch(err){
      print(err);
    }

    return produtos;
  }


}