import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchctrl = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  initialSearch() {
    databaseMethods.getUserByUsername(searchctrl.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        })) : Container();
  }

  createChatroomAndStartConv(String userName){
    if(userName != Constants.myName){
      List<String> users = [userName, Constants.myName];
      String chatRoomId =  getChatRoomId(userName, Constants.myName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };

      databaseMethods.createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId)));
    }else{
      print('You cannot send messagw to yourself');
    }
  }

  Widget SearchTile({String userName,String userEmail}){
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: midTextStyle(),
                ),
                SizedBox(height: 5,),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.white,
                      fontSize: 12),
                ),
              ]),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConv(userName);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text("Message",style: midTextStyle(),)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(children: [
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchctrl,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search username..",
                    hintStyle: TextStyle(
                      color: Colors.white54,
                    ),
                    border: InputBorder.none,
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    initialSearch();
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFF),
                        ]),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/images/search_white.png")),
                ),
              ],
            ),
          ),
          searchList(),
        ]),
      ),
    );
  }
}


getChatRoomId(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}