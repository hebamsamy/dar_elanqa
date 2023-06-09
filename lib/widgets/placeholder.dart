import 'package:dar_elanaqa/Constant.dart';
import 'package:flutter/material.dart';

class PlaceHolder extends StatelessWidget {
  String msg;
  PlaceHolder({required this.msg});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            msg,
            style: TextStyle(fontSize: 25, color: SupTitleColor),
          ),
        ),
        Expanded(
          child: Image(
            image: AssetImage("images/placeholder.png"),
          ),
        ),
      ]),
    );
  }
}
