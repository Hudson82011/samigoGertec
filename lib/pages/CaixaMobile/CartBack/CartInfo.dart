

import '../../../TEF/TEFReturn.dart';
import '../../../mapClasses/ProdsCart.dart';

class CartInfo{


  static List<ProdsCart> prods=[];
  static String cartId="";

  static double total(){

    double total=0;


    total = CartInfo.prods
        .map<double>((m) =>double.parse(m.VLR_TOTAL))
        .reduce((a, b) => a + b);

    return total;
  }

  static String cpf="";


  static double trocoGerado=0;

  static String lastCard="";


  static String lastCardLoja="";


  static TEFReturn lastCardInfo= TEFReturn(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
  );

  static bool prazo=false;
  static String cli="";


  static List payMulti=[];






  static double totalItens(){

    double total = 0;

    if (CartInfo.prods.isNotEmpty) {
      total = CartInfo.prods
          .map<double>((m) => (double.tryParse(m.VLR_TOTAL) ?? 0)+(double.tryParse(m.VLR_DESCONTO)??0)+(double.tryParse(m.VLR_ACRESCIMO)??0))
          .reduce((a, b) => a + b);

    }

    return total;


  }



  static ProdsCart prod = ProdsCart(
      COD_PROD: "",
      DESCRICAO: "",
      FLG_UNIDADE_VENDA: "",
      VLR_PRECO: "",
      VLR_QTDE: "",
      VLR_TOTAL: "",
      VLR_ACRESCIMO: "",
      VLR_DESCONTO: "",
      NUM_COMANDA: "",
      DOCUMENTO: "",COD_VEND: "0",
      BARRAS:'',
      //COD_VEND: ""
  );

  static String cardCupom="";



  static bool pos=false;

  static String bandeira="";




}