import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:SmileHelper/game/controller/scan_controller.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class Countdown extends GetView<ScanController> {
  const Countdown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController>(builder: (controller) {
      if (!controller.isInitialized) {
        Logger().e("camera view error");
      }

      return Container(
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              controller.countdown.value.toString(), //'countdown',
              style: TextStyle(fontSize: 20),
            )),
      ); //지금은 그냥 글자만
    });
  }
}
