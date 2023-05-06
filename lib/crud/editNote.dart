// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../component/AwesomeDialogMethod.dart';

class Edit_Note extends StatefulWidget {
  final docid;
  final list;

  const Edit_Note({Key? key, this.docid, this.list}) : super(key: key);

  @override
  State<Edit_Note> createState() => _Edit_NoteState();
}

class _Edit_NoteState extends State<Edit_Note> {
  CollectionReference noteReference =
      FirebaseFirestore.instance.collection("notes");

  GlobalKey<FormState> formState = GlobalKey();

  var title, note;

  editNote(context) async {
    var formData = formState.currentState;

    if (formData!.validate()) {
      // showLoading(context);
      formData.save();
      await noteReference.doc(widget.docid).update({
        "title": title,
        "note": note,
      }).then((value) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (route) => false);
      }).catchError((e) {
        print("$e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFFF79E89),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        color: Color(0XFFF79E89),
        padding: EdgeInsets.all(10),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        initialValue: widget.list['title'],
                        onSaved: (val) {
                          title = val;
                        },
                        validator: (val) {
                          if (val!.length > 30) {
                            return "note title can't to be larger than 30 letter ";
                          }

                          if (val.length < 2) {
                            return "note title can't to be less than 2 letter ";
                          }
                          return null;
                        },
                        maxLength: 21,
                        maxLines: 1,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // الحواف الدائرية
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // الحواف الدائرية
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2)),
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
                          initialValue: widget.list['note'],
                          onSaved: (val) {
                            note = val;
                          },
                          validator: (val) {
                            if (val!.length > 700) {
                              return "note can't to be larger than 700 letter ";
                            }
                            if (val.length < 1) {
                              return "note can't to be less than 1 letter ";
                            }
                            return null;
                          },
                          maxLines: 18,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // الحواف الدائرية
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // الحواف الدائرية
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                )),
                          ),
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
                            width: 2,
                            // strokeAlign: 0.2,
                            // style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          textStyle: TextStyle(fontSize: 20)),
                      onPressed: () async {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.NO_HEADER,
                          bodyHeaderDistance: 0.0,
                          padding: EdgeInsets.all(0),
                          width: _width * 0.84,
                          animType: AnimType.RIGHSLIDE,
                          dismissOnTouchOutside:
                              false, //true dismiss .false no dismiss
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: _height * 0.06,
                                      width: _width * 0.12,
                                      decoration: BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: Center(
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.black87,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Edit Note",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      "You will edit this note",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: _height * 0.09,
                                color: Colors.white,
                                margin: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          await editNote(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Color(0XFFF79E89),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7))),
                                        child: Text("Edit",
                                            style: TextStyle(fontSize: 16))),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0XFFF79E89),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                      ),
                                      child: Text("Cancel",
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).show();
                        // //
                      },
                      child: Text(
                        "Edit Note",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
