import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id='ChatScreen';//constants value change cheyannu annappudu just make them as static yendukanta aa variables ni access cheyali ante no need to create object all the time if the variables are static.
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _firestore=Firestore.instance;
  final _auth=FirebaseAuth.instance;             //Ee instance inka change avvakuudadhu ani final chesam and deeni value runtime lo set avuthundi kabatti we used final.
                      //Fire base user ane class eh undi.
  String messageText;

  @override
  void initState() {
    getCurrentUser();              //Chat screen create avvagane yevaru logged in oo teluskovali kadha so init state lo pettanu.
  }

  void getCurrentUser () async { //Current user ni teluskune method kuuda Future object ne isthundi kabatti we keep await there.
    try {
      final user = await _auth.currentUser(); //Registration screen lo register ayyi login ayye tappudu registration screen lo create ayyina _auth object yeh ikkadiki pass avuthundi and then aa object current logged in user ni return chesthundi.
      if (user != null)
        loggedInUser = user;
        }
    catch (e) {
      print(e);
    }
  }

/*  void getMessagesstream() async
  {
      await for(var messages in _firestore.collection("messages").snapshots()){
          for(var message in messages.documents)
            print(message.data);
        }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
         MaterialButton(onPressed:(){
           _auth.signOut();
           Navigator.pop(context);       //Signout ayyina tarvaatha previous screen ki either loginscreen or register screen ki return avvali.
         },
           child: Text("LOG OUT",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500),),
         color: Colors.white,),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
             MessagesStream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear(); //Message send cheyagane aa box empty ayipovali kadha.
                      _firestore.collection("messages").add({   //Note that collections and names yokka strings firebase database lo yela ichchavo alane vundali,Or else yedho error vasthundi.
                        "sender":loggedInUser.email,
                        "text":messageText,
                      });
                    },
                    child:Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key key,
    @required Firestore firestore,
  }) : _firestore = firestore, super(key: key);

  final Firestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(                                          //Ante stream of data ni chadivetappudu stream lo extra data ni add cheste,aa extra data widget build ayi adhi screen lo kanipisthundi,So manam seperate ga setstate use chesi rebuild chese avasaram ledu,Set state use chesi.
      stream:_firestore.collection("messages").snapshots(), //When new data comes stream builder rebuilds.
    builder:(context,snapshot){                 //EE snapshot flutter dhi.Paina indaka function ki use chesina snapshot firebase dhi.
           if(!snapshot.hasData) {
             return Center(child: CircularProgressIndicator(backgroundColor: Colors.lightBlueAccent,),);//Snapshot  ki okavela data lekunda null data vunte just progress indicator ni chupistunnam.
           }
             final messages=snapshot.data.documents.reversed; //snapshot anedi flutter asynchronous snapshot,andulo firebase nundi querysnapshot ni access cheyataniki we use data method and querysnapshot lo unna documents list ni final ga retrieve chestunnam.
             List<MessageBubble> messageBubbles=[];        //Ikkada reversed pettam and list view lo reverse pettam,List view lo reversed valla Text widgets last lo add avutahyi list view lo and documents.reversed valla read chese documents last nundi read chestam kabatti latest message kanapadthundi.
             for(var message in messages)       //Remember prathi saari koththa message add ayithe firebase lo appudu aa chat antha inkosari rebuild avuthundi.So whatsapp lo laaga current eh message vaste adhe update avvadu,Mottham list view antha rebuild avuthundi.
               {
                 final messageText=message.data['text'];    //Data ane property lo ee case lo we have 2 fields ,avi  text and sender.So indaka paina use chesina snapshot.data and ikkada use chesina message.data different different data ni acceess chestunnayi.
                 final messageSender=message.data['sender'];  //message data ikkada oka map of strings and values so ,Map ni refer cheyali ante we have to use the key right so key ikkada aa string.
               final currentUser=loggedInUser.email;
                 final messageBubble=MessageBubble(sender: messageSender,text: messageText,isMe:currentUser==messageSender,);//Current logged in user and message sender rendu emails same ayithe logges in user eh message pampinchadu ani so color blue ayithundi lekunte color white ga untundi which indicates that vere user message sender vere vaadu ani.
                 messageBubbles.add(messageBubble);
               }
           return Expanded(
             child: ListView(   //List view ni expanded lo pettakunte list view total space ni teseskuntadhi inka messages kanapadavu.
             reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
               children:messageBubbles,
             ),
           );
    },
    );
  }
}


//Is me anna okka variable use chesi chaala editz cheyachchu.Isme ante logged in user and message sender nuvve aynappdu adhi true avuthundi.


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.text,this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {  //Material widget ga change cheyatam valla we can add some more properties for it like color etc.
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,style: TextStyle(color: Colors.black54,
              fontSize: 12),),
          Material(
            borderRadius: BorderRadius.only(topLeft:isMe?Radius.circular(30.0):Radius.circular(0),
            topRight: isMe?Radius.circular(0):Radius.circular(30.0),
            bottomLeft:Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
            elevation: 5.0,                              //Shadow isthundi widget ki.
            color: isMe?Colors.lightBlueAccent:Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
                child: Text(text,
                  style: TextStyle(fontSize:15,color: isMe?Colors.white70:Colors.black),
                ),
              )),
        ],
      ),
    );
  }
}

