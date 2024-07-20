import 'package:SmileHelper/hardmode/hard_mode_controller2.dart';
import 'package:SmileHelper/hardmode/hard_mode_controller3.dart';
import 'package:SmileHelper/hardmode/hard_mode_controller4.dart';
import 'package:SmileHelper/hardmode/hard_mode_controller5.dart';
import 'package:SmileHelper/hardmode/hard_mode_controller6.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:SmileHelper/css/screen.dart';
import 'hard_mode_controller.dart';

class HardModeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  HardModeScreen({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HardModeController(cameras: cameras));

    return BaseScreen(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (controller.isInitialized) {
                return CameraPreview(controller.cameraController);
              } else {
                return Container(color: Colors.black);
              }
            }),
          ),
          Positioned(
            top: 50,
            child: Obx(() => Text(
                  controller.message,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
          ),
          Positioned(
            bottom: 50,
            child: Obx(() {
              if (!controller.isCapturing) {
                return ElevatedButton(
                  onPressed: controller.startStage,
                  child: Text('Start'),
                );
              } else if (controller.countdown > 0) {
                return Text(
                  '${controller.countdown}',
                  style: TextStyle(color: Colors.white, fontSize: 48),
                );
              } else {
                return Container();
              }
            }),
          ),
          Positioned(
              top: 100,
              child: Obx(() {
                return Container(
                  child: showExpressions(controller.currentExpression),
                );
              }))
        ],
      ),
    );
  }

  Widget showExpressions(String expression) {
    switch (expression) {
      case 'SURPRISE':
        //Logger().e("SURPRISE start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/surprise.gif',
              width: 150,
              height: 150,
            ),
          ),
        );
      case 'OPEN_MOUTH':
        //Logger().e("OPEN_MOUTH start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/mouth_open.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'BLINK':
        //Logger().e("BLINK start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/eyeclose.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'RAISE_EYEBROWS':
        //Logger().e("RAISE_TYTBROWS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/gifs/eyebrow.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUFF_CHEEKS':
        //Logger().e("PUFF_CHEEKS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/cheek.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUCKER_LIPS':
        //Logger().e("PUCKER_LIPS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/mouth_close.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'TEMP1':
        //Logger().e("FROWN start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.asset(
              'assets/gifs/frown.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      default:
        return Container();
    }
  }
}

class HardModeScreen2 extends StatelessWidget {
  final List<CameraDescription> cameras;

  HardModeScreen2({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HardModeController2(cameras: cameras));

    return BaseScreen(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (controller.isInitialized) {
                return CameraPreview(controller.cameraController);
              } else {
                return Container(color: Colors.black);
              }
            }),
          ),
          Positioned(
            top: 50,
            child: Obx(() => Text(
                  controller.message,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
          ),
          Positioned(
            bottom: 50,
            child: Obx(() {
              if (controller.showStartButton) {
                return ElevatedButton(
                  onPressed: controller.startStage,
                  child: Text('Start'),
                );
              } else if (controller.isCapturing && controller.countdown > 0) {
                return Text(
                  '${controller.countdown}',
                  style: TextStyle(color: Colors.white, fontSize: 48),
                );
              } else {
                return Container(); // 빈 컨테이너를 반환하여 아무것도 표시하지 않음
              }
            }),
          ),
          Positioned(
            child: Obx(() => Text(
                  controller.feedbackMessage,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Positioned(
              top: 100,
              child: Obx(() {
                return Container(
                  child: showExpressions(controller.currentExpression.value),
                );
              }))
        ],
      ),
    );
  }

  Widget showExpressions(String expression) {
    switch (expression) {
      case 'SURPRISE':
        //Logger().e("SURPRISE start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/surprise.gif',
              width: 150,
              height: 150,
            ),
          ),
        );
      case 'OPEN_MOUTH':
        //Logger().e("OPEN_MOUTH start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/mouth_open.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'BLINK':
        //Logger().e("BLINK start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/eyeclose.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'RAISE_EYEBROWS':
        //Logger().e("RAISE_TYTBROWS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/gifs/eyebrow.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUFF_CHEEKS':
        //Logger().e("PUFF_CHEEKS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/cheek.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUCKER_LIPS':
        //Logger().e("PUCKER_LIPS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/mouth_close.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'TEMP1':
        //Logger().e("FROWN start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.asset(
              'assets/gifs/frown.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      default:
        return Container();
    }
  }
}

class HardModeScreen3 extends StatelessWidget {
  final List<CameraDescription> cameras;

  HardModeScreen3({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HardModeController3(cameras: cameras));

    return BaseScreen(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (controller.isInitialized) {
                return CameraPreview(controller.cameraController);
              } else {
                return Container(color: Colors.black);
              }
            }),
          ),
          Positioned(
            top: 50,
            child: Obx(() => Text(
                  controller.message,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
          ),
          Positioned(
            bottom: 50,
            child: Obx(() {
              if (controller.showStartButton) {
                return ElevatedButton(
                  onPressed: controller.startStage,
                  child: Text('Start'),
                );
              } else if (controller.isCapturing && controller.countdown > 0) {
                return Text(
                  '${controller.countdown}',
                  style: TextStyle(color: Colors.white, fontSize: 48),
                );
              } else {
                return Container(); // 빈 컨테이너를 반환하여 아무것도 표시하지 않음
              }
            }),
          ),
          Positioned(
            child: Obx(() => Text(
                  controller.feedbackMessage,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Positioned(
              top: 100,
              child: Obx(() {
                return Container(
                  child: showExpressions(controller.currentExpression.value),
                );
              }))
        ],
      ),
    );
  }

  Widget showExpressions(String expression) {
    switch (expression) {
      case 'SURPRISE':
        //Logger().e("SURPRISE start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/surprise.gif',
              width: 150,
              height: 150,
            ),
          ),
        );
      case 'OPEN_MOUTH':
        //Logger().e("OPEN_MOUTH start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/mouth_open.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'BLINK':
        //Logger().e("BLINK start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/eyeclose.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'RAISE_EYEBROWS':
        //Logger().e("RAISE_TYTBROWS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/gifs/eyebrow.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUFF_CHEEKS':
        //Logger().e("PUFF_CHEEKS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/cheek.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUCKER_LIPS':
        //Logger().e("PUCKER_LIPS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/mouth_close.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'TEMP1':
        //Logger().e("FROWN start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.asset(
              'assets/gifs/frown.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      default:
        return Container();
    }
  }
}

class HardModeScreen4 extends StatelessWidget {
  final List<CameraDescription> cameras;

  HardModeScreen4({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HardModeController4(cameras: cameras));

    return BaseScreen(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (controller.isInitialized) {
                return CameraPreview(controller.cameraController);
              } else {
                return Container(color: Colors.black);
              }
            }),
          ),
          Positioned(
            top: 50,
            child: Obx(() => Text(
                  controller.message,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
          ),
          Positioned(
            bottom: 50,
            child: Obx(() {
              if (controller.showStartButton) {
                return ElevatedButton(
                  onPressed: controller.startStage,
                  child: Text('Start'),
                );
              } else if (controller.isCapturing && controller.countdown > 0) {
                return Text(
                  '${controller.countdown}',
                  style: TextStyle(color: Colors.white, fontSize: 48),
                );
              } else {
                return Container(); // 빈 컨테이너를 반환하여 아무것도 표시하지 않음
              }
            }),
          ),
          Positioned(
            child: Obx(() => Text(
                  controller.feedbackMessage,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Positioned(
              top: 100,
              child: Obx(() {
                return Container(
                  child: showExpressions(controller.currentExpression.value),
                );
              }))
        ],
      ),
    );
  }

  Widget showExpressions(String expression) {
    switch (expression) {
      case 'SURPRISE':
        //Logger().e("SURPRISE start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/surprise.gif',
              width: 150,
              height: 150,
            ),
          ),
        );
      case 'OPEN_MOUTH':
        //Logger().e("OPEN_MOUTH start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/mouth_open.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'BLINK':
        //Logger().e("BLINK start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/eyeclose.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'RAISE_EYEBROWS':
        //Logger().e("RAISE_TYTBROWS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/gifs/eyebrow.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUFF_CHEEKS':
        //Logger().e("PUFF_CHEEKS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/cheek.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUCKER_LIPS':
        //Logger().e("PUCKER_LIPS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/mouth_close.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'TEMP1':
        //Logger().e("FROWN start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.asset(
              'assets/gifs/frown.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      default:
        return Container();
    }
  }
}

class HardModeScreen5 extends StatelessWidget {
  final List<CameraDescription> cameras;

  HardModeScreen5({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HardModeController5(cameras: cameras));

    return BaseScreen(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (controller.isInitialized) {
                return CameraPreview(controller.cameraController);
              } else {
                return Container(color: Colors.black);
              }
            }),
          ),
          Positioned(
            top: 50,
            child: Obx(() => Text(
                  controller.message,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
          ),
          Positioned(
            bottom: 50,
            child: Obx(() {
              if (controller.showStartButton) {
                return ElevatedButton(
                  onPressed: controller.startStage,
                  child: Text('Start'),
                );
              } else if (controller.isCapturing && controller.countdown > 0) {
                return Text(
                  '${controller.countdown}',
                  style: TextStyle(color: Colors.white, fontSize: 48),
                );
              } else {
                return Container(); // 빈 컨테이너를 반환하여 아무것도 표시하지 않음
              }
            }),
          ),
          Positioned(
            child: Obx(() => Text(
                  controller.feedbackMessage,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Positioned(
              top: 100,
              child: Obx(() {
                return Container(
                  child: showExpressions(controller.currentExpression.value),
                );
              }))
        ],
      ),
    );
  }

  Widget showExpressions(String expression) {
    switch (expression) {
      case 'SURPRISE':
        //Logger().e("SURPRISE start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/surprise.gif',
              width: 150,
              height: 150,
            ),
          ),
        );
      case 'OPEN_MOUTH':
        //Logger().e("OPEN_MOUTH start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/mouth_open.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'BLINK':
        //Logger().e("BLINK start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/eyeclose.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'RAISE_EYEBROWS':
        //Logger().e("RAISE_TYTBROWS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/gifs/eyebrow.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUFF_CHEEKS':
        //Logger().e("PUFF_CHEEKS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/cheek.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUCKER_LIPS':
        //Logger().e("PUCKER_LIPS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/mouth_close.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'TEMP1':
        //Logger().e("FROWN start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.asset(
              'assets/gifs/frown.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      default:
        return Container();
    }
  }
}

class HardModeScreen6 extends StatelessWidget {
  final List<CameraDescription> cameras;

  HardModeScreen6({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HardModeController6(cameras: cameras));

    return BaseScreen(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (controller.isInitialized) {
                return CameraPreview(controller.cameraController);
              } else {
                return Container(color: Colors.black);
              }
            }),
          ),
          Positioned(
            top: 50,
            child: Obx(() => Text(
                  controller.message,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
          ),
          Positioned(
            bottom: 50,
            child: Obx(() {
              if (controller.showStartButton) {
                return ElevatedButton(
                  onPressed: controller.startStage,
                  child: Text('Start'),
                );
              } else if (controller.isCapturing && controller.countdown > 0) {
                return Text(
                  '${controller.countdown}',
                  style: TextStyle(color: Colors.white, fontSize: 48),
                );
              } else {
                return Container(); // 빈 컨테이너를 반환하여 아무것도 표시하지 않음
              }
            }),
          ),
          Positioned(
            child: Obx(() => Text(
                  controller.feedbackMessage,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Positioned(
              top: 100,
              child: Obx(() {
                return Container(
                  child: showExpressions(controller.currentExpression.value),
                );
              }))
        ],
      ),
    );
  }

  Widget showExpressions(String expression) {
    switch (expression) {
      case 'SURPRISE':
        //Logger().e("SURPRISE start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/surprise.gif',
              width: 150,
              height: 150,
            ),
          ),
        );
      case 'OPEN_MOUTH':
        //Logger().e("OPEN_MOUTH start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/mouth_open.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'BLINK':
        //Logger().e("BLINK start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.asset(
              'assets/gifs/eyeclose.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      case 'RAISE_EYEBROWS':
        //Logger().e("RAISE_TYTBROWS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/gifs/eyebrow.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUFF_CHEEKS':
        //Logger().e("PUFF_CHEEKS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/cheek.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'PUCKER_LIPS':
        //Logger().e("PUCKER_LIPS start");
        return Container(
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/gifs/mouth_close.gif',
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

      case 'TEMP1':
        //Logger().e("FROWN start");
        return Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.asset(
              'assets/gifs/frown.gif',
              width: 150,
              height: 150,
            ),
          ),
        );

      default:
        return Container();
    }
  }
}
