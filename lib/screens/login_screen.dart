import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const id ="LoginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth=FirebaseAuth.instance;
  EmailPassword passedArgs;
  String email="";
  String password="";
  bool showSpinner=false;
  TextEditingController controlleremail;        //Register screen nundi direct ga login screen loki vasthe login details pass ayyindevi must be shown in the text fields right,So avi chupincheki we use this.
  TextEditingController controllerpassword;


  void fillDetailsFromRegistrationScreen(context)
  {
    try {
      passedArgs = ModalRoute
          .of(context)
          .settings
          .arguments; //context argument ni access cheyali ante we have to use this inside build method lekunte context ni access cheyalem.
      email = passedArgs.email ?? "";
      password = passedArgs.password ?? "";
      controlleremail = TextEditingController(text: email);
      controllerpassword = TextEditingController(text: password);
    }
    catch(e){
      print("User Has directly Entered from LoginScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
   fillDetailsFromRegistrationScreen(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,                               //Asyncronous call lo spinner ni chupinchala vadhdha ane property inAsynccall
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(                   //logo size 200 kabatti konni screens lo logo pattakapothe , akkada available spacce ni batti ee logo widget height resize avvali ani cheppeki we use flexible widget.
                child: Hero(
                  tag:"logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: controlleremail,
                keyboardType: TextInputType.emailAddress,//eh type keyboard open cheyali ani.
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: controllerpassword,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText:"Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(text: "Log In",color: Colors.blueAccent,function: ()async {
                try {
                  setState(() {          //User action ni batti UI lo change kavali ante use setstate or else spinner kanipinchadhu.
                    showSpinner=true;
                  });
                  final signIn = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (signIn != null)
                    Navigator.pushNamed(context, ChatScreen.id);
                  setState(() {
                    showSpinner=false;               //Okavela signin ayipothey chat screen open avuthundi but background lo inka spinner run avuthuune vuntundi.So that needs to be stopped,And thus koththa screen push ayina kaani ee function background lo full ga run avuthundi.
                  });
              }
              catch(e)
                {
                  print("Unable to login Because: $e");
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}
