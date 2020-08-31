import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
//Constants created inside the class must always be static because,static ante something the belongs to the class and class name
//use chesi we can access the static content so,static content ni access cheyali ante we need not use the object for the class,
//constant variable ni declare chesav ante it means that aa variable yokka value will be constant on the whole class,ante daani
//value ni change cheyama ani.Ala change cheyani values ni okavela nuuvu access cheyali anukunte y are you creating the
//object unnecessarily for that.Instead static ga chesi,class name use chesi access cheyachchu kadha aa object ni.So thus,
//class lo constants ni create cheste they must be static.
//Runtime lo vachche values modify avvakuudadhu ante use final.
//Compile time lo vachche values modify avvakuudadhu ante use const.But remember rendinti property midify cheyyalem once initialized.

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
                                                                       //Screens ki id lu iste aa screens ki names ni gurthu pettukune kante better aa screens unna classes lo oka static variable that denotes the screen id create cheste we can use it easily.
      initialRoute:WelcomeScreen.id,                                   //initial route and home rendu properties undakuudadhu.
      routes:{                                                         //id anedi static property kabtti i have used that id,without creating the object for the class welcome screen.
        ChatScreen.id:(context){return ChatScreen();},
        LoginScreen.id:(context){return LoginScreen();},
        RegistrationScreen.id:(context){return RegistrationScreen();},
        WelcomeScreen.id:(context){return WelcomeScreen();},
      } ,
    );
  }
}
