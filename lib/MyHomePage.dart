// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_single_cascade_in_expression_statements

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app_firebase/crud/view.dart';

import 'crud/editNote.dart';

CollectionReference noteReference =
    FirebaseFirestore.instance.collection("notes");

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    print(user!.email);
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0XFFF79E89),
        onPressed: () {
          Navigator.of(context).pushNamed("addNote");
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          children: [
            Icon(Icons.fact_check_outlined, color: Color(0XFFF79E89), size: 30),
            SizedBox(width: 5),
            Text(
              "List of todo",
              style: TextStyle(color: Color(0XFFF79E89), fontSize: 25),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed("login");
            },
            icon: Icon(Icons.exit_to_app),
            color: Color(0XFFF79E89),
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: noteReference
              .where("userid",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ViewNote(
                          note: snapshot.data.docs[i],
                        );
                      }));
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0XFFF79E89),
                      ),
                      margin: EdgeInsets.all(9),
                      child: ListNotes(
                        notes: snapshot.data.docs[i],
                        docid: snapshot.data.docs[i].id,
                      ),
                    ),
                  );
                }),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  ListNotes({this.notes, this.docid});

  @override
  Widget build(BuildContext context) {
    //
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    //
    return ListTile(
      isThreeLine: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text("${notes['title']}",
            style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Text(
          "${notes['note']}",
          style: TextStyle(color: Colors.white, wordSpacing: 0.9),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                bodyHeaderDistance: 0.0,
                padding: EdgeInsets.all(0),
                width: _width * 0.84,
                animType: AnimType.RIGHSLIDE,
                dismissOnTouchOutside: false, //true dismiss .false no dismiss
                keyboardAware: false,
                dismissOnBackKeyPress: false,
                body: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0XFFF79E89),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      padding: EdgeInsets.all(5),
                      height: _height * 0.19,
                      width: _width * 0.84,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: _height * 0.06,
                            width: _width * 0.12,
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white)),
                            child: Center(
                              child: Icon(
                                Icons.warning_amber_outlined,
                                color: Colors.black87,
                                size: 35,
                              ),
                            ),
                          ),
                          Text(
                            "Delete Note",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            "You cannot undo this action",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: _height * 0.09,
                      color: Colors.white,
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await noteReference.doc(notes.id).delete();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "homepage", (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0XFFF79E89),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: Text("Delete",
                                  style: TextStyle(fontSize: 16))),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0XFFF79E89),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                            child:
                                Text("Cancel", style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )..show();
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) {
                      return Edit_Note(
                        docid: docid,
                        list: notes,
                      );
                    }),
                  ),
                );
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}
