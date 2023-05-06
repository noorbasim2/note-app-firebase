import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialogMethod(String text, BuildContext context,
    {required Widget widget}) {
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
