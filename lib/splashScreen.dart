import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scracher_grid/grid.dart';
import 'package:scracher_grid/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



Future getValidationData()async{
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var obtainedToken = sharedPreferences.getString("token");
  print(obtainedToken);
 if (obtainedToken == null) {
   Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));

 }
 else { Navigator.of(context).push(MaterialPageRoute(builder: (context) => GridView1()));
 }
}



startTime() async {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, getValidationData);
  }

  navigationPage()async{
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  LoginPage()));
  }


  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // Text("hello", style: TextStyle(fontSize: 35),),
            Image.asset("assets/images/splashScreen.jpg" ,fit: BoxFit.fill,),
          ],
        ),
      ),
    );
  }
}
