import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'chatroomScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();

  TextEditingController userName, email, pass;

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    userName = new TextEditingController();
    email = new TextEditingController();
    pass = new TextEditingController();
    super.initState();
  }

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name" : userName.text,
        "email": email.text,
      };

       HelperFunction.saveUserEmailSharedPreference(email.text);
       HelperFunction.saveUsernameSharedPreference(userName.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPass(email.text, pass.text).then((val) {
        if(val != null){
          databaseMethods.UploadUserInfo(userInfoMap);

          HelperFunction.saveUserLoggedInSharedPreference(true);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> ChatRoom()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 50,
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return val.isEmpty || val.length < 4
                                  ? "Please provide username"
                                  : null;
                            },
                            controller: userName,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration('Username'),
                          ),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Enter correct email";
                            },
                            controller: email,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration('Email'),
                          ),
                          TextFormField(
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : 'Please provide password 6+ character';
                            },
                            obscureText: true,
                            controller: pass,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration('Password'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Forgot Password?',
                          style: simpleTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        signMeUp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text('Sign Up', style: midTextStyle()),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child:
                          Text('Sign In with Google', style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,),),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: midTextStyle(),
                        ),
                        GestureDetector(
                          onTap: (){
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Sign In now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
