/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teamtracker/task_model.dart';

import 'home.dart';

class Add extends StatefulWidget {
  String user;

  Add({Key key, this.user}) : super(key: key);

  @override
  AddState createState() => AddState();
}

class _AddState extends State<Add> {
  TextEditingController dateController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  List<String> taskDescripition = [];
  String formattedDate = "";
  List taskData = [];

  // FirebaseStorage storage = FirebaseStorage.instance;
  bool updated = false;
  String userName = "";
  List<TaskModel> taskList = [];
  DatabaseReference reference =
  FirebaseDatabase.instance.reference().child('Tasks');
  List<dynamic> tasks = [];

  getData(String name) {
    print("name$name");
    FirebaseDatabase.instance
        .reference()
        .child('Tasks')
        .child("Anji")
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot${snapshot.value}");

      var keys = snapshot.value.keys;
      print("keys${keys}");
      var values = snapshot.value;
      print("values${values}");
      for (String key in keys) {
        print("key $key");

        if (values[key]['date'].toString() ==
            DateFormat('dd-MM-yyyy').format(DateTime.now())) {
          print("taskValue${values[key]['task']}");
          taskData = values[key]['task'];
          print("taskData$taskData");
          updateTask("Anji", key, taskData);
          print("dataupdated");
          setState(() {
            updated = true;
          });
        }

      }
      if (updated == false) {
        saveTask(widget.user);
      }
      print("datasaved");
    });
  }

  saveData() {
    print("save data executed");
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i]
          .date
          .contains(DateFormat('dd-MM-yyyy').format(DateTime.now()))) {
        print("${taskList[i].date}");
        getData("Anji");
        print("Dataupdated");
      } else {}
    }
    saveTask(widget.user);
    print("datanot saved");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData("Anji");
    dateController.text = formatter.format(now);
    reference = FirebaseDatabase.instance.reference().child('Tasks');
    userName = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add hours",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              // saveData();
              // saveTask("Anji");
              getData("Anji");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                      user: userName,
                    )),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                    "submit",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
            ),
          )
        ],
        backgroundColor: Colors.green,
      ),
      body: Container(
        // padding: EdgeInsets.all(15),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text(
                  "Date :",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Hours :",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: hoursController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: taskDescripition.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${taskDescripition[index]}"),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          taskDescripition.removeAt(index);
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                  );
                }),
            Expanded(child: Container()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      //height:MediaQuery.of(context).size.height- ,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        margin: EdgeInsets.only(left: 2, bottom: 25, right: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          controller: taskController,
                          onChanged: (value) {

                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Message",
                            prefixIcon: IconButton(
                              icon: Icon(Icons.emoji_emotions),
                              color: Colors.grey,
                              onPressed: () {},
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.send,
                              ),
                              color: Colors.green,
                              onPressed: () {
                                taskDescripition.add(taskController.text);
                                taskController.clear();

                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveTask(String username) async {
    //var imageUpLoad =  await uploadImage();
    String date = dateController.text;
    String hrs = hoursController.text;
    List task = taskDescripition;

    //String xyz = imageFile!.path;
    print("task saved");
    print("task$username");
    Map<String, dynamic> addTask = {
      'date': date,
      'hrs': hrs,
      'task': task,
    };

    reference.child("Anji").push().set(addTask);
  }

  updateTask(String username, String key, List list) async {
    //var imageUpLoad =  await uploadImage();
    List addTaskList = [];
    String date = dateController.text;
    String hrs = hoursController.text;
    List task = taskDescripition;
    for (int i = 0; i < list.length; i++) {
      task.add(list[i]);
      print("tasksaddedData$task");
    }

    //String xyz = imageFile!.path;

    Map<String, dynamic> addTask = {
      'hrs': hrs,
      'task': task,

      // 'image': abc,
    };

    reference.child("Anji/$key").update(addTask);
  }
}*/
