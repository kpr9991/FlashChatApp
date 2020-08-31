import 'package:flash_chat/Components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const id="registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;//Okkasari runtime lo instance create cheste malli change cheyyamu ani cheppeki.
  String email;
  String password;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag:"logo",      //Hero widget tho wrap cheste just previously unna child ki animations vachchestayi new screen ki vachche tappudu.
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
                keyboardType: TextInputType.emailAddress,//eh type keyboard open cheyali ani.
                textAlign: TextAlign.center,
                onChanged: (value) {
                 email=value;    //TextField final value email lo store avuthundi.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your Email"),//Copy with method use chesi aa existing properties ni copy chesi yevi kavalante avi override cheyachchu.
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,//password **** la vachcheki.
                textAlign: TextAlign.center,
                onChanged: (value) {
                password=value; //TextField final value password variable lo store avuthundi.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your Password")
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(text: "Register",color: Colors.blueAccent,function:() async {
//              print(email);
//              print(password);
              setState(() {
                showSpinner=true;
              });
              try {
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password); //EE create user ane method returns a future and thus adhi output ichchenthavaraku we must not show the screen to the user,So i have used await.and async.
              if(newUser!=null)
                Navigator.pushNamed(context, LoginScreen.id,arguments:EmailPassword(email: email,password: password));//User register ayyina chat screen yeh open avvali and user login ayyina chat screen eh open avvali.
              }
              catch(e)//If suppose newuser create avvakapothe.
                {print(e);}
              setState(() {
                showSpinner=false;
              });
              },),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailPassword{
  String email;
  String password;
  EmailPassword({this.email,this.password});
}