import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Tensorflow extends StatefulWidget {
  @override
  _TensorflowState createState() => _TensorflowState();
}

class _TensorflowState extends State<Tensorflow> {
  List _outputs;
  File _image;
  bool _loading = false;

  get picker => null;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

   getImage() async {
    ImagePicker _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Skin Cancer Detection",
            style: TextStyle(color: Colors.amber, fontSize: 25),
          ),
          backgroundColor: Colors.amber[900],
          elevation: 0,
        ),
        body: Container(
          color: Colors.black45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _loading
                  ? Container(
                      height: 300,
                      width: 300,
                    )
                  : Container(
                      margin: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _image == null ? Container() : Image.file(_image),
                          SizedBox(
                            height: 20,
                          ),
                          _image == null
                              ? Container()
                              : _outputs != null
                                  ? Text(
                                      _outputs[0]["label"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    )
                                  : Container(child: Text(""))
                        ],
                      ),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
              mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    tooltip: 'Pick Image',
                    onPressed: pickImage,
                    child: Icon(
                      Icons.add_a_photo,
                      size: 20,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.amber[900],
                  ),
                  SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
                  FloatingActionButton(
                tooltip: 'Pick Image',
                onPressed: getImage,
                child: Icon(
                  Icons.camera,
                  size: 20,
                  color: Colors.black,
                ),
                backgroundColor: Colors.amber[900],
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
