import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:eb_trial1/classifier.dart';

void main() {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      )));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Classifier classifier = Classifier();
  final picker = ImagePicker();
  String emotion = "";
  late String emoProb;
  var image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            height: size.height * 0.4,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/rv.jpg"),
                fit: BoxFit.cover,
              )),
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            height: size.height * 0.65,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(36.0),
                  topLeft: Radius.circular(36.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Prediction",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    emotion == "" ? "" : "$emoProb% $emotion",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 90.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white,
                              elevation: 10,
                              padding: EdgeInsets.all(16.0),
                              side: BorderSide(
                                width: 2.0,
                                color: Colors.orange,
                              ),
                            ),
                            onPressed: () async {
                              image = await picker.pickImage(
                                  source: ImageSource.camera,
                                  maxHeight: 300,
                                  maxWidth: 300,
                                  imageQuality: 100);

                              final outputs =
                                  await classifier.classifyImage(image);
                              setState(() {
                                emotion = outputs[0];
                                emoProb = outputs[1];
                              });
                            },
                            child: Icon(
                              Icons.camera_alt,
                              size: 35,
                              color: Colors.orange,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Take Photo",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 60.0,
                      ),
                      Column(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white,
                              elevation: 10,
                              padding: EdgeInsets.all(16.0),
                              side: BorderSide(
                                width: 2.0,
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () async {
                              image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 300,
                                  maxWidth: 300,
                                  imageQuality: 100);

                              final outputs =
                                  await classifier.classifyImage(image);
                              setState(() {
                                emotion = outputs[0];
                                emoProb = outputs[1];
                              });
                            },
                            child: Icon(
                              Icons.photo,
                              size: 35,
                              color: Colors.blue[800],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
