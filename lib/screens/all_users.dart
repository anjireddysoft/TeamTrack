/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_tracker/models/usermodel.dart';
import 'package:team_tracker/screens/user_task.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<UserModel> userList = [];

  getData() {
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot${snapshot.value}");

      var keys = snapshot.value.keys;
      print("keys${keys}");
      var values = snapshot.value;
      print("values${values}");
      for (String key in keys) {
        print("key $key");
        UserModel data = UserModel(
          userId: values[key]['userId'],
          name: values[key]['name'],
        );

        setState(() {
          userList.add(data);
        });
        print(userList[0].name);
        print(userList.length);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Users")),
      ),
      body:userList.isEmpty?Center(child: CircularProgressIndicator()): Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: userList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => UserTask(
                            userModel:userList[index]
                          )));
                },
                child: Card(
                  child: ListTile(
                    title: Text(userList[index].name),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
*/
