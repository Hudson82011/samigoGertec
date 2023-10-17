

import 'package:flutter/widgets.dart';

class ScreenSize{



 double getHeight(context){
   double _height=MediaQuery.of(context).size.height<1080?MediaQuery.of(context).size.height:1080;
    return _height;
  }

 double getWidth(context){
   double _height=MediaQuery.of(context).size.width<900?MediaQuery.of(context).size.width:700;
   return _height;
 }

}