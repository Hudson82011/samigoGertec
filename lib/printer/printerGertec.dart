
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PrinterG {

  static const platform = const MethodChannel('samples.flutter.dev/gedi');

/*  int dropdownValueSize = 20;
  int dropdownBarHeight = 280;
  int dropdownBarWidth = 280;
  String dropdownFont = "DEFAULT";
  String dropdownBarType = "QR_CODE";
  String alinhar = "CENTER";
  String valorSelecionado = "CENTER";
  List<bool> listSelecionado = [false, false, false];*/


  void erroImpresao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext c) {
        return AlertDialog(
          title: Text("Escreva uma mensagem para ser impressa !"),
        );
      },
    );
  }

  // Função responsavel por finalizar impressao - ImpressoraOutput();
  void finalizarImpressao() async {
    await platform.invokeMethod('fimimpressao');
  }

  void impressaoDeTexto(
      {required String texto, required int fontSize, required String alinhar, required String fontFamily, required List<
          bool> selectedOptions, required BuildContext context}) async {
    texto = texto ?? ""; // Caso seja null
    if (texto.isEmpty) {
      erroImpresao(context);
    } else {
      try {
        await platform.invokeMethod(
          'imprimir',
          <String, dynamic>{
            "tipoImpressao": "Texto",
            "mensagem": texto,
            "alinhar": alinhar,
            "size": fontSize,
            "font": fontFamily,
            "options": selectedOptions // Negrito, Sublinhado e Italico
          },
        );
      } on PlatformException catch (e) {
        print(e.message);
      }
    }
  }

  Future<void> impressaoTodasFuncoes() async {
    try {
      await platform.invokeMethod(
        'imprimir',
        <String, dynamic>{
          "tipoImpressao": "TodasFuncoes",
        },
      );
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> impressaoDeImagem() async {
    try {
      await platform.invokeMethod('imprimir', <String, dynamic>{
        "tipoImpressao": "Imagem",
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> impressaoDeCodigoDeBarra(
      {required String texto, required int height, required int width, required String barCode, required BuildContext context}) async {
    texto = texto ?? ""; // Caso seja null
    if (texto.isNotEmpty) {
      try {
        await platform.invokeMethod('imprimir', <String, dynamic>{
          "tipoImpressao": "CodigoDeBarra",
          "height": height ?? 200,
          "width": width ?? 200,
          "barCode": barCode ?? "QR_CODE",
          "mensagem": texto
        });
      } on PlatformException catch (e) {
        print(e.message);
      }
    } else {
      erroImpresao(context);
    }
  }

  Future<String> checarImpressora() async {
    try {
      bool impressora = await platform.invokeMethod('checarImpressora');
      if (impressora == true)
        return "Ok";
      else
        return "Erro";
    } on PlatformException catch (e) {
      print(e.message);
    }
    return "Erro";
  }

  /*Future<void> impCupom(Uint8List cupom) async {
    try {
      await platform.invokeMethod('cupom', <String, dynamic>{
        "opcaoTef": cupom,
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }*/


}

 /* Future<String> impImgRaw(Uint8List imgBytes) async {




    try {
     await platform.invokeMethod('impImg',<String, dynamic>{
       "tipoImpressao": imgBytes
     });

    } on PlatformException catch (e) {
      print(e.message);
    }
    return "Erro";
  }

}*/