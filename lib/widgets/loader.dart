import 'package:dar_elanaqa/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  Loader({required this.msg});
  String msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Text(
            msg,
            style: TextStyle(fontSize: 30, color: SupTitleColor),
          ),
        ),
        const Center(
            child: SpinKitWaveSpinner(
          color: PrimaryColor,
          waveColor: PrimaryColorop,
          size: 200,
          duration: const Duration(milliseconds: 1500),
        )),
      ],
    );
  }
}
