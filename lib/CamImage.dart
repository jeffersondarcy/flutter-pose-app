import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CamImage extends StatelessWidget {
  final Stream<CameraImage> cameraStream;
  CamImage({@required this.cameraStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: cameraStream,
        builder: (BuildContext context, AsyncSnapshot<CameraImage> snapshot) {
          print(snapshot.data);
          return Text(snapshot.data.width.toString());
        });
  }
}
