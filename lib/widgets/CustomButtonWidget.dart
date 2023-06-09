import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  Color color = Colors.black;
  String msg = "";
  void Function() handelpress = () => {};
  CustomButtonWidget(
      {required this.color, required this.msg, required this.handelpress});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 100,
      constraints: BoxConstraints(minHeight: 50),
      textStyle: TextStyle(fontSize: 20, color: color),
      splashColor: color,
      child: Text(msg),
      onPressed: handelpress,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: color, width: 3)),
    );
    ;
  }
}
