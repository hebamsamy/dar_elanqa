import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset(
              "images/no_connection.png",
              fit: BoxFit.contain,
            ),
          ),
          const Text(
            "No Internet Connection",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Opacity(
            opacity: 0.57,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                "Your internet connection is currently not available please check it or try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 15),
          //   child: OutlinedButton(
          //     onPressed: () {},
          //     child: Text("Try again"),
          //   ),
          // )
        ],
      ),
    );
  }
}
