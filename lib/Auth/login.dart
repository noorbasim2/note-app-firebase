import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../MyHomePage.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isRememberMe = false;
  bool _obscureText = true;
  var myPassword, myEmail;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  signIn() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        AwesomeDialogMethod("please wait",
                widget: Center(
                    child: CircularProgressIndicator(color: Colors.black87)))
            .show();
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myEmail,
          password: myPassword,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialogMethod("No user found for that email.", widget: Center())
              .show();

          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialogMethod("Wrong password provided for that user.",
                  widget: Center())
              .show();

          print('Wrong password provided for that user.');
        }
      }
    } else {
      print("Not Valid");
    }
  }

  Widget buildEmail_Password() {
    return Form(
      key: formState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
              // obscureText: true,
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

  Widget buildLoginBtn() {
    return Container(
      // margin:EdgeInsets.only(top:),
      padding: EdgeInsets.symmetric(vertical: 40),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          var user = await signIn();
          if (user != null) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return MyHomePage();
            }), (route) => false);
          }
        },
        child: Text("Log In", style: TextStyle(color: Color(0XFFF79E89))),
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

  Widget buildSignUpBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("signUp");
        print("Sign Up");
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "Don\'t have an Account? ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            TextSpan(
                text: "Sign Up",
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
                buildLoginBtn(),
                buildSignUpBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AwesomeDialog AwesomeDialogMethod(String text, {required Widget widget}) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      bodyHeaderDistance: 0.0,
      padding: EdgeInsets.all(0),
      width: _width * 0.84,
      animType: AnimType.RIGHSLIDE,
      body: Container(
        decoration: BoxDecoration(
            color: Color(0XFFF79E89),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(5),
        height: _height * 0.19,
        width: _width * 0.84,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget,
            Text(
              "$text",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
