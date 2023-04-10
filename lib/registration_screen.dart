// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'constants.dart';
import 'components/welcome_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'regisration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  // late String email;
  // late String pass;
  // late String nick;
  bool showSpinner = false;
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
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 185.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              TextField(
                controller: email,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                decoration: khintStyle.copyWith(hintText: 'Enter Your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: password,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                obscureText: true,
                decoration:
                    khintStyle.copyWith(hintText: 'Enter Your Password'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? "Password should have at least 6 characters"
                    : null,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: username,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                decoration: khintStyle.copyWith(hintText: 'Enter Your Name'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 3
                    ? "Username has to least 3 words"
                    : null,
              ),
              SizedBox(
                height: 20.0,
              ),
              welcome_button(() async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  UserCredential result =
                      await _auth.createUserWithEmailAndPassword(
                          email: email.text, password: password.text);
                  User newUser = result.user!;
                  newUser.updateDisplayName(username.text);
                  showSpinner = false;
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => home()));
                  setState(() {});
                } on FirebaseAuthException catch (e) {
                  print(e);
                  setState(() {
                    showSpinner = false;
                  });
                  if (e.code == "email-already-in-use") {
                    showDialog(
                        context: context,
                        builder: (context) => error("Already Signed Up",
                            "The email address is already in use"));
                    email.text = "";
                    password.text = "";
                  }
                }
              }, Colors.blueAccent, 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}

class error extends StatelessWidget {
  String title;
  String vlaue;
  error(this.title, this.vlaue);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(vlaue),
      actions: <Widget>[
        TextButton(
          child: const Text('ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
