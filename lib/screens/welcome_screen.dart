import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; //First manual Animations add chesam ippudu Prepared package nundi animations use chestunnam.
import 'package:flash_chat/Components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() =>
      _WelcomeScreenState(); //Welcome screen ki object create chesina next second ee stateful wdiget object create avuthundi and then state class ki object create avuthundi.
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {                   //Ee "with" keyword add chesi ticker ni add cheyatam valla aa class ki inkonni additional capabilities ni add chesinattu,Now single ticker provider use chesindi since okkate Animation undi kabatti okavela multiple animations unte use TickerProvider ane class.But anyways inheritance lo parent properties vachchinattu ikkada addtional properties for the class vasthayi by adding with keyword.
  AnimationController   controller;              //Animations ki sambanchina content antha ee animationController chuskuntundi.
  Animation animation;
  @override
  void initState() {                             //state object create ayyina next second animation controller object create cheyali kabatti we are doing this in initstate.
    super.initState();
    controller = AnimationController(
//      upperBound: 1,
//      lowerBound: 0,                           // If we use curves then upper bound and lower bound must be zero and 1 respectively,only then the curves would work,So curves ki eh values ivvakapothe by default 0 and 1 tho initialize avuthay.
        vsync: this,                             //Animation controller ki vsync property required property so aa vsync property expects a ticker class object.Ticker ante nee Animation run avuthunna each and every unit of time ki state of object ni store cheskuneki.So ikkada aa ticker object ippudu ee animation controller unna state object eh.So aa state object yokka object ne vsync ki return value ga istunnam.
        duration: Duration(seconds:1)            //Duration of any  animation.
        );
    controller.forward();                       //Forward ante lowerbound nundi upper bound ki vellamani cheptunnam,controller.reverse ki ayithe from property compulsory,lekunte u cant notice the difference.
    animation=ColorTween(begin:Colors.blueGrey,end: Colors.white).animate(controller);//Idhi inbetween animations apply cheseki ante color bluegrey tho start ayi it will end with white.
    controller.addListener(() {
      //Yen jaruguthandi controller class lo ani teluskuneki we use listener class.
      setState(() {
        //Set state method lo em values ni ivvalsina avasaram ledu because already controller value change avuthune vundi,So just setstate use cheste widget antha malli rebuild avuthundi.
      });
      print(animation.value);//Indaka controller value use chesam ippudu danni animation value ni chestunnam because  aa controller ki ee animation ni apply chesam.
    });
/*    animation=CurvedAnimation(parent: controller,curve:Curves.decelerate);//Decelerate curve first starts out increasing faster and then starts to increasee slower.,Parent tag ante eh Animation Controller ki deenni apply chestunnav ani.
    animation.addStatusListener((status) {        //Animation status gurinchi telsukuneki listener.
      if(status==AnimationStatus.completed)//Ee code ni uncomment cheste logo loop lo animate avuthundi.
        controller.reverse(from:1);
      else if(status==AnimationStatus.dismissed)
        controller.forward();
    });*/
  }
  @override
  void dispose() {
    controller.dispose();                            //Animation controller ni dispose cheyakapothe adhi background lo run avuthu untundi and because of that App battery yekkuva use chesthundi,So ee screen off ayithe manam aa controller ni dispose cheyali.
    super.dispose();
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(  //Idhi okka ready made animated text animation,Ivi use cheyatam best.
                  speed: Duration(milliseconds: 500),
                  text: ["Flash Chat","Welcomes","Hello !","Flash Chat"],
                  totalRepeatCount: 1,
                  textStyle: TextStyle(fontSize:45,color:Colors.black,fontWeight: FontWeight.w900),

                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Colors.lightBlueAccent,text: "Log In",function:() {Navigator.pushNamed(context, LoginScreen.id);},),
            RoundedButton(color: Colors.blueAccent,text: "Register",function: (){Navigator.pushNamed(context, RegistrationScreen.id);},)
          ],
        ),
      ),
    );
  }
}

