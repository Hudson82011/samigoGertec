import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

import '../../../LocalInfo/EnterpriseConfig.dart';
import '../../../LocalInfo/LocalBase.dart';
import '../../CaixaMobile/CartBack/CartInfo.dart';

import '../../login.dart';
import 'nfcePage.dart';




class PostNfce{

  String _contains(Map<String,dynamic>_val,String key){

    String val="";

    try{
      val=_val[key][0];
    }catch(err){
      val="";
    }

    return val;


  }

  Future<int> enviaNfce(BuildContext context,double valorAtrelado,int forma,String codCli) async{

    if(CartInfo.total()-valorAtrelado<=0.01){
      CartInfo.cartId=randomAlphaNumeric(32).toUpperCase();
      List itensList=[];
      List formaPagList=[];

      Map<dynamic, dynamic> json_config = Map();
      json_config['itens']=[];
      json_config['nota']={};


      Map<dynamic, dynamic> inforCard = Map();
      Map<String,dynamic> _cardBody={};



      if(CartInfo.pos){
        inforCard["tipo_cartao"] ="-77";
        inforCard["bandeira"] = CartInfo.bandeira;
        inforCard["flg_dc"] = forma == 3 ? "C" : "D";
        //inforCard['autorizacao']="-77";


      }else {
        if (forma == 3 || forma == 4) {
          try {
            _cardBody = json.decode(CartInfo.lastCardInfo.TIPO_CAMPOS!);
            _cardBody.forEach((key, value) {
              print(key + ":" + value);
            });
          } catch (err) {

          }


          // inforCard["tipo_cartao"] =_contains(_cardBody,"2");
          inforCard["tipo_cartao"] =_contains(_cardBody,"2");
          inforCard["bandeira"] = _contains(_cardBody,"156");
          inforCard["cod_rede"] = _contains(_cardBody,"158");
          inforCard["flg_dc"] = forma == 3 ? "C" : "D";
          inforCard["nsu"] = _contains(_cardBody,"134");
          inforCard["rede_adquirente"] =_contains(_cardBody,"158");
          inforCard["autorizacao"] = CartInfo.lastCardInfo.COD_AUTORIZACAO;
          inforCard["parcelas"] = CartInfo.lastCardInfo.NUM_PARC ?? "1";
          inforCard["cnpj_adquirente"] = "";
          inforCard["num_cartao"] = _contains(_cardBody,"2021");
        }
      }

      Map<dynamic, dynamic> pedido = Map();
      pedido["id"]=CartInfo.cartId;
      pedido["numero"]=Random(999999).nextInt(15).toString();
      pedido["tipo"]="Balcão";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
      pedido["datahora"]=formattedDate;
      pedido["total_itens"]=CartInfo.totalItens();
      pedido["total_geral"]=CartInfo.total();
      pedido["valor_acrescimo"]="0";//CartInfo.acreProds;
      pedido["valor_desconto"]="0";//CartInfo.descProds;
      pedido["valor_frete"]=0;
      pedido["cod_fun"]=codVend;

      json_config['nota']={"cod_cli":codCli};

      for(var x in CartInfo.prods){
        Map<dynamic, dynamic> itens = Map();
        itens["codigo"] = x.COD_PROD;
        itens["descricao"] = x.DESCRICAO;
        itens["unidade"] = x.FLG_UNIDADE_VENDA;
        itens["valor_unitario"] = x.VLR_PRECO;
        itens["quantidade"] = x.VLR_QTDE;
        itens["valor_total"] = x.VLR_TOTAL;
        itens["valor_desconto"] = x.VLR_DESCONTO;
        itens["valor_acrescimo"] = x.VLR_ACRESCIMO;


        json_config['itens'].add({"item":CartInfo.prods.indexOf(x)+1,"cod_vend":x.COD_VEND});


        itensList.add(itens);
      }

      Map<dynamic, dynamic> client = Map();
      client["cpf"]=CartInfo.cpf;
      client["nome"]="";
      client["cod_cli"]=codCli;

      Map<dynamic, dynamic> formaPag = Map();
      formaPag["id_forma"]=forma;
      formaPag["valor_forma"]=valorAtrelado;
      formaPagList.add(formaPag);


      /*"json_config":{
    "nota": {"cod_cli":"7"},
    "itens":[{"item":"1","cod_vend":"11"},{"item":"2","cod_vend":"15"}]
    }*/







      Map<dynamic, dynamic> nota = Map();
      nota["pedido"] = pedido;
      nota["itens"] = itensList;

      if(forma==3||forma==4){
        nota["info_cartao"] = inforCard;
      }

      if(CartInfo.payMulti.isNotEmpty){
        nota["forma_pag"] = CartInfo.payMulti;
      }else{
        nota["forma_pag"] = formaPagList;
      }


      nota['json_config']=json_config;
      if(CartInfo.cpf!=""){
        nota["cliente"]=client;
      }


      print(nota);

      var url =
          "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ReceberPedido/${EnterpriseConfig.banco}/${EnterpriseConfig.deviceId}";
      print(url);
      var response = await http.post(Uri.parse(url),
          headers: {'authorization': EnterpriseConfig.auth}, body: json.encode(nota));/*.onError((
          error, stackTrace) {
         showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Falha ao enviar NFCE, verifique o servidor!"));
            });
      });*/

      print(response.body);
      //o=true;

      return 0;

    }
    else{

       showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "O valor informado precisa ser igual ou maior ao total da compra!"));

          });

       return 1;
    }

  }

  Future<int> attNfce(String id,String status) async{




    Map<dynamic, dynamic> body = Map();
    body['id']=id;
    body['status_envio']=status;



    var url =
        "http://${EnterpriseConfig.hostname}/datasnap/rest/tsammi/func_atualizarpedido/${EnterpriseConfig.banco}/${EnterpriseConfig.deviceId}";
    print(url);
    var response = await http.post(Uri.parse(url),
        headers: {'authorization': EnterpriseConfig.authS}, body: json.encode(body));/*.onError((
          error, stackTrace) {
         showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Falha ao enviar NFCE, verifique o servidor!"));
            });
      });*/

    print(response.body);
    //CartInfo.dinheiro=true;

    return 0;



    /* showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "O valor informado precisa ser igual ou maior ao total da compra!"));

          });

      return 1;*/


  }

  Future<String> retornaXML(bool re,String note) async {
    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedidoXML/${EnterpriseConfig.banco}/id='${note}'/XML";
    if(!re){
      LocalBase.lastNote=CartInfo.cartId;
    }

    String xml64="";

    ///var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedidoXML/$banco/id='255E1A5AC32D49BC8C6B6810BBC73F1X'/JSON";
    var response = await http.get(
        Uri.parse(url), headers: {'authorization': EnterpriseConfig.auth});
    print(response.body);


    Map<String,dynamic> res=Map();
    res=json.decode(response.body.replaceAll("[","").replaceAll("]",""));
    print(res);
    xml64=res["documento_xml_resposta"];
    /* try{
      nota=json.decode(response.body)[0]['cod_vnd_nota'];
    }catch(err){
      print(err);
    }*/
    //print(xml64);

    return xml64;

  }

  Future<String> retornaXMLre(bool re,String note) async {
    var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedidoXML/${EnterpriseConfig.banco}/COD_VND_NOTA='${note}'/XML";
    if(!re){
      LocalBase.lastNote=CartInfo.cartId;
    }

    String xml64="";

    ///var url = "http://${EnterpriseConfig.hostname}/datasnap/rest/tpreatend/func_ConsultarPedidoXML/$banco/id='255E1A5AC32D49BC8C6B6810BBC73F1X'/JSON";
    var response = await http.get(
        Uri.parse(url), headers: {'authorization': EnterpriseConfig.auth});
    print(response.body);


    Map<String,dynamic> res=Map();
    res=json.decode(response.body.replaceAll("[","").replaceAll("]",""));
    print(res);
    xml64=res["documento_xml_resposta"];
    /* try{
      nota=json.decode(response.body)[0]['cod_vnd_nota'];
    }catch(err){
      print(err);
    }*/
    //print(xml64);

    return xml64;

  }



}