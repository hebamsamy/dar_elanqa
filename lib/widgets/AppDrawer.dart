import 'package:firebase_auth/firebase_auth.dart';

import '../Constant.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  var auth = FirebaseAuth.instance;
  var currentAccount = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              color: PrimaryColor,
              height: 200,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                "Dar ElanaQa App",
                style: TextStyle(color: WhiteColor, fontSize: 30),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/main');
              },
              child: ListTile(
                title: Text("اداره البيانات"),
                trailing: Icon(Icons.list_alt_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                auth.signOut().then((value) =>
                    {Navigator.of(context).pushReplacementNamed("/signin")});
              },
              child: ListTile(
                title: Text("تسجيل الخروج"),
                trailing: Icon(Icons.logout),
                subtitle: Text("${currentAccount!.email} : الحساب الحالي"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
