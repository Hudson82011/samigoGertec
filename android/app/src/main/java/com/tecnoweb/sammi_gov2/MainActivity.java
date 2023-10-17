package com.tecnoweb.sammi_gov2;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;
import android.view.KeyEvent;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import com.tecnoweb.sammi_gov2.TefEnums.Acao;
import com.tecnoweb.sammi_gov2.TefEnums.FormaFinanciamento;
import com.tecnoweb.sammi_gov2.TefEnums.FormaPagamento;
import com.tecnoweb.sammi_gov2.TefEnums.TEF;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.Set;

import br.com.gertec.gedi.exceptions.GediException;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.*;


public class MainActivity extends FlutterActivity {
   /// private MethodChannel.Result _result;

    Bundle bundle = new Bundle();

    private GertecPrinter gertecPrinter;
    private ConfigPrint configPrint = new ConfigPrint();

    public static String Model = Build.MODEL;
    public static final String G700 = "GPOS700";

    Intent intentToMsitef = new Intent("br.com.softwareexpress.sitef.msitef.ACTIVITY_CLISITEF");


    String barcode="";


    public static MethodChannel.Result resultFlutter;

    //ServiceSat serviceSat;
    Activity activity;
    MethodChannel methodChannel;
    public static Context mContext;
    private IntentIntegrator qrScan;


    private static final String CHANNEL = "samples.flutter.dev/gedi";

    public String getSelectedPaymentCode(FormaPagamento formaPagamentoSelecionada) {
        switch (formaPagamentoSelecionada) {
            case CREDITO:
                return "3";
            case DEBITO:
                return "2";
            default: //case "Todos"
                return "0";
        }
    }

    private void startActionTEF(TEF tefSelecionado, Acao acaoSelecionada, Map<String, Object> params) {
        switch (tefSelecionado) {
           /*case PAY_GO:
                runPayGo(acaoSelecionada, params);
                break;*/
            case M_SITEF:
                runMsitef(acaoSelecionada, params);
                break;
        }
    }


    public void runMsitef(Acao acaoSelecionada, Map<String, Object> params) {
        //Parâmetros de configuração do M-Sitef.

        final String empresaSitef=(String) params.get("empresaSitef");
        intentToMsitef.putExtra("empresaSitef", empresaSitef);

        final String enderecoSitef = (String) params.get("enderecoSitef");
        final String operador = (String) params.get("operador");
        final String data = (String) params.get("data");
        final String hora = (String) params.get("hora");
        final String numeroCupom = (String) params.get("numeroCupom");
        final String CNPJ_CPF = (String) params.get("CNPJ_CPF");
        final String comExterna = (String) params.get("comExterna");
        final String pinpadMac = (String) params.get("pinpadMac");
        final String chaveExterna=(String) params.get("chaveExterna");


        assert enderecoSitef != null;
        intentToMsitef.putExtra("enderecoSitef", enderecoSitef);
        intentToMsitef.putExtra("operador", operador);
        intentToMsitef.putExtra("data", data);
        intentToMsitef.putExtra("hora", hora);
        intentToMsitef.putExtra("numeroCupom", numeroCupom);
                //String.valueOf(new Random().nextInt(99999)));

        final String valor = (String) params.get("valor");

        assert valor != null;
        intentToMsitef.putExtra("valor", valor);

        intentToMsitef.putExtra("CNPJ_CPF", CNPJ_CPF);
        intentToMsitef.putExtra("comExterna", comExterna);
       // intentToMsitef.putExtra("chaveExterna", chaveExterna);
        intentToMsitef.putExtra("pinpadMac", pinpadMac);

        switch (acaoSelecionada) {
            case VENDA:
                final FormaPagamento formaPagamentoSelecionada = FormaPagamento.fromRotulo((String) params.get("formaPagamento"));

                intentToMsitef.putExtra("modalidade", getSelectedPaymentCode(formaPagamentoSelecionada));

                switch (formaPagamentoSelecionada) {
                    case CREDITO:

                        final String numParcelas = (String) params.get("numParcelas");

                        assert numParcelas != null;
                        intentToMsitef.putExtra("numParcelas", numParcelas);

                        final FormaFinanciamento formaFinanciamentoSelecionada = FormaFinanciamento.fromRotulo((String) params.get("formaFinanciamento"));
                        switch (formaFinanciamentoSelecionada) {
                            case A_VISTA:
                                intentToMsitef.putExtra("transacoesHabilitadas", "26");
                                break;
                            case LOJA:
                                intentToMsitef.putExtra("transacoesHabilitadas", "27");
                                break;
                            case ADM:
                                intentToMsitef.putExtra("transacoesHabilitadas", "28");
                                break;
                        }
                        break;
                    case DEBITO:
                        intentToMsitef.putExtra("transacoesHabilitadas", "16");
                        intentToMsitef.putExtra("numParcelas", "");
                        break;
                }
                break;
            case CANCELAMENTO:
                intentToMsitef.putExtra("modalidade", "200");
                intentToMsitef.putExtra("transacoesHabilitadas", "");
                intentToMsitef.putExtra("isDoubleValidation", "0");
                intentToMsitef.putExtra("restricoes", "");
                intentToMsitef.putExtra("caminhoCertificadoCA", "ca_cert_perm");
                break;
            case CONFIGURACAO:
                intentToMsitef.putExtra("modalidade", "110");
                intentToMsitef.putExtra("isDoubleValidation", "0");
                intentToMsitef.putExtra("restricoes", "");
                intentToMsitef.putExtra("transacoesHabilitadas", "");
                intentToMsitef.putExtra("caminhoCertificadoCA", "ca_cert_perm");
                intentToMsitef.putExtra("restricoes", "transacoesHabilitadas=16;26;27");
                break;
        }
        startActivityForResult(intentToMsitef, 4321);
    }




    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        gertecPrinter.setConfigImpressao(configPrint);
    }

    @Override
    protected void onResume() {
        super.onResume();
        gertecPrinter = new GertecPrinter(this,getApplicationContext());
    }

    @Override





    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);


        activity = this;
        mContext = this;




        BinaryMessenger binaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        methodChannel = new MethodChannel(binaryMessenger, CHANNEL);



        methodChannel.setMethodCallHandler((call, result) -> {
            bundle = new Bundle();
            resultFlutter = result;
            Intent intent = null;


            if (call.method.equals("TEF")) {

                Map<String, Object> params;
                params = call.argument("args");

                TEF tefSelecionado = TEF.fromRotulo((String) params.get("opcaoTef"));

                //Captura o tipo de Acao a ser realizada.
                Acao acaoSelecionada = Acao.fromRotulo((String) params.get("acaoTef"));

                Log.d("AQUI", params.toString());

                //Repassa os parâmetros para o filtro do tipo de tef / acao;
                startActionTEF(tefSelecionado, acaoSelecionada, params);

               /* Map<String, String> map;
               map = call.argument("mapMsiTef");
                for (String key : map.keySet()) {
                    bundle.putString(key, map.get(key));
                }


                intentToElginTef.putExtras(bundle);
                startActivityForResult(intentToElginTef, 1234);*/

            } else if (call.method.equals("fimimpressao")){
                try {
                    gertecPrinter.ImpressoraOutput();
                    resultFlutter.success("Finalizou impressao");
                } catch (GediException e) {
                    e.printStackTrace();
                    throw new RuntimeException(e);
                }

        }else if (call.method.equals( "avancaLinha")){
                try {
                    gertecPrinter.avancaLinha(call.argument("quantLinhas"));
                } catch (GediException e) {
                    e.printStackTrace();
                }
            }
            else if (call.method.equals("imprimir")){
                try {
                    gertecPrinter.getStatusImpressora();
                    if (gertecPrinter.isImpressoraOK()) {
                        String tipoImpressao = call.argument("tipoImpressao");
                        String mensagem = call.argument("mensagem");
                        switch (tipoImpressao) {
                            case "Texto":
                                List<Boolean> options = call.argument("options");
                                configPrint.setItalico(options.get(1));
                                configPrint.setSublinhado(options.get(2));
                                System.out.println(call.argument("size").toString());
                                configPrint.setNegrito(options.get(0));
                                System.out.println(call.argument("font").toString());
                                configPrint.setTamanho(call.argument("size"));
                                configPrint.setFonte(call.argument("font"));
                                configPrint.setAlinhamento(call.argument("alinhar"));
                                gertecPrinter.setConfigImpressao(configPrint);
                                gertecPrinter.imprimeTexto(mensagem);
                                break;
                            case "Imagem":
                                configPrint.setiWidth(400);
                                configPrint.setiHeight(400);
                                gertecPrinter.setConfigImpressao(configPrint);
                                gertecPrinter.imprimeImagem("logogertec");
                                break;
                            case "CodigoDeBarra":
                                configPrint.setAlinhamento("CENTER");
                                gertecPrinter.setConfigImpressao(configPrint);
                                gertecPrinter.imprimeBarCodeIMG(mensagem, call.argument("height"),
                                        call.argument("width"), call.argument("barCode"));
                                break;
                            case "TodasFuncoes":
                                ImprimeTodasAsFucoes();
                                break;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

        }else if(call.method.equals("cupom")){


                //System.out.println((char[]) call.argument("opcaoTef"));

                byte[] nota = call.argument("opcaoTef");


                configPrint.setiWidth(400);
                configPrint.setiHeight(400);
                gertecPrinter.setConfigImpressao(configPrint);
                try {
                    gertecPrinter.imprimeCupom(nota);
                } catch (GediException e) {
                    throw new RuntimeException(e);
                }
            }else if(call.method.equals("leitorCodigoV2")){
                intent = new Intent(this, CodigoBarrasV2.class);
                startActivityForResult(intent,5566);

            }

        });
    }


    private void ImprimeTodasAsFucoes() {
        configPrint.setItalico(false);
        configPrint.setNegrito(true);
        configPrint.setTamanho(20);
        configPrint.setFonte("MONOSPACE");
        gertecPrinter.setConfigImpressao(configPrint);
        try {
            gertecPrinter.getStatusImpressora();
            // Imprimindo Imagem
            configPrint.setiWidth(300);
            configPrint.setiHeight(130);
            configPrint.setAlinhamento("CENTER");
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("==[Iniciando Impressao Imagem]==");
            gertecPrinter.imprimeImagem("logogertec");
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeTexto("====[Fim Impressão Imagem]====");
            gertecPrinter.avancaLinha(10);
            // Fim Imagem

            // Impressão Centralizada
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(30);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("CENTRALIZADO");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Centralizada

            // Impressão Esquerda
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(40);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("ESQUERDA");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Esquerda

            // Impressão Direita
            configPrint.setAlinhamento("RIGHT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("DIREITA");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Direita

            // Impressão Negrito
            configPrint.setNegrito(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=======[Escrita Netrigo]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Negrito

            // Impressão Italico
            configPrint.setNegrito(false);
            configPrint.setItalico(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=======[Escrita Italico]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Italico

            // Impressão Italico
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("======[Escrita Sublinhado]=====");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Italico

            // Impressão BarCode 128
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(false);
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("====[Codigo Barras CODE 128]====");
            gertecPrinter.imprimeBarCode("12345678901234567890", 120, 120, "CODE_128");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão BarCode 128

            // Impressão Normal
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=======[Escrita Normal]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Normal

            // Impressão Normal
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=========[BlankLine 50]=========");
            gertecPrinter.avancaLinha(50);
            gertecPrinter.imprimeTexto("=======[Fim BlankLine 50]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Normal

            // Impressão BarCode 13
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(false);
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=====[Codigo Barras EAN13]=====");
            gertecPrinter.imprimeBarCode("7891234567895", 120, 120, "EAN_13");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão BarCode 128

            // Impressão BarCode 13
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("===[Codigo QrCode Gertec LIB]==");
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeBarCode("Gertec Developer Partner LIB", 240, 240, "QR_CODE");

            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(false);
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(20);
            gertecPrinter.imprimeTexto("===[Codigo QrCode Gertec IMG]==");
            gertecPrinter.imprimeBarCodeIMG("Gertec Developer Partner IMG", 240, 240, "QR_CODE");

            gertecPrinter.avancaLinha(40);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    @Override
    protected void onDestroy() {
        super.onDestroy();

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        //Os TEFs MSitef e TEF Elgin possuem o mesmo retorno.
        if (requestCode == 4321 || requestCode == 1234) {



            //Se resultCode da intent for OK então a transação obteve sucesso.
            //Caso o resultCode da intent for de atividade cancelada e a data estiver diferente de nulo, é possível obter um retorno também.
            if (resultCode == RESULT_OK || (resultCode == RESULT_CANCELED && data != null)) {

                //O campos são os mesmos para ambos os TEFs.
                final String COD_AUTORIZACAO = data.getStringExtra("COD_AUTORIZACAO");
                final String VIA_ESTABELECIMENTO = data.getStringExtra("VIA_ESTABELECIMENTO");
                final String COMP_DADOS_CONF = data.getStringExtra("COMP_DADOS_CONF");
                final String BANDEIRA = data.getStringExtra("BANDEIRA");
                final String NUM_PARC = data.getStringExtra("NUM_PARC");
                final String RELATORIO_TRANS = data.getStringExtra("RELATORIO_TRANS");
                final String REDE_AUT = data.getStringExtra("REDE_AUT");
                final String NSU_SITEF = data.getStringExtra("NSU_SITEF");
                final String VIA_CLIENTE = data.getStringExtra("VIA_CLIENTE");
                final String TIPO_PARC = data.getStringExtra("TIPO_PARC");
                final String CODRESP = data.getStringExtra("CODRESP");
                final String NSU_HOST = data.getStringExtra("NSU_HOST");
                final String TIPO_CAMPOS = data.getStringExtra("TIPO_CAMPOS");

                Log.d("MADARA", COD_AUTORIZACAO +" " + VIA_ESTABELECIMENTO +" " + VIA_CLIENTE + " " + NSU_HOST);

                //Se o código de resposta estiver nulo ou tiver valor inteiro inferior a 0, a transação não ocorreu como esperado.
                if (CODRESP == null || Integer.parseInt(CODRESP) < 0) {
                    resultFlutter.success("transaction_error");
                } else {

                    //Cria o JSON com todos os retornos, insere todos os campos e envia de volta ao Flutter em String.
                    JSONObject returnJsonObject = new JSONObject();

                    try {
                        returnJsonObject.put("COD_AUTORIZACAO", COD_AUTORIZACAO);
                        returnJsonObject.put("VIA_ESTABELECIMENTO", VIA_ESTABELECIMENTO);
                        returnJsonObject.put("COMP_DADOS_CONF", COMP_DADOS_CONF);
                        returnJsonObject.put("BANDEIRA", BANDEIRA);
                        returnJsonObject.put("NUM_PARC", NUM_PARC);
                        returnJsonObject.put("RELATORIO_TRANS", RELATORIO_TRANS);
                        returnJsonObject.put("REDE_AUT", REDE_AUT);
                        returnJsonObject.put("NSU_SITEF", NSU_SITEF);
                        returnJsonObject.put("VIA_CLIENTE", VIA_CLIENTE);
                        returnJsonObject.put("TIPO_PARC", TIPO_PARC);
                        returnJsonObject.put("CODRESP", CODRESP);
                        returnJsonObject.put("NSU_HOST", NSU_HOST);
                        returnJsonObject.put("TIPO_CAMPOS",TIPO_CAMPOS);

                        resultFlutter.success(returnJsonObject.toString());
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

//        if (requestCode == 4321) {
//            if (resultCode == RESULT_OK || resultCode == RESULT_CANCELED && data != null) {
//                resultFlutter.success(bundleToJson(data));
//            } else {
//                resultFlutter.notImplemented();
//            }
//        }
        if (requestCode == 3) {
            if (data.getStringExtra("retorno").equals("0")) {
                if (data.getStringExtra("erro") != null) {
                    resultFlutter.success(data.getStringExtra("erro"));
                } else {
                    System.out.println("RETORNO: " + data.getStringExtra("mensagem"));
                    resultFlutter.success("ERRO");
                }
            } else {
                resultFlutter.success(data.getStringExtra("mensagem"));
            }
        }
        if (requestCode == 5566) {
            if (resultCode == RESULT_OK) {
                String returnedResult = data.getData().toString();

                System.out.println("retorno recebido");
                System.out.println(returnedResult);
                resultFlutter.success(returnedResult);
                // OR
                // String returnedResult = data.getDataString();
            }
        }


    }

  /*  @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        //Os TEFs MSitef e TEF Elgin possuem o mesmo retorno.
        if (requestCode == 4321 || requestCode == 1234) {



            //Se resultCode da intent for OK então a transação obteve sucesso.
            //Caso o resultCode da intent for de atividade cancelada e a data estiver diferente de nulo, é possível obter um retorno também.
            if (resultCode == RESULT_OK || (resultCode == RESULT_CANCELED && data != null)) {

                //O campos são os mesmos para ambos os TEFs.
                final String COD_AUTORIZACAO = data.getStringExtra("COD_AUTORIZACAO");
                final String VIA_ESTABELECIMENTO = data.getStringExtra("VIA_ESTABELECIMENTO");
                final String COMP_DADOS_CONF = data.getStringExtra("COMP_DADOS_CONF");
                final String BANDEIRA = data.getStringExtra("BANDEIRA");
                final String NUM_PARC = data.getStringExtra("NUM_PARC");
                final String RELATORIO_TRANS = data.getStringExtra("RELATORIO_TRANS");
                final String REDE_AUT = data.getStringExtra("REDE_AUT");
                final String NSU_SITEF = data.getStringExtra("NSU_SITEF");
                final String VIA_CLIENTE = data.getStringExtra("VIA_CLIENTE");
                final String TIPO_PARC = data.getStringExtra("TIPO_PARC");
                final String CODRESP = data.getStringExtra("CODRESP");
                final String NSU_HOST = data.getStringExtra("NSU_HOST");

                Log.d("MADARA", COD_AUTORIZACAO +" " + VIA_ESTABELECIMENTO +" " + VIA_CLIENTE + " " + NSU_HOST);

                //Se o código de resposta estiver nulo ou tiver valor inteiro inferior a 0, a transação não ocorreu como esperado.
                if (CODRESP == null || Integer.parseInt(CODRESP) < 0) {
                    _result.success("transaction_error");
                } else {

                    //Cria o JSON com todos os retornos, insere todos os campos e envia de volta ao Flutter em String.
                    JSONObject returnJsonObject = new JSONObject();

                    try {
                        returnJsonObject.put("COD_AUTORIZACAO", COD_AUTORIZACAO);
                        returnJsonObject.put("VIA_ESTABELECIMENTO", VIA_ESTABELECIMENTO);
                        returnJsonObject.put("COMP_DADOS_CONF", COMP_DADOS_CONF);
                        returnJsonObject.put("BANDEIRA", BANDEIRA);
                        returnJsonObject.put("NUM_PARC", NUM_PARC);
                        returnJsonObject.put("RELATORIO_TRANS", RELATORIO_TRANS);
                        returnJsonObject.put("REDE_AUT", REDE_AUT);
                        returnJsonObject.put("NSU_SITEF", NSU_SITEF);
                        returnJsonObject.put("VIA_CLIENTE", VIA_CLIENTE);
                        returnJsonObject.put("TIPO_PARC", TIPO_PARC);
                        returnJsonObject.put("CODRESP", CODRESP);
                        returnJsonObject.put("NSU_HOST", NSU_HOST);

                        _result.success(returnJsonObject.toString());
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

//        if (requestCode == 4321) {
//            if (resultCode == RESULT_OK || resultCode == RESULT_CANCELED && data != null) {
//                resultFlutter.success(bundleToJson(data));
//            } else {
//                resultFlutter.notImplemented();
//            }
//        }
        if (requestCode == 3) {
            if (data.getStringExtra("retorno").equals("0")) {
                if (data.getStringExtra("erro") != null) {
                    _result.success(data.getStringExtra("erro"));
                } else {
                    System.out.println("RETORNO: " + data.getStringExtra("mensagem"));
                    _result.success("ERRO");
                }
            } else {
                _result.success(data.getStringExtra("mensagem"));
            }
        }
    }



*/











  /*  @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        // Pega os resultados obtidos dos intent e envia para o flutter
        // ("_result.success")

        if (requestCode == 109) {
            if (resultCode == RESULT_OK && data != null) {
                _result.success(data.getStringExtra("codigoNFCID"));
            } else {
                _result.notImplemented();
            }
        } else if (requestCode == 108) {
            if (resultCode == RESULT_OK && data != null) {
                _result.success(data.getStringExtra("codigoNFCGEDI"));
            } else {
                _result.notImplemented();
            }
        } else if (requestCode == 4713) {
            if (resultCode == RESULT_OK && data != null) {
                _result.success(data.getStringExtra("jsonResp"));
            } else {
                _result.notImplemented();
            }
        } else if (requestCode == 4321) {
            if (resultCode == RESULT_OK || resultCode == RESULT_CANCELED && data != null) {
                try {
                    _result.success(respSitefToJson(data));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else {
                _result.notImplemented();
            }
        } else {
            IntentResult intentResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
            if (intentResult != null) {
                if (intentResult.getContents() == null) {
                    resultado_Leitor = (this.tipo + ": Não foi possível ler o código.\n");
                } else {
                    try {
                        resultado_Leitor = this.tipo + ": " + intentResult.getContents() + "\n";
                    } catch (Exception e) {
                        e.printStackTrace();
                        resultado_Leitor = this.tipo + ": Erro " + e.getMessage() + "\n";
                    }
                }
            } else {
                super.onActivityResult(requestCode, resultCode, data);
                resultado_Leitor = this.tipo + ": Não foi possível fazer a leitura.\n";
            }
            _result.success(resultado_Leitor);
            this.arrayListTipo.clear();
        }
    }*/


}
