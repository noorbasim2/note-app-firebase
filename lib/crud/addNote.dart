// ignore_for_file: file_names, prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_new, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, deprecated_member_use, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../MyHomePage.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  CollectionReference noteReference =
      FirebaseFirestore.instance.collection("notes");

  var title, note;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  addNote(context) async {
    var formdata = formState.currentState;
    if (formdata!.validate()) {
      formdata.save();
      await noteReference.add(
        {
          "title": title,
          "note": note,
          "userid": FirebaseAuth.instance.currentUser?.uid,
        },
      ).then((value) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MyHomePage();
        }), (route) => false);
      }).catchError((e) {
        print("-=-=-=${e}-=-=-=-=-");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Color(0XFFF79E89),
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Add Note",
              style: TextStyle(color: Color(0XFFF79E89)),
            )),
        body: Container(
          height: double.infinity,
          color: Color(0XFFF79E89),
          child: ListView(
            children: [
              Form(
                key: formState,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      //--------------------------------------------
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          onSaved: (val) {
                            title = val;
                          },
                          controller: note,
                          maxLength: 21,
                          maxLines: 1,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              labelText: "Title Note",
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.note,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      //--------------------------------------------
                      Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(20),
                          width: 380,
                          height: 500,
                          child: TextFormField(
                            onSaved: (val) {
                              note = val;
                            },
                            minLines: 1,
                            maxLines: 18,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                labelText: "Description",
                                labelStyle: TextStyle(color: Colors.white)),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      //--------------------------------------------
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white.withOpacity(0.8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            side: BorderSide(
                                color: Color.fromARGB(255, 236, 126, 98),
                                width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            textStyle: TextStyle(fontSize: 20)),
                        onPressed: () async {
                          addNote(context);
                        },
                        child: Text(
                          "Add Note",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      //--------------------------------------------
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
