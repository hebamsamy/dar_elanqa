import '../Constant.dart';
import '../screens/assetsScreen.dart';
import '../screens/manage_screen.dart';
import '../widgets/AppDrawer.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int Currentindex = 0;
  List<Widget> Screens = [
    ManagementScreen(),
    AssetsScreen(),
  ];
  List<String> Titles = [
    "تسجيل",
    "المنتجات",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WhiteColor,
        foregroundColor: BlackColor,
        title: Text(
          Titles[Currentindex],
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Screens[Currentindex],
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              Currentindex = value;
            });
          },
          currentIndex: Currentindex,
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: SupTitleColor,
          selectedItemColor: PrimaryColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_sharp), label: Titles[0]),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: Titles[1]),
          ]),
    );
  }
}
