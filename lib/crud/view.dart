// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'editNote.dart';

class ViewNote extends StatefulWidget {
  final note;

  const ViewNote({Key? key, this.note}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  // get notes => null;
  //  notes = [];

  @override
  Widget build(BuildContext context) {
    //
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    //
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Color(0XFFF79E89),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "${widget.note['title']}",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            bottom: PreferredSize(
              preferredSize: Size(0, 40),
              child: Row(),
            ),
            backgroundColor: Color(0XFFF79E89),
            centerTitle: true,
            elevation: 2,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(
                          "${widget.note['note']}",
                          style: TextStyle(
                              fontSize: 25, wordSpacing: 1, letterSpacing: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
