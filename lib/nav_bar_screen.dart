import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tensorflow.dart';
import 'package:tensorflow/homepage.dart';
import 'package:tensorflow/tensorflow.dart';

import 'homepage.dart';

class NavBarScreen extends StatefulWidget {
  NavBarScreen({Key key}) : super(key: key);

  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  var pageList = [Tensorflow(), Home(),];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.virus), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        backgroundColor: Colors.amber[900],
        unselectedItemColor: Colors.amber[900],
        selectedItemColor: Colors.amber[900],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
