import 'dart:io';

import 'package:SmileHelper/game/camera_view.dart';
import 'package:SmileHelper/game/controller/getPredict.dart';
import 'package:SmileHelper/game/countdown.dart';
import 'package:SmileHelper/game/express_view.dart';
import 'package:SmileHelper/game/mlkit/detector_view.dart';
import 'package:SmileHelper/game/mlkit/message_view.dart';
import 'package:SmileHelper/game/showStatusImage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:SmileHelper/game/controller/scan_controller.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  State<CameraScreen> createState() => _ScreenState();
}

class _ScreenState extends State<CameraScreen> {
  //set _controller(ScanController _controller) {}
  late String _path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraView(),
          ),
          MessageView(), // 필요없다
          Showstatusimage(),
          ExpressView(),
          Countdown(),
          //Testmlkit(),
        ],
      ),
    );
  }

  //late CameraController _controller;
  //late Future<void> _initializeControllerFuture;
  String? t;
  @override
  initState() {
    super.initState();
    //_controller = CaptureButton().controller;
  }

  /*_processImage() {
    if (CaptureButton().controller.canProcess) return;
    if (CaptureButton().controller.isBusy) return;
    CaptureButton().controller.isBusy = true;
    setState(() {
      _text = ;
      Logger().e('_processImage: $_text');
    });
  }*/
}
