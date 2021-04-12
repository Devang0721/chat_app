import 'package:chat_app/views/chatroomScreen.dart';
import 'package:flutter/material.dart';
import 'helper/authenticate.dart';
import 'helper/helperfunction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool status = false;

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  getStatus()async{
    await HelperFunction.getUserLoggedInSharedPreference().then((val){
      setState(() {
        status = val;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Flutter Chat App',
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
      ),
      home: status != null ?  status ? ChatRoom() : Authenticate(): Authenticate(),
    );
  }
}

