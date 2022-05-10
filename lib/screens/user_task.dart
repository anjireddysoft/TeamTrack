// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:team_tracker/models/task_model.dart';
// import 'package:team_tracker/models/usermodel.dart';
//
// class UserTask extends StatefulWidget {
//   UserModel userModel;
//    UserTask({Key key,this.userModel}) : super(key: key);
//
//   @override
//   _UserTaskState createState() => _UserTaskState();
// }
//
// class _UserTaskState extends State<UserTask> {
//   List<TaskModel> taskList = [];
//   getData() {
//     FirebaseDatabase.instance
//         .reference()
//         .child('Tasks')
//         .child(widget.userModel.userId)
//         .once()
//         .then((DataSnapshot snapshot) {
//       print("snapshot${snapshot.value}");
//
//       var keys = snapshot.value.keys;
//       print("keys${keys}");
//       var values = snapshot.value;
//       print("values${values}");
//       for (String key in keys) {
//         print("key $key");
//         TaskModel data = TaskModel(
//             date: values[key]['date'],
//             hours: values[key]['hours'],
//             task: values[key]['tasks']);
//
//         setState(() {
//           taskList.add(data);
//         });
//         print(taskList[0].date);
//         print(taskList.length);
//       }
//     });
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     getData();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.userModel.name),),
//       body: taskList.isEmpty?Center(child: CircularProgressIndicator()):SingleChildScrollView(
//         child: Container(
//           child: ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: taskList.length,
//               itemBuilder: (context, index) {
//                 // print("tasklength${taskList[index].task.length}");
//                 return Container(
//                   child: Card(
//                     elevation: 5,
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Date : ${taskList[index].date}",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "hours : ${taskList[index].hours}",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           ),
//                           Divider(thickness: 1,color: Colors.grey,),
//                           Container(
//                             padding: EdgeInsets.all(5),
//                             child: ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 itemCount: taskList[index].task.length,
//                                 itemBuilder: (context, ind) {
//                                   return Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(Icons.arrow_forward),
//                                           SizedBox(width: 15,),
//                                           Expanded(child: Text("${taskList[index].task[ind]}")),
//                                         ],
//                                       ),
//                                       SizedBox(height: 10
//                                         ,)
//                                     ],
//                                   );
//                                 }),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }
