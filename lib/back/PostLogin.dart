import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../LocalInfo/EnterpriseConfig.dart';




class PostLogin{


 /* Future<dynamic>login(BuildContext context,String cod,String pin)async{
    print({"cod_func":cod,"senha":pin});
    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_LoginFunc/${EnterpriseConfig.banco}";

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.auth},
        body: json.encode({"cod_func":cod,"senha":pin})
    ).timeout(Duration(seconds: 15),onTimeout: (){

      print("timeout");
      return throw showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Não foi possivel de conectar ao servidor:${EnterpriseConfig.hostname}"));
          });

    });
    print(response.body);
    if (response.body=="[]") {
      print(response.body);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Usuário ou senha incorretos! Tente novamente!"));
          });
    }else if(response.body.length<210){
      print(response.body);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Preencha usuario e senha!"));
          });
    }else if (response.statusCode==200){
      print(response.body);
      List<Login> login = [];
      var logsJson = json.decode(response.body);
      for (var logJson in logsJson) {
        login.add(Login.fromJson(logJson));

      }
      if(login[0].CHK_CAIXA=='T'){
        FuncInfos.funcName=login[0].nome;
        FuncInfos.codVend=login[0].cod_func;
        FuncInfos.excItem=login[0].CHK_EXCLUIR_ITEM=="T"?true:false;
        FuncInfos.gerente=login[0].CHK_SANGRIAS=="T"?true:false;

        FuncInfos.codFunc=cod;


        return Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) =>MainScreen()));
      }else{
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("O usuario não possui permissão para acessar o caixa!"));
            });
      }
    }
    else{
      print(response.body);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Erro de conexão, verifique o servidor! Se precisar, contate nosso Suporte Técnico."));
          });

    }

  }*/


  Future<bool> loginFunc(BuildContext context,String cod,String pin,String func,String msg)async{

    bool permi=false;

    print({"cod_func":cod,"senha":pin});
    var urlL =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_LoginFunc/${EnterpriseConfig.banco}";

    var response = await http.post(Uri.parse(urlL), headers: {'authorization': EnterpriseConfig.auth},
        body: json.encode({"cod_func":cod,"senha":pin})
    );
    print(response.body);
    if (response.body=="[]") {
      print(response.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Usuário ou senha incorretos! Tente novamente!"));
          });
    }else if(response.body.length<210){
      print(response.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Preencha usuario e senha!"));
          });
    }else if (response.statusCode==200){
      print(response.body);

      Map<String,dynamic>_val=Map();
      _val=json.decode(response.body)[0];

      if(_val.containsKey(func)&&_val[func]=="T"){
        permi=true;
      }else{
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "O usuario não possui permissão para $msg."));
            });
      }

      /* List<Login> login = [];
      var logsJson = json.decode(response.body);
      for (var logJson in logsJson) {
        login.add(Login.fromJson(logJson));
        FuncInfos.funcName=login[0].nome;
        FuncInfos.codVend=login[0].cod_func;
        FuncInfos.excItem=login[0].CHK_EXCLUIR_ITEM=="T"?true:false;
        FuncInfos.gerente=login[0].CHK_SANGRIAS=="T"?true:false;


      }*/


    }
    else{
      print(response.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Erro de conexão, verifique o servidor! Se precisar, contate nosso Suporte Técnico."));
          });

    }





    return permi;
  }



}