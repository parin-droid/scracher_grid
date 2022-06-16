import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scracher_grid/categories.dart';
import 'package:scracher_grid/models/global.dart';
import 'package:scracher_grid/profile.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'login.dart';



class GridView1 extends StatefulWidget {
  const GridView1({Key? key}) : super(key: key);

  @override
  State<GridView1> createState() => _GridView1State();
}

class _GridView1State extends State<GridView1> {
 String? name = "";
 String? number = "";
 String? city = "";
 String? state = "";
 String? zipcode = "";

 FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

 bool isCompleted = false;
   var scratcherKey = GlobalKey<ScratcherState>();

void getData()async{
  User? user = await FirebaseAuth.instance.currentUser;
  var info = await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  setState(() {
    name = info.data()!['name'];
    number = info.data()!['phone'];
    city = info.data()!['city'];
    state = info.data()!['state'];
    zipcode = info.data()!['zipcode'];


  });
}


   scratchViewDialog(context,int index){
     return showDialog(
         context: context,
         builder: (BuildContext context){
           return Center(
             child: Container(
               height: 250,width: 250,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
               ),
               child: Scratcher(

                   key: scratcherKey,
                   color: Colors.green,
                   brushSize: 50,
                   threshold: 50,
                   /* onScratchEnd: (){
                      setState(() {
                        isCompleted = true;
                      });
                      },*/

                   onThreshold: (){
                     setState(() {
                       scratcherKey.currentState?.isFinished = (true ? myData[index].isChecked= true : false);
                     });
                   },

                   child:Container(
                     height: 250,
                     width: 250,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: myData[index].color,
                     ),
                     child: Center(child: Text("${myData[index].text}")),
                   )),
             ),
           ) ;
         });
   }

   List<apple> myData = [
     apple(color: Colors.cyan,text: "Bol bhai",isChecked: false),
     apple(color: Colors.pink,text: "Arun",isChecked: false),
     apple(color: Colors.yellow,text: "Deep",isChecked: false),
     apple(color: Colors.orange,text: "Ankit",isChecked: false),
     apple(color: Colors.purple,text: "Insaan",isChecked: false),
     apple(color: Colors.blue,text: "Parin",isChecked: false),
     apple(color: Colors.amber,text: "Jainesh",isChecked: false),
     apple(color: Colors.grey,text: "Rajdeep",isChecked: false),];

@override
  void initState() {
  firebaseCloudMessaging_Listeners();
  getData();
    super.initState();
  }

  void firebaseCloudMessaging_Listeners() {
  if (Platform.isIOS) iOS_Permission();

  firebaseMessaging.getToken().then((token) {
    print("Token is $token");
  });
  FirebaseMessaging.onMessage.listen((event) {
   print(event.notification!.title);
    print(event.notification!.body);
   /* print(event.data['title'].toString());
    print(event.data['body']);*/
  });
}

  void iOS_Permission(){
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        actions: [
          IconButton(onPressed: () async{
            final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
            sharedpreferences.remove("token");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));

          },
              icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Column(
            children: [
              SizedBox(height: 200, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${name}" , style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold)),
                  Text("${number}" , style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold)),
                ],
              )),),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(name: name,phoneNumber: number,city: city,state: state,zipcode: zipcode, isActive: true,)));
                },
                child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                  minLeadingWidth: 5,
                  leading: Icon(Icons.account_circle),
                  title: Text("Profile" ,style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
                },
                child: ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  minLeadingWidth: 5,
                  leading: Icon(Icons.account_circle),
                  title: Text("Category" ,style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
            itemCount: myData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context , index){
              return GestureDetector(
                onTap: (){
                  scratchViewDialog(context,index);

                } ,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                          color: myData[index].color
                      ),
                      child: Center(child: Text("${myData[index].text}")),

                    ),
                   myData[index].isChecked == true ? Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: Colors.transparent,
                     ),

                   ) : Container(decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green
                      ),),
                  ],
                ),
              );
            }),
      ),
    );
  }
}


class apple {

  String? text;
  bool? isChecked;
  Color? color;

  apple({this.text, this.isChecked, this.color});
}