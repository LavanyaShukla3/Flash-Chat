import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/RoundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final auth = FirebaseAuth.instance;
  String email='';
  String password='';

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase
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
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration: kInputDecoration.copyWith(hintText: 'Email'),
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
                child: roundedButton(color: Colors.lightBlueAccent, text: 'Log In',
                    onPressed:() async{
                  try{
                    setState(() {
                      showSpinner = true;
                    });
                  final user = await auth.signInWithEmailAndPassword(email: email, password: password);
                      if (user !=null){
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
