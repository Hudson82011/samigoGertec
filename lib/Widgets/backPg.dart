
import 'package:flutter/material.dart';

Widget backPg(context){
  return BottomAppBar(
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
                onTap: (){
                  Navigator.pop(context);
                }
                ,child: Container(
                width: 82,
                height: 70,
                color: Color.fromRGBO(219,166,86,1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("imagens/voltar.png",scale: 3),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text("VOLTAR",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),)
                  ],
                ),
              ),
              ),
            ],
          ),
        ],
      )
  );


}