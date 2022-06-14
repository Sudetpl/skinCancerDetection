import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensorflow/constants/back_button.dart';
import 'package:tensorflow/constants/register_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key key}) : super(key: key);
  static const route = "/registration";
  @override
  _RegistrationScreen createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();

  var _confirmPasswordFocusNode = FocusNode();
  var _ageFocusNode = FocusNode();
  var _submitFocusNode = FocusNode();
  var _usernameFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  var _emailFocusNode = FocusNode();

  var _usernameEditingController = TextEditingController();
  var _emailEditingController = TextEditingController();
  var _passwordEditingController = TextEditingController();
  var _confirmPasswordEditingController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  AgeTextField ageTextField = new AgeTextField(
    ageValue: null,
  );
  GendarTextField gendarTextField = new GendarTextField(
    gendarValue: null,
  );

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      final form = formKey.currentState;
      UserCredential authResult;
      try {
        setState(() {
          _isLoading = true;
        });
        if (form.validate()) {
          form.save();

          authResult = await _auth.createUserWithEmailAndPassword(
              email: _emailEditingController.text.trim(),
              password: _passwordEditingController.text.trim());
          File imagefile = await getImageFileFromAssets('profilePicutre.png');
          final ref = FirebaseStorage.instance
              .ref()
              .child("user_image")
              .child(authResult.user.uid)
              .child('profilePicture.jpg');

          await ref.putFile(imagefile);
          var url = await ref.getDownloadURL();
          debugPrint(url);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user.uid)
              .set({
            'email': _emailEditingController.text.trim(),
            'username': _usernameEditingController.text.trim(),
            'password': _passwordEditingController.text.trim(),
            'confirm password': _confirmPasswordEditingController.text.trim(),
            'age': ageTextField.ageValue,
            'gendar': gendarTextField.gendarValue,
            'image_url': url
          });

          form.reset();
          Navigator.pop(context);
        }
      } on PlatformException catch (err) {
        var message = "An error occurred, please check your credentils!";

        if (err.message != null) {
          message = err.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        var message = "An error occurred, please check your credentils!";

        if (err.message != null) {
          message = err.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            child: new Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(
                color: Colors.amber[900],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .15,
              top: MediaQuery.of(context).size.height * .05,
              right: MediaQuery.of(context).size.width * .05,
            ),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      'Create a new Account',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Expanded(child: Container()),
                    MyBackButton(context),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        RegisterTextField(
                          nameTextField: 'E-mail',
                          namedFocusNode: _emailFocusNode,
                          nextNamedFocusNode: _usernameFocusNode,
                          namedEditingController: _emailEditingController,
                          obscure: false,
                          errorMessage:
                              "Email must be more than 6 letters and contain @",
                        ),
                        RegisterTextField(
                          nameTextField: 'Username',
                          namedFocusNode: _usernameFocusNode,
                          nextNamedFocusNode: _passwordFocusNode,
                          namedEditingController: _usernameEditingController,
                          obscure: false,
                          errorMessage: "Username must be more than 6 letters",
                        ),
                        RegisterTextField(
                          nameTextField: 'Password',
                          namedFocusNode: _passwordFocusNode,
                          nextNamedFocusNode: _confirmPasswordFocusNode,
                          namedEditingController: _passwordEditingController,
                          obscure: true,
                          errorMessage: "Password must be more than 6 letters",
                        ),
                        RegisterTextField(
                          nameTextField: 'Confirm Password',
                          namedFocusNode: _confirmPasswordFocusNode,
                          nextNamedFocusNode: _ageFocusNode,
                          namedEditingController:
                              _confirmPasswordEditingController,
                          obscure: true,
                          errorMessage:
                              "Confirm Password must be indentical with Password",
                        ),
                        ageTextField,
                        gendarTextField,
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .2,
                              right: MediaQuery.of(context).size.width * .2),
                          child: ElevatedButton(
                            focusNode: _submitFocusNode,
                            onPressed: submit,
                            child: Text('Submit'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.amber[900]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getTemporaryDirectory() {}
}
