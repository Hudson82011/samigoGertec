import 'package:flutter/material.dart';
import 'package:sammi_gov2/pages/CaixaMobile/tef/service_msitef.dart';
import '../../../../TEF/Elgin/service_tefelgin.dart';
import '../../../../TEF/TEFReturn.dart';
import '../../../../printer/printer.dart';
import '../../../LocalInfo/EnterpriseConfig.dart';
import '../../PagaComanda/Fiscal/PostNfce.dart';
import '../../PagaComanda/Fiscal/nfcePage.dart';
import '../CartBack/CartInfo.dart';


part 'Acao.dart';
part 'FormaFinanciamento.dart';
part 'FormaPagamento.dart';
part 'TEF.dart';


class Elgin{

  PrinterService printerService = new PrinterService();

  String _ultimoNSU = "";


  sendElginTefParams(Acao acao,String val,String parc,String formaPag,BuildContext context) async {
    TEFReturn? tefReturn;

    switch (acao) {
      case Acao.VENDA:
        tefReturn = await TefElgin.sendOptionSale(
            valor:val,
            parcelas: parc,
            formaPagamento: formaPag,
            tipoParcelamento:"a_vista" );
        break;
      case Acao.CANCELAMENTO:
      //Caso o NSU esteja vazio, não deverá ser possível realizar o cancelamento.
        if (_ultimoNSU.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                        "É necessário realizar uma transação antes para realizar o cancelamento no TEF ELGIN!"));
              });}

        var dt = DateTime.now();
        String dateFormat = "${dt.year}${dt.month}${dt.day}";

        tefReturn = await TefElgin.sendOptionCancel(
            valor: val, data: dateFormat, nsuSitef: _ultimoNSU);
        break;
      case Acao.CONFIGURACAO:
        UnimplementedError(
            "Esta ação ainda não está disponível para o Elgin Tef!");
        break;
    }

    //Se o objeto de serialização estiver nulo, conforme a implementação, é porque ocorreu algum erro durante a operação.
    if (tefReturn != null) {

      /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Ação realizada com sucesso."));
          });*/

      PostNfce().enviaNfce(context, CartInfo.total(), 03,"0");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Nfce()),
          ModalRoute.withName('/')
      );


      //Se a via do cliente não estiver nula, a mesma será mostrada na tela e impressa.
      if (tefReturn.VIA_CLIENTE != null) {
        /* setState(() {
          boxText = tefReturn!.VIA_CLIENTE!;
        });*/

        this._ultimoNSU = tefReturn.NSU_SITEF!;

        //Realiza impressão da via cliente.
        printerService.sendPrinterText(
          text: tefReturn.VIA_CLIENTE!,
          align: "Centralizado",
          font: "FONT B",
          fontSize: 0,
          isBold: false,
        );

        printerService.jumpLine(10);
        printerService.cutPaper(10);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Ocorreu um erro durante a transação."));
          });

    }
  }

  sendSitefParams(Acao acao,String val,String parc,FormaPagamento formaPag,BuildContext context) async {
    TEFReturn? tefReturn;

    switch (acao) {
      case Acao.VENDA:
        tefReturn = await MSitefService.sendOptionSale(
            enderecoSitef: EnterpriseConfig.ipSitef,
            valor: val,
            formaPagamento: formaPag,
            formaFinanciamento:FormaFinanciamento.A_VISTA,
            numParcelas:parc);
        break;
      case Acao.CANCELAMENTO:
        tefReturn = await MSitefService.sendOptionCancel(
          enderecoSitef: EnterpriseConfig.ipSitef,
          valor: val,
        );
        break;
      case Acao.CONFIGURACAO:
        tefReturn = await MSitefService.sendOptionConfigs(
          enderecoSitef: EnterpriseConfig.ipSitef,  valor: val,);
        break;
    }

    //Se o objeto de serialização estiver nulo, conforme a implementação, é porque ocorreu algum erro durante a operação.
    if (tefReturn != null) {

      print(tefReturn.toJson());

      if(tefReturn.VIA_CLIENTE!.isEmpty){

      }else if(acao==Acao.CONFIGURACAO&&tefReturn.VIA_CLIENTE!.isNotEmpty){

       // ImpD2().impVal(tefReturn.VIA_CLIENTE.toString());

      //  ImpD2().impVal("--------------------");

       // ImpD2().impVal(tefReturn.VIA_ESTABELECIMENTO.toString());



      } else{

        CartInfo.lastCardInfo=tefReturn;
        CartInfo.lastCardLoja=tefReturn.VIA_ESTABELECIMENTO!;
        CartInfo.lastCard=tefReturn.VIA_CLIENTE!;
        print(tefReturn.toJson());

        PostNfce().enviaNfce(context, CartInfo.total(), formaPag._rotulo=="credito"?03:04,"0");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Nfce()),
            ModalRoute.withName('/')
        );
      }

      //Se a via do cliente não estiver nula, a mesma será mostrada na tela e impressa.
      if (tefReturn.VIA_CLIENTE != null) {

        //  boxText = tefReturn!.VIA_CLIENTE!;


        //Realiza impressão da via cliente.
        printerService.sendPrinterText(
          text: tefReturn.VIA_CLIENTE!,
          align: "Centralizado",
          font: "FONT B",
          fontSize: 0,
          isBold: false,
        );

        printerService.jumpLine(10);
        printerService.cutPaper(10);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Ocorreu um erro durante a transação."));
          });
    }
  }



}





/*class Elgin extends StatefulWidget {
  @override
  _SitefPageState createState() => _SitefPageState();
}

class _SitefPageState extends State<SitefPage> {
  TextEditingController inputValue = new TextEditingController(text: "2000");
  TextEditingController inputInstallments =
      new TextEditingController(text: "2");
  TextEditingController inputIp =
      new TextEditingController(text: "192.168.0.31");

  //Variáveis de controle para as opções selecionadas
  TEF _opcaoTefSelecionada = TEF.PAY_GO;
  FormaPagamento _formaPagamentoSelecionada = FormaPagamento.CREDITO;
  FormaFinanciamento _formaFinanciamentoSelecionada = FormaFinanciamento.LOJA;

  //Campo utilizado para salvar a referência do ultimo NSU retornado pelo Elgin Tef, que será utilizado para cancelamento.
  String _ultimoNSU = "";

  String boxText = '';
  String imageViaClientBase64Paygo = '';


  PrinterService printerService = new PrinterService();


  String accessTokenShipay = '';
  String statusSaleShipay = '';
  String orderIDShipay = '';
  String valueLastSale = '';
  String qrCodeViaClientBase64Shipay = '';

  @override
  void initState() {
    super.initState();
    printerService.connectInternalImp().then((value) => print(value));
  }

 /* onChangePaymentMethod(FormaPagamento _formaPagamentoSelecionada) {
    setState(
        () => {this._formaPagamentoSelecionada = _formaPagamentoSelecionada});
  }

  onChangeInstallmentsMethod(
      FormaFinanciamento _formaFinanciamentoSelecionada) {
    setState(() => {
          this._formaFinanciamentoSelecionada = _formaFinanciamentoSelecionada,
          if (_formaFinanciamentoSelecionada != FormaFinanciamento.A_VISTA)
            {inputInstallments.text = "2"}
          else
            {inputInstallments.text = "1"}
        });
  }

  onChangeTypeTefMethod(TEF _opcaoTefSelecionada) {
    setState(() => {
          this._opcaoTefSelecionada = _opcaoTefSelecionada,
        });
    //Sempre que um novo TEF for selecionado, a forma de pagamento e forma de parcelamento devem ser resetadas.
    onChangePaymentMethod(FormaPagamento.CREDITO);
    onChangeInstallmentsMethod(FormaFinanciamento.LOJA);
  }*/

  startActionTEF(Acao acao) {
   // if (isEntrisValid()) {
      switch (_opcaoTefSelecionada) {
    /*    case TEF.PAY_GO:
          sendPaygoParams(acao);
          break;
        case TEF.M_SITEF:
          sendSitefParams(acao);
          break;*/
        case TEF.ELGIN_TEF:
          sendElginTefParams(acao);
          break;
      }
   // }
  }



 /* sendSitefParams(Acao acao) async {
    TEFReturn? tefReturn;

    switch (acao) {
      case Acao.VENDA:
        tefReturn = await MSitefService.sendOptionSale(
            enderecoSitef: inputIp.text,
            valor: inputValue.text,
            formaPagamento: _formaPagamentoSelecionada,
            formaFinanciamento: _formaFinanciamentoSelecionada,
            numParcelas: inputInstallments.text);
        break;
      case Acao.CANCELAMENTO:
        tefReturn = await MSitefService.sendOptionCancel(
          enderecoSitef: inputIp.text,
          valor: inputValue.text,
        );
        break;
      case Acao.CONFIGURACAO:
        tefReturn = await MSitefService.sendOptionConfigs(
            enderecoSitef: inputIp.text, valor: inputValue.text);
        break;
    }

    //Se o objeto de serialização estiver nulo, conforme a implementação, é porque ocorreu algum erro durante a operação.
    if (tefReturn != null) {
      Components.infoDialog(
          context: context, message: "Ação realizada com sucesso.");

      //Se a via do cliente não estiver nula, a mesma será mostrada na tela e impressa.
      if (tefReturn.VIA_CLIENTE != null) {
        setState(() {
          boxText = tefReturn!.VIA_CLIENTE!;
        });

        //Realiza impressão da via cliente.
        printerService.sendPrinterText(
          text: tefReturn.VIA_CLIENTE!,
          align: "Centralizado",
          font: "FONT B",
          fontSize: 0,
          isBold: false,
        );

        printerService.jumpLine(10);
        printerService.cutPaper(10);
      }
    } else {
      Components.infoDialog(
          context: context, message: "Ocorreu um erro durante a transação.");
    }
  }*/

  sendElginTefParams(Acao acao) async {
    TEFReturn? tefReturn;

    switch (acao) {
      case Acao.VENDA:
        tefReturn = await TefElgin.sendOptionSale(
            valor: inputValue.text,
            parcelas: inputInstallments.value.text,
            formaPagamento: _formaPagamentoSelecionada,
            tipoParcelamento: _formaFinanciamentoSelecionada);
        break;
      case Acao.CANCELAMENTO:
        //Caso o NSU esteja vazio, não deverá ser possível realizar o cancelamento.
        if (_ultimoNSU.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                        "É necessário realizar uma transação antes para realizar o cancelamento no TEF ELGIN!"));
              });}

        var dt = DateTime.now();
        String dateFormat = "${dt.year}${dt.month}${dt.day}";

        tefReturn = await TefElgin.sendOptionCancel(
            valor: inputValue.text, data: dateFormat, nsuSitef: _ultimoNSU);
        break;
      case Acao.CONFIGURACAO:
        UnimplementedError(
            "Esta ação ainda não está disponível para o Elgin Tef!");
        break;
    }

    //Se o objeto de serialização estiver nulo, conforme a implementação, é porque ocorreu algum erro durante a operação.
    if (tefReturn != null) {

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Ação realizada com sucesso."));
          });

      //Se a via do cliente não estiver nula, a mesma será mostrada na tela e impressa.
      if (tefReturn.VIA_CLIENTE != null) {
        setState(() {
          boxText = tefReturn!.VIA_CLIENTE!;
        });

        this._ultimoNSU = tefReturn.NSU_SITEF!;

        //Realiza impressão da via cliente.
        printerService.sendPrinterText(
          text: tefReturn.VIA_CLIENTE!,
          align: "Centralizado",
          font: "FONT B",
          fontSize: 0,
          isBold: false,
        );

        printerService.jumpLine(10);
        printerService.cutPaper(10);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Ocorreu um erro durante a transação."));
          });

    }
  }


  /*
  //Valida as entradas.
  bool isEntrisValid() {
    if (inputValue.text.isEmpty) {
      Components.infoDialog(
          context: context, message: "Informe o valor da venda.");
      return false;
    }

    if (_opcaoTefSelecionada == TEF.M_SITEF) {
      if (Utils.validaIp(inputIp.text)) {
        Components.infoDialog(
            context: context, message: "Informe um IP válido.");
        return false;
      }
    }

    if (_formaPagamentoSelecionada == FormaPagamento.CREDITO) {
      if (_formaFinanciamentoSelecionada != FormaFinanciamento.A_VISTA) {
        if (inputInstallments.text.isEmpty) {
          Components.infoDialog(
              context: context, message: "Informe o número de parcelas.");
          return false;
        } else if (int.parse(inputInstallments.text) < 2) {
          Components.infoDialog(
              context: context,
              message: "Informe um número de parcelas válido.");
          return false;
        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 30),
              GeneralWidgets.headerScreen("TEF"),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: fieldsMsitef(),
                  ),
                  SizedBox(width: 30),
                  boxScreen(),
                ],
              ),
              GeneralWidgets.baseboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageViaClienteBase64Paygo() {
    if (imageViaClientBase64Paygo == "") return new Container();

    Uint8List bytes = Base64Codec().decode(imageViaClientBase64Paygo);

    return new Image.memory(bytes, fit: BoxFit.contain);
  }

  Widget boxScreen() {
    return Container(
      height: 400,
      width: 350,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            children: [
              if (_opcaoTefSelecionada == TEF.PAY_GO &&
                  imageViaClientBase64Paygo != "") ...{
                imageViaClienteBase64Paygo(),
              } else ...{
                Text(boxText)
              }
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldsMsitef() {
    return Container(
      height: 410,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          typeOfTefMethodWidget(),
          GeneralWidgets.inputField(
            inputValue,
            'VALOR:  ',
            textSize: 14,
            iWidht: 350,
            textInputType: TextInputType.number,
          ),
          if (_formaPagamentoSelecionada == FormaPagamento.CREDITO) ...{
            GeneralWidgets.inputField(
              inputInstallments,
              'Nº PARCELAS:  ',
              textSize: 14,
              iWidht: 350,
              textInputType: TextInputType.number,
              isEnable:
                  _formaFinanciamentoSelecionada != FormaFinanciamento.A_VISTA,
            )
          },
          GeneralWidgets.inputField(
            inputIp,
            'IP:  ',
            textSize: 14,
            iWidht: 350,
            isEnable: _opcaoTefSelecionada == TEF.M_SITEF,
            textInputType: TextInputType.number,
          ),
          Text("FORMAS DE PAGAMENTO:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          paymentsMethodsWidget(),
          Text("TIPO DE PARCELAMENTO:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          if (_formaPagamentoSelecionada == FormaPagamento.CREDITO) ...{
            installmentsMethodsWidget(),
          },
          Row(
            children: [
              GeneralWidgets.personButton(
                textButton: "ENVIAR TRANSAÇÃO",
                callback: () => startActionTEF(Acao.VENDA),
              ),
              SizedBox(width: 20),
              GeneralWidgets.personButton(
                textButton: "CANCELAR TRANSAÇÃO",
                callback: () => startActionTEF(Acao.CANCELAMENTO),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (_opcaoTefSelecionada != TEF.ELGIN_TEF) ...{
            GeneralWidgets.personButton(
              textButton: "CONFIGURAÇÃO",
              callback: () => startActionTEF(Acao.CONFIGURACAO),
            ),
          }
        ],
      ),
    );
  }

  Widget paymentsMethodsWidget() {
    return Row(
      children: [
        GeneralWidgets.personSelectedButton(
          nameButton: 'Crédito',
          fontLabelSize: 12,
          assetImage: 'assets/images/card.png',
          isSelectedBtn: _formaPagamentoSelecionada == FormaPagamento.CREDITO,
          onSelected: () => onChangePaymentMethod(FormaPagamento.CREDITO),
        ),
        GeneralWidgets.personSelectedButton(
          nameButton: 'Débito',
          fontLabelSize: 12,
          assetImage: 'assets/images/card.png',
          isSelectedBtn: _formaPagamentoSelecionada == FormaPagamento.DEBITO,
          onSelected: () => onChangePaymentMethod(FormaPagamento.DEBITO),
        ),
        if (_opcaoTefSelecionada != TEF.ELGIN_TEF) ...{
          GeneralWidgets.personSelectedButton(
            nameButton: 'Todos',
            fontLabelSize: 12,
            assetImage: 'assets/images/voucher.png',
            isSelectedBtn: _formaPagamentoSelecionada == FormaPagamento.TODOS,
            onSelected: () => onChangePaymentMethod(FormaPagamento.TODOS),
          ),
        }
      ],
    );
  }

  Widget typeOfTefMethodWidget() {
    return Row(
      children: [
        GeneralWidgets.personSelectedButton(
          nameButton: 'PayGo',
          fontLabelSize: 14,
          mWidth: 70,
          mHeight: 30,
          isSelectedBtn: _opcaoTefSelecionada == TEF.PAY_GO,
          onSelected: () => onChangeTypeTefMethod(TEF.PAY_GO),
        ),
        SizedBox(width: 5),
        GeneralWidgets.personSelectedButton(
          nameButton: 'M-Sitef',
          fontLabelSize: 14,
          mWidth: 70,
          mHeight: 30,
          isSelectedBtn: _opcaoTefSelecionada == TEF.M_SITEF,
          onSelected: () => onChangeTypeTefMethod(TEF.M_SITEF),
        ),
        SizedBox(width: 5),
        GeneralWidgets.personSelectedButton(
          nameButton: 'Elgin Tef',
          fontLabelSize: 14,
          mWidth: 70,
          mHeight: 30,
          isSelectedBtn: _opcaoTefSelecionada == TEF.ELGIN_TEF,
          onSelected: () => onChangeTypeTefMethod(TEF.ELGIN_TEF),
        ),
      ],
    );
  }

  Widget installmentsMethodsWidget() {
    return Row(
      children: [
        GeneralWidgets.personSelectedButton(
          nameButton: 'Loja',
          fontLabelSize: 12,
          isSelectedBtn:
              _formaFinanciamentoSelecionada == FormaFinanciamento.LOJA,
          assetImage: 'assets/images/store.png',
          onSelected: () => onChangeInstallmentsMethod(FormaFinanciamento.LOJA),
        ),
        GeneralWidgets.personSelectedButton(
          nameButton: 'Adm',
          fontLabelSize: 12,
          isSelectedBtn:
              _formaFinanciamentoSelecionada == FormaFinanciamento.ADM,
          assetImage: 'assets/images/adm.png',
          onSelected: () => onChangeInstallmentsMethod(FormaFinanciamento.ADM),
        ),
        if (_opcaoTefSelecionada != TEF.M_SITEF) ...{
          GeneralWidgets.personSelectedButton(
            nameButton: 'A vista',
            fontLabelSize: 12,
            isSelectedBtn:
                _formaFinanciamentoSelecionada == FormaFinanciamento.A_VISTA,
            assetImage: 'assets/images/card.png',
            onSelected: () =>
                onChangeInstallmentsMethod(FormaFinanciamento.A_VISTA),
          ),
        }
      ],
    );
  }
}


 */
 */
