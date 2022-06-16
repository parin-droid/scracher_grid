import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scracher_grid/grid.dart';
import 'package:scracher_grid/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  // String? finalToken;

  TextEditingController phoneController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationID = "";




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0 , horizontal: 40.0),
            child: Column(
              children: [
                Text("WelCome" , style: TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold),),
                SizedBox(height: 50,),
                TextFormField(
                  controller: phoneController,
                  validator: (value){
                    if(value == null || value.isEmpty){return "Phone Number Required";}
                    if (value.length<10 || value.length > 10){return "Invalid Number";}
                    return null;
                  },
                  decoration: InputDecoration(
                  label: Text("Phone Number"),
                  hintText: "Enter Your Mobile Number" ,
                  prefixIcon: Icon(Icons.phone_android),
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey , width: 2)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 50,),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(onPressed: () async {
                    if (formKey.currentState!.validate()){

                      await _auth.verifyPhoneNumber(
                          phoneNumber: "+91${phoneController.text}",
                          verificationCompleted: (phoneAuthCredential) async {
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpPage(varifyID: this.verificationID,phoneNumber: phoneController.text,)));

                          },
                          verificationFailed: (verificationFailed){
                            print(verificationFailed);
                          },
                          codeSent: ( verificationID , resendingToken) async {
                            setState(() {
                              this.verificationID = verificationID;
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpPage(varifyID: this.verificationID,phoneNumber: phoneController.text,)));

                            });
                          },
                          codeAutoRetrievalTimeout: (verificationID)async{}
                      );
                    }
                  },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      child: Text("Send OTP")),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}
