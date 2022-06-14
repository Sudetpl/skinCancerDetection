import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    @required this.nameTextField,
    @required this.namedFocusNode,
    @required this.nextNamedFocusNode,
    @required this.namedEditingController,
    @required this.obscure,
    @required this.errorMessage,
  });
  final String nameTextField;
  final FocusNode namedFocusNode;
  final FocusNode nextNamedFocusNode;
  final TextEditingController namedEditingController;
  final bool obscure;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        nameTextField,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        width: MediaQuery.of(context).size.width * .7,
        child: TextFormField(
          focusNode: namedFocusNode,
          controller: namedEditingController,
          obscureText: obscure,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            fillColor: Color.fromARGB(115, 255, 111, 0),
            filled: true,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextNamedFocusNode);
          },
          validator: (value) => value == null || value == "" || value.length < 6
              ? errorMessage
              : null,
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}

class AgeTextField extends StatefulWidget {
  AgeTextField({Key key, this.ageValue, this.focusNode}) : super(key: key);
  int ageValue = 0;
  final FocusNode focusNode;

  @override
  _AgeTextFieldState createState() => _AgeTextFieldState();
}

class _AgeTextFieldState extends State<AgeTextField> {
  List<int> ageFun() {
    List<int> numList = [];
    for (int i = 1; i < 101; i++) {
      numList.add(i);
    }
    return numList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Age",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: Color.fromARGB(115, 255, 111, 0),
        ),
        child: DropdownButton<int>(
          value: widget.ageValue,
          focusNode: widget.focusNode,
          onChanged: (newValue) {
            setState(() {
              widget.ageValue = newValue;
            });
          },
          items: ageFun()
              .map(
                (e) => DropdownMenuItem<int>(
                  child: Text(e.toString()),
                  value: e,
                ),
              )
              .toList(),
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}

class GendarTextField extends StatefulWidget {
  GendarTextField({Key key, this.gendarValue}) : super(key: key);
  String gendarValue;
  @override
  _GendarTextFieldState createState() => _GendarTextFieldState();
}

class _GendarTextFieldState extends State<GendarTextField> {
  List<String> gendarType = ["Male", "Female"];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Gender",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(
        height: 5,
      ),
      ListTile(
        horizontalTitleGap: 3,
        title: Text(gendarType[0]),
        leading: Radio(
            fillColor: MaterialStateProperty.all<Color>(Colors.black),
            value: gendarType[0],
            groupValue: widget.gendarValue,
            onChanged: (value) {
              setState(() {
                widget.gendarValue = value;
              });
            }),
      ),
      ListTile(
        horizontalTitleGap: 3,
        title: Text(gendarType[1]),
        leading: Radio(
            fillColor: MaterialStateProperty.all<Color>(Colors.black),
            value: gendarType[1],
            groupValue: widget.gendarValue,
            onChanged: (value) {
              setState(() {
                widget.gendarValue = value;
              });
            }),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}
