import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_tracker/models/task_model.dart';
import 'package:team_tracker/screens/add_task_screen.dart';
import 'package:team_tracker/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  String userId;

  HomeScreen({Key key, this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController taskController = TextEditingController();
  List<TaskModel> taskList = [];

  getData() {
    print("userId${widget.userId}");
    FirebaseDatabase.instance
        .reference()
        .child('Tasks')
        .child(widget.userId)
        .onValue
        .listen((event) {
      print("snapshot${event.snapshot.value}");

      var keys = event.snapshot.value.keys;
      print("keys${keys}");
      var values = event.snapshot.value;
      print("values${values}");
      taskList.clear();
      for (String key in keys) {
        print("key $key");
        print("LogInTime${values[key]['logInTime']}");
        TaskModel data = TaskModel(
            date: values[key]['date'],
            logInTime: values[key]['logInTime'],
            logOutTime: values[key]['logOutTime'],
            task: values[key]['tasks']);

        setState(() {
          //
          print("date is${data.date}");
          print("DateFormat${DateFormat('dd-MM-yyyy').format(DateTime.now())}");
          if (data.date == DateFormat('dd-MM-yyyy').format(DateTime.now())) {

          //  taskList.clear();
            taskList.add(data);
            taskList.sort((a, b) {
              var adate = a.date; //before -> var adate = a.date;
              var bdate = b.date; //before -> var bdate = b.date;
              return bdate.compareTo(
                  adate); //to get the order other way just switch `adate & bdate`
            });
          } else {
            taskList.add(data);
            taskList.sort((a, b) {
              var adate = a.date; //before -> var adate = a.date;
              var bdate = b.date; //before -> var bdate = b.date;
              return bdate.compareTo(
                  adate); //to get the order other way just switch `adate & bdate`
            });
          }
        });
        print(taskList[0].date);
        print(taskList.length);
      }
    });
  }

  logOut() async {
    print("logInValue");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isLogIn", false);
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.60,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              margin: EdgeInsets.only(top: 50),
              color: Colors.blue,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                    "https://s28164.pcdn.co/files/Malayan-Tiger-0155-2199.jpg"),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  firebaseAuth.signOut().then((value) {
                    logOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LogInScreen()));
                  });
                },
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("LogOut"),
                ))
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
        actions: [
          /* GestureDetector(
              onTap: () {
                firebaseAuth.signOut().then((value) {
                  logOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LogInScreen()));
                });
              },
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "LogOut",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ))),*/
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddTaskScreen(
                              userId: widget.userId,
                            )));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            //  reverse: true,
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                // print("tasklength${taskList[index].task.length}");
                return Container(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date : ${taskList[index].date}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(

                                " ${taskList[index].logInTime}-${taskList[index].logOutTime}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: taskList[index].task.length,
                                itemBuilder: (context, ind) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.arrow_forward),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${taskList[index].task[ind]}")),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
