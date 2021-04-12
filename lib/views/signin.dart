import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatroomScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController email = new TextEditingController();

  TextEditingController pass = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot userInfoSnapshot;
  AuthMethods authMethods = new AuthMethods();

  signMeIn() {
    if (formKey.currentState.validate()) {
      HelperFunction.saveUserEmailSharedPreference(email.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(email.text).then((val){
        userInfoSnapshot = val;
        HelperFunction.saveUsernameSharedPreference(userInfoSnapshot.documents[0].data["name"]);
      });
      authMethods.signInWithEmailAndPass(email.text, pass.text).then((val){
        if(val != null){
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
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) : SingleChildScrollView(
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
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Text('Forgot Password?',style: simpleTextStyle(),),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: (){
                    signMeIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text('Sign In',style: midTextStyle()),
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
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text('Sign In with Google',style:TextStyle(
                    color: Colors.black,
                    fontSize: 18,),),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? ",style: midTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Register now',style:TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),),
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
