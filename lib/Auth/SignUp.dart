// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../MyHomePage.dart';
import '../component/AwesomeDialogMethod.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isRememberMe = false;
  bool _obscureText = true;
  var myPassword, myEmail;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  signUp() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        AwesomeDialogMethod("please wait", context,
                widget: Center(
                    child: CircularProgressIndicator(color: Colors.black87)))
            .show();
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myEmail,
          password: myPassword,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialogMethod("Password is to weak", context, widget: Center())
              .show();
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialogMethod(
                  "the account already exists for that email", context,
                  widget: Center())
              .show();
          print('The account already exists for that email.');
        }
      } catch (e) {
        print("=-=-=-=-${e}-=-=-=");
      }
    } else {}
  }

  Widget buildEmail_Password() {
    return Form(
      key: formState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            height: 60,
            padding: EdgeInsets.only(bottom: 5, left: 5),
            child: TextFormField(
              onSaved: (val) {
                myEmail = val;
              },
              validator: (val) {
                if (val!.length > 100) {
                  return "email cant't to be larger than 100 letter ";
                }
                if (val.length < 2) {
                  return "email cant't to be less than 2 letter ";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Color(0XFFF79E89)),
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Password",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            height: 60,
            padding: EdgeInsets.only(bottom: 5, left: 5),
            child: TextFormField(
              onSaved: (val) {
                myPassword = val;
              },
              validator: (val) {
                if (val!.length > 100) {
                  return "Password can't to be larger than 100 letter ";
                }
                if (val.length < 4) {
                  return "Password can't to be less than 4 letter ";
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black87,
              ),
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: (() {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }),
                  child: Icon(
                    _obscureText ? (Icons.visibility_off) : Icons.visibility,
                    color: Color(0XFFF79E89),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0XFFF79E89),
                ),
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          UserCredential response = await signUp();
          print("======================");
          if (response != null) {
            await FirebaseFirestore.instance.collection("users").add({
              "email": myEmail,
            });
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MyHomePage();
              },
            ), (route) => false);
          } else {
            print("sing up faild");
          }
          print("======================");
        },
        child: Text("Sign Up", style: TextStyle(color: Color(0XFFF79E89))),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildLogInBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("login");
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "Have an account? ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            TextSpan(
                text: "Log In",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0XFFF79E89),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "T O",
                          // style: Theme.of(context).textTheme.headline1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.checklist_sharp,
                          size: 45,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Text(
                      "D O\nL I S T",
                      // style: Theme.of(context).textTheme.headline1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 50),
                buildEmail_Password(),
                buildSignUpBtn(),
                buildLogInBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
