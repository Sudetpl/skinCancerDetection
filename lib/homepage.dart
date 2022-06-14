import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  static const route = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';
  String age = '';
  String gendar = '';
  String imageURL = '';
  File _image;
  final user = FirebaseAuth.instance.currentUser;

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
        return;
      }
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child("user_image")
        .child(user.uid + '.jpg');

    await ref.putFile(_image);

    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'image_url': url});

  }

  @override
  Widget build(BuildContext context) {
    var isObscure = false;

    return Scaffold(
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: new Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 236, 186, 186),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Home',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(
                                'Welcome To your Profile',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => FirebaseAuth.instance.signOut(),
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    top: MediaQuery.of(context).size.height / 4.1,
                  ),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(snapshot.data['image_url']),
                      ),
                      InkWell(
                        onTap: getImageFromGallery,
                        child: Container(
                          decoration: BoxDecoration(),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 4 - 60,
                            top: MediaQuery.of(context).size.height / 6.7,
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.1,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(border: Border.all(width: 2)),
                        padding: EdgeInsets.all(8),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'E-mail:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Password:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Age:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Gendar:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data['email'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    isObscure == true
                                        ? snapshot.data['password']
                                        : '${snapshot.data['password'].replaceAll(RegExp(r"."), "*")}',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    snapshot.data['age'].toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    snapshot.data['gendar'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: ElevatedButton(
                              onPressed: () {
                                print(email);
                              },
                              child: FittedBox(
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.all<double>(12),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  OvalBottomBorderClipper() {}
}
