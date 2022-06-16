import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scracher_grid/grid.dart';
import 'package:scracher_grid/models/global.dart';
import 'package:scracher_grid/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OtpPage extends StatefulWidget {
  final String ? varifyID;
  final String ? phoneNumber;
  const OtpPage({Key? key ,this.varifyID , this.phoneNumber}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController otpController = TextEditingController();


 void signInWithPhoneAuthCred (AuthCredential phoneAuthCredential) async {
   
   try {
     final authCred = await _auth.signInWithCredential(phoneAuthCredential);
     if (authCred.user != null){
       print(authCred.user!.uid);
       Global.firebaseId = authCred.user!.uid;

       final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
       sharedPreferences.setString("token", Global.firebaseId!);
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(phoneNumber: widget.phoneNumber,isActive: false,)));
     }
   } on FirebaseAuthException catch (e) {
     print(e.message);
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some Error"),));
   }

 }



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0 , horizontal: 40.0),
            child: Column(
              children: [
                Text("WelCome" , style: TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold),),
                SizedBox(height: 50,),
                TextFormField(
                  autofillHints: [AutofillHints.oneTimeCode],
                  controller: otpController,
                  validator: (value){
                    if(value == null || value.isEmpty){return "OTP required";}
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text("OTP"),
                    hintText: "Enter OTP" ,
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
                  child: ElevatedButton(onPressed: () {
                   if(formKey.currentState!.validate()){
                     AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: widget.varifyID.toString(), smsCode: otpController.text);
                     signInWithPhoneAuthCred(phoneAuthCredential);
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
                      child: Text("Verify")),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
