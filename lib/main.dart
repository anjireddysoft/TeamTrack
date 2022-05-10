import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_tracker/screens/all_users.dart';
import 'package:team_tracker/screens/home_screen.dart';
import 'package:team_tracker/screens/login_screen.dart';
import 'package:team_tracker/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String isLogIn="false";
  String userId;
  @override
  void initState() {
    // TODO: implement initState
    getLogInValue();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home:isLogIn=="false"?LogInScreen():HomeScreen(userId: userId,)
    );
  }
  getLogInValue()async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String loginValue=preferences.getString("isLogIn")??"false";
    String userValue=preferences.getString("userId")??null;
    print("isLogIn$loginValue");
    print("userId$userValue");
    setState(() {
      isLogIn=loginValue;
      userId=userValue;
    });

  }
}


