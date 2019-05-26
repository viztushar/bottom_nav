import 'package:flutter/material.dart';
import 'package:bottom_nav/bottom_nav.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom NavBar',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example"),
      ),
      body: Container(),
      bottomNavigationBar: BottomNav(
        index: currentTab,
        backgroundColor: Colors.white,
        navBarHeight: 75.0,
        radius: 30.0,
        onTap: (i) {
          setState(() {
            currentTab = i;
          });
        },
        items: [
          BottomNavItem(
              icon: Icons.home, label: "Home", selectedColor: Colors.amber),
          BottomNavItem(
              icon: Icons.favorite, 
              label: "Likes", 
              selectedColor: Colors.pink),
          BottomNavItem(
              icon: Icons.search, 
              label: "Search", 
              selectedColor: Colors.blue),
          BottomNavItem(
              icon: Icons.person,
              label: "Profile",
              selectedColor: Colors.black),
        ],
      ),
    );
  }
}
