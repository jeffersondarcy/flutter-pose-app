import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class LivePic extends StatefulWidget {
  @override
  LivePicState createState() => LivePicState();
}

class LivePicState extends State<LivePic> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  Future<CameraDescription> getCamera() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  Future<void> initializeController() async {
    final camera = await getCamera();
    _controller = CameraController(camera, ResolutionPreset.max);
    return _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initializeController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Placeholder();
          }
        });
  }
}
