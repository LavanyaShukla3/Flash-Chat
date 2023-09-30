import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/Components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'Registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {


  final auth= FirebaseAuth.instance;
  bool showSpinner = false;
  String email='';
  String password='';

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }
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
                  tag: 'flash',
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
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                  textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration:kInputDecoration.copyWith(hintText: 'Enter Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: roundedButton(color: Colors.cyan, text: 'Register',
                    onPressed:()async{
                  setState(() {
                    showSpinner = true;
                  });
                  try{
                    final newUser = await auth.createUserWithEmailAndPassword(email: email, password: password);
                    if (newUser !=null){
                      Navigator.pushNamed(context, ChatScreen.id);

                    }
                    setState(() {
                      showSpinner = false;
                    });
                  }
                  catch(e){
                    print(e);
                  }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
