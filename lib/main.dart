import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:photo_view/photo_view.dart';
import 'package:poseapp/CamImage.dart';

void main() {
  runApp(CameraApp());
}

class CameraApp extends StatefulWidget {
  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  StreamController<CameraImage> _cameraStreamController =
      StreamController.broadcast();
  bool _controllerIsInitialized = false;
  double _slider = 0;
  var _red = <double>[1,0,0];
  var _green = <double>[0,1,0];
  var _blue = <double>[0,0,1];
  CameraController _controller;

  Future<void> initializeController() async {
    _controller = CameraController(
        (await availableCameras()).first, ResolutionPreset.max);
    await _controller.initialize();
    _controller.startImageStream((image) => _cameraStreamController.add(image));
    setState(() {
      _controllerIsInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  void mapRedToGreenOrBlue(double sliderValue) {
    _red[0] = 1 - sliderValue.abs();
    if (sliderValue > 0) { // red to green
      _red[1] = sliderValue.abs();
    }
    else {
      _red[2] = sliderValue.abs();
    }
  }

  ColorFilter getFilter(){
    return ColorFilter.matrix(<double>[
      _red[0], 0, 0, 0, 0,
      _red[1], 1, 0, 0, 0,
      _red[2], 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
            body: Stack(children: <Widget>[
          _controllerIsInitialized
              ? ColorFiltered(colorFilter: this.getFilter(), child: CameraPreview(_controller))

              : CircularProgressIndicator(),
              Slider(onChanged: (double newValue) {
                mapRedToGreenOrBlue(newValue);
                _slider = newValue;
                setState(() {
                  print(_red);
                });
              }, value: _slider, min: -1, max: 1),
        ])));
  }
}

const ColorFilter greyscale = ColorFilter.matrix(<double>[
  0.9,
  0.9,
  0.9,
  0,
  0,
  0.2126,
  0.9,
  0.0722,
  0.4,
  0,
  0.0,
  0.0,
  0.0,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

const ColorFilter identity = ColorFilter.matrix(<double>[
  0.9, 0, 0, 0, 0,
  0.1, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 1, 0,
]);
