import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scracher_grid/models/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'grid.dart';
import 'models/user_model.dart';


class Profile extends StatefulWidget {
  final String? phoneNumber;
  final String? name;
  final String? city;
  final String? state;
  final String? zipcode;
  final bool? isActive;
  const Profile({Key? key,this.phoneNumber , this.name,this.city,this.state,this.zipcode, required this.isActive}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();




  @override
  void initState() {
   if(widget.isActive == true){
     phoneController.text = widget.phoneNumber.toString();
     nameController.text = widget.name.toString();
     cityController.text = widget.city.toString();
     stateController.text = widget.state.toString();
     zipcodeController.text = widget.zipcode.toString();
   } else{
     phoneController.text = widget.phoneNumber.toString();
   }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0 , horizontal: 40.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Profile" , style: TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold),),
                  SizedBox(height: 50,),
                  TextFormField(
                    controller: nameController,
                    validator: (value){
                      if(value == null || value.isEmpty){return "Name Required";}
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("Name"),
                      hintText: "Enter Your Name" ,
                      prefixIcon: Icon(Icons.account_circle),
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 50,),
                  TextFormField(
                   controller: phoneController,
                    validator: (value){
                      if(value == null || value.isEmpty){return "Number required";}
                      if (value.length<10 || value.length > 10){return "Invalid Number";}
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("Phone Number"),
                      hintText: "Enter your Number" ,
                      prefixIcon: Icon(Icons.phone_android),
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 50,),
                  TextFormField(
                    controller: cityController,
                    validator: (value){
                      if(value == null || value.isEmpty){return "City Required";}
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("City"),
                      hintText: "Enter Your City" ,
                      prefixIcon: Icon(Icons.location_city),
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 50,),
                  TextFormField(
                    controller: stateController,
                    validator: (value){
                      if(value == null || value.isEmpty){return "State Required";}
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("State"),
                      hintText: "Enter Your State" ,
                      prefixIcon: Icon(Icons.location_city),
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 50,),
                  TextFormField(
                    controller: zipcodeController,
                    validator: (value){
                      if(value == null || value.isEmpty){return "zipCode Required";}
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("Zipcode"),
                      hintText: "Enter Your Zipcode" ,
                      prefixIcon: Icon(Icons.location_city),
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 50,),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(onPressed: ()  {
                     if(formKey.currentState!.validate()) {
                       postDetailsToFirestore();

                     }
                   //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => GridView1() ));
                    },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)
                                )
                            )
                        ),
                        child: Text("Update")),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.name = nameController.text;
    userModel.phone = phoneController.text;
    userModel.city = cityController.text;
    userModel.state = stateController.text;
    userModel.zipcode = zipcodeController.text;

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", user!.uid);

    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Updated");
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => GridView1()));



  }

}
