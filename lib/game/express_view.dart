import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:SmileHelper/game/controller/scan_controller.dart';
import 'package:logger/logger.dart';

class ExpressView extends GetView<ScanController> {
  const ExpressView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController>(initState: (state) {
      controller.onInit();
    }, builder: (controller) {
      switch (controller.currentExpression) {
        case '눈썹 올리기':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/eyebrow.gif')),
          );

        case '눈 감기':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/eyeclose.gif')),
          );

        case '볼 부풀리기':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/cheek.gif')),
          );

        case '입 오므리기':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/mouth_close.gif')),
          );

        case '입 벌리기':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/mouth_open.gif')),
          );

        case '놀람':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/surprise.gif')),
          );

        case '웃음':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/smile.gif')),
          );

        case '찡그리기':
          return Container(
            width: 125,
            height: 150,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/gifs/frown.gif')),
          );

        default:
          return Container();
      }
    });
  }
}
