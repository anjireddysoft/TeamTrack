import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_tracker/models/task_model.dart';
import 'package:team_tracker/screens/home_screen.dart';

class AddTaskScreen extends StatefulWidget {
  User user;
  String userId;

  AddTaskScreen({Key key, this.userId}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController logInTimeController = TextEditingController();
  TextEditingController logOutTimeController = TextEditingController();
  List<String> taskList = [];
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  List taskData = [];
  bool isKeysNull = true;
  bool updated = false;

  @override
  void initState() {
    String currentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    print('$currentDate');
    // TODO: implement initState
    dateController.text = currentDate.toString();
    super.initState();
  }

  String logInTime = '00:00';
  String logOutTime = "00:00";

  getData() {
    FirebaseDatabase.instance
        .reference()
        .child('Tasks')
        .child(widget.userId)
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot${snapshot.value}");
      if (snapshot.value != null) {
        print("=========================================");
        var keys = snapshot.value.keys;
        print("keys${keys}");
        var values = snapshot.value;
        print("values${values}");
        for (String key in keys) {
          print("key $key");
          if (values[key]['date'].toString() ==
              DateFormat('dd-MM-yyyy').format(DateTime.now())) {
            print("taskValue${values[key]['tasks']}");
            taskData = values[key]['tasks'];
            print("taskData$taskData");
            updateTask("Anji", key, taskData);
            print("dataupdated");
            setState(() {
              updated = true;
            });
          }
        }
      }
      if (updated == false) {
        Map<String, dynamic> taskMap = {
          "date": dateController.text,
          "tasks": taskList,
          "logInTime": logInTime,
          "logOutTime": logOutTime
        };
        print("taskMap${taskMap}");
        firebaseDatabase
            .reference()
            .child("Tasks")
            .child(widget.userId)
            .push()
            .set(taskMap);
      }
    });
  }

  updateTask(String username, String key, List list) async {
    String date = dateController.text;
    String hrs = hoursController.text;
    List task = taskList;
    print("tasksaddedData${list.length}");
    for (int i = 0; i < list.length ?? 0; i++) {
      task.add(list[i]);
      print("tasksaddedData$task");
    }

    //String xyz = imageFile!.path;

    Map<String, dynamic> addTask = {
      'hours': hrs,
      'tasks': task,
      'logInTime': logInTime,
      'logOutTime': logOutTime

      // 'image': abc,
    };

    firebaseDatabase
        .reference()
        .child("Tasks")
        .child("${widget.userId}/$key")
        .update(addTask);
  }

  Future<void> _show() async {
    final TimeOfDay result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,

        );
      },
    );
    if (result != null) {
      print(result.period); // DayPeriod.pm or DayPeriod.am
      print(result.hour);
      print(result.minute);
      setState(() {

        logInTime = result.format(context);
      });
    }
  }

  Future<void> selectLogOutTime() async {
    final TimeOfDay result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (result != null) {
      setState(() {
        logOutTime = result.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Task"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: TextButton(
                    onPressed: () async {
                      if (logInTime == null) {
                        showSnackBar("Please enter LogInTime");
                      } else if (logOutTime == null) {
                        showSnackBar("Please enter LogOutTime");
                      } else {
                        await getData();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      userId: widget.userId,
                                    )));
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ))),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Date ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(":"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                  /*Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Hours",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      Text(":"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: hoursController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),*/
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "LogInTime",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(":"),
                      IconButton(
                        icon: Icon(Icons.alarm),
                        onPressed: () {
                          _show();
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            "${logInTime}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      /*Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: logInTimeController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.alarm),
                                onPressed: () {
                                  _show();
                                },
                              )),
                        ),
                      ),*/
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "LogOutTime",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(":"),
                      IconButton(
                        icon: Icon(Icons.alarm),
                        onPressed: () {
                          selectLogOutTime();
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 2,
                          child: Text("${logOutTime}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))),
                      /*Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: logOutTimeController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(5),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.alarm),
                                onPressed: () {
                                  selectLogOutTime();
                                },
                              )),
                        ),
                      ),*/
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: taskList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(taskList[index]),
                              trailing: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    taskList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            left: 10,
            bottom: 15,
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: taskController,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Enter task",
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: () {
                        if (taskController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Please enter the Task")));
                        } else {
                          setState(() {
                            taskList.add(taskController.text);
                            taskController.clear();
                          });
                        }
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }
}
