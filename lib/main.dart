import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  CameraController _controller;

  Future<void> initializeController() async {
    _controller = CameraController(
        (await availableCameras()).first, ResolutionPreset.high);
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
      home: _controllerIsInitialized
          ? CamImage(cameraStream: _cameraStreamController.stream)
          : CircularProgressIndicator(),
    );
  }
}
