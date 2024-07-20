import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SmileHelper/game/result/stageclear1.dart';
import 'package:SmileHelper/game/result/stagefail1.dart';

class HardModeController extends GetxController {
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  final RxList<String> _currentExpressions = RxList([]);
  final RxInt _countdown = RxInt(5);
  final RxString _message = RxString('');
  final RxBool _isCapturing = RxBool(false);

  CameraController get cameraController => _cameraController;
  bool get isInitialized => _isInitialized.value;
  List<String> get currentExpressions => _currentExpressions;
  int get countdown => _countdown.value;
  String get message => _message.value;
  bool get isCapturing => _isCapturing.value;
  final List<String> allExpressions = [
    'SURPRISE',
    'OPEN_MOUTH',
    'BLINK',
    'RAISE_EYEBROWS',
    'PUFF_CHEEKS',
    'PUCKER_LIPS',
    'TEMP1'
  ];

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
    ),
  );

  HardModeController({required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }

  final RxString _currentExpression = RxString('');

  String get currentExpression => _currentExpression.value;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.onClose();
  }

  Future<void> _initCamera() async {
    try {
      _cameraController = CameraController(_cameras[1], ResolutionPreset.high,
          enableAudio: false);
      await _cameraController.initialize();
      _isInitialized.value = true;
      startStage();
    } catch (e) {
      Logger().e('Failed to initialize camera: $e');
    }
  }

  void startStage() {
    _selectRandomExpression();
    _message.value = 'FACE: $_currentExpression';
    _currentExpression.value = _currentExpressions.value[0];
    _startCountdown();
  }

  void _selectRandomExpression() {
    _currentExpression.value =
        allExpressions[Random().nextInt(allExpressions.length)];
  }

  void _startCountdown() {
    _countdown.value = 5;
    _isCapturing.value = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown.value > 0) {
        _countdown.value--;
      } else {
        timer.cancel();
        _captureAndAnalyze();
      }
    });
  }

  Future<void> _captureAndAnalyze() async {
    try {
      final image = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _message.value = '얼굴이 인식되지 않았습니다.';
        _isCapturing.value = false;
        return;
      }

      final face = faces.first;
      bool isExpressionCorrect =
          _validateExpression(face, _currentExpression.value);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (isExpressionCorrect) {
        _message.value = 'Perfect!';
        if (userId != null) {
          await saveStatistics(
              userId, _currentExpression.value, 1, 0); // 성공 결과 저장
        }
        Get.off(() => StageClear1());
      } else {
        _message.value = 'Cheer Up...!';
        if (userId != null) {
          await saveStatistics(
              userId, _currentExpression.value, 0, 1); // 실패 결과 저장
        }
        Get.off(() => StageFail());
      }
    } catch (e) {
      Logger().e('Error during capture and analysis: $e');
      _message.value = '오류가 발생했습니다.';
    }
    _isCapturing.value = false;
  }

  Future<void> saveStatistics(String userId, String expressionType,
      int successCount, int failCount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://34.47.88.29:8082/api/statistics/save?id=$userId'),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode([
          {
            'expressionType': expressionType,
            'successCount': successCount,
            'failCount': failCount
          }
        ]),
      );

      if (response.statusCode == 200) {
        print('통계가 성공적으로 저장되었습니다.');
      } else {
        print('통계 저장 실패: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print('액세스 토큰을 찾을 수 없습니다.');
    }
  }

  bool _validateExpression(Face face, String expression) {
    switch (expression) {
      case 'SURPRISE':
        return _isSurprise(face);
      case 'OPEN_MOUTH':
        return _isMouthOpen(face);
      case 'BLINK':
        return _isEyeClosed(face);
      case 'RAISE_EYEBROWS':
        return _isEyebrowRaised(face);
      case 'PUFF_CHEEKS':
        return _isCheekPuffed(face);
      case 'PUCKER_LIPS':
        return _isLipsWhistling(face);
      case 'TEMP1':
        return _isFrowning(face);
      default:
        return false;
    }
  }

  //눈썹 올리기
  bool _isEyebrowRaised(Face face) {
    FaceContour? leftEyebrowTop = face.contours[FaceContourType.leftEyebrowTop];
    FaceContour? leftEye = face.contours[FaceContourType.leftEye];
    FaceContour? rightEyebrowTop =
        face.contours[FaceContourType.rightEyebrowTop];
    FaceContour? rightEye = face.contours[FaceContourType.rightEye];

    if (leftEyebrowTop != null &&
        leftEye != null &&
        rightEyebrowTop != null &&
        rightEye != null) {
      double leftEyebrowY = leftEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          leftEyebrowTop.points.length;
      double rightEyebrowY = rightEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          rightEyebrowTop.points.length;
      double leftEyeY =
          leftEye.points.map((p) => p.y.toDouble()).reduce((a, b) => a + b) /
              leftEye.points.length;
      double rightEyeY =
          rightEye.points.map((p) => p.y.toDouble()).reduce((a, b) => a + b) /
              rightEye.points.length;
      double leftEyebrowEyeDistance = leftEyeY - leftEyebrowY;
      double rightEyebrowEyeDistance = rightEyeY - rightEyebrowY;
      double relativeLeftDistance =
          leftEyebrowEyeDistance / face.boundingBox.height;
      double relativeRightDistance =
          rightEyebrowEyeDistance / face.boundingBox.height;
      double threshold = 0.09;

      print('Left Eyebrow-Eye Distance: $relativeLeftDistance');
      print('Right Eyebrow-Eye Distance: $relativeRightDistance');

      return (relativeLeftDistance > threshold) &&
          (relativeRightDistance > threshold) &&
          ((relativeLeftDistance - relativeRightDistance).abs() < 0.004);
    }
    return false;
  }

  // 눈 감기
  bool _isEyeClosed(Face face) {
    final double? leftEyeOpen = face.leftEyeOpenProbability;
    final double? rightEyeOpen = face.rightEyeOpenProbability;

    print('Left Eye Open Probability: $leftEyeOpen');
    print('Right Eye Open Probability: $rightEyeOpen');

    return leftEyeOpen != null &&
        rightEyeOpen != null &&
        leftEyeOpen < 0.2 &&
        rightEyeOpen < 0.2;
  }

  // 볼 부풀리기
  bool _isCheekPuffed(Face face) {
    FaceContour? leftCheek = face.contours[FaceContourType.leftCheek];
    FaceContour? rightCheek = face.contours[FaceContourType.rightCheek];
    FaceContour? noseBridge = face.contours[FaceContourType.noseBridge];

    if (leftCheek != null && rightCheek != null && noseBridge != null) {
      Point<int> leftOuterPoint = leftCheek.points
          .reduce((curr, next) => curr.x < next.x ? curr : next);
      Point<int> rightOuterPoint = rightCheek.points
          .reduce((curr, next) => curr.x > next.x ? curr : next);
      Point<int> noseCenter = noseBridge.points[noseBridge.points.length ~/ 2];
      double cheekWidth =
          (rightOuterPoint.x - leftOuterPoint.x).abs().toDouble();
      double leftCheekDistance =
          (noseCenter.x - leftOuterPoint.x).abs().toDouble();
      double rightCheekDistance =
          (rightOuterPoint.x - noseCenter.x).abs().toDouble();
      double cheekSymmetry =
          (leftCheekDistance - rightCheekDistance).abs() / cheekWidth;
      double widthThreshold = 0.41;
      double symmetryThreshold = 0.1;

      print('Cheek Width: $cheekWidth');
      print('Face Width: ${face.boundingBox.width}');
      print('Cheek Symmetry: $cheekSymmetry');

      return (cheekWidth / face.boundingBox.width < widthThreshold) &&
          (cheekSymmetry < symmetryThreshold);
    }
    return false;
  }

  // 입 오므리기
  bool _isLipsWhistling(Face face) {
    FaceLandmark? leftMouth = face.landmarks[FaceLandmarkType.leftMouth];
    FaceLandmark? rightMouth = face.landmarks[FaceLandmarkType.rightMouth];
    FaceLandmark? upperLip = face.landmarks[FaceLandmarkType.noseBase];
    FaceLandmark? lowerLip = face.landmarks[FaceLandmarkType.bottomMouth];

    if (leftMouth != null &&
        rightMouth != null &&
        upperLip != null &&
        lowerLip != null) {
      double mouthWidth =
          (rightMouth.position.x - leftMouth.position.x).abs().toDouble();
      double mouthHeight =
          (lowerLip.position.y - upperLip.position.y).abs().toDouble();
      double mouthRatio = mouthHeight / mouthWidth;

      print('입 너비: $mouthWidth');
      print('입 높이: $mouthHeight');
      print('입 비율: $mouthRatio');

      double widthThreshold = 210;
      double ratioThreshold = 0.8;

      return mouthWidth < widthThreshold && mouthRatio > ratioThreshold;
    }
    return false;
  }

  // 입 벌리기
  bool _isMouthOpen(Face face) {
    FaceLandmark? leftMouth = face.landmarks[FaceLandmarkType.leftMouth];
    FaceLandmark? rightMouth = face.landmarks[FaceLandmarkType.rightMouth];
    FaceLandmark? bottomMouth = face.landmarks[FaceLandmarkType.bottomMouth];
    FaceLandmark? upperMouth = face.landmarks[FaceLandmarkType.noseBase];

    if (leftMouth != null &&
        rightMouth != null &&
        bottomMouth != null &&
        upperMouth != null) {
      print('왼쪽 입: ${leftMouth.position}');
      print('오른쪽 입: ${rightMouth.position}');
      print('아래 입: ${bottomMouth.position}');
      print('윗 입 (코 기저부): ${upperMouth.position}');

      double mouthWidth =
          (rightMouth.position.x.toDouble() - leftMouth.position.x.toDouble())
              .abs();
      double mouthHeight =
          (bottomMouth.position.y.toDouble() - upperMouth.position.y.toDouble())
              .abs();
      double ratio = mouthHeight / mouthWidth;
      double openThreshold = 1.0;
      bool widthCondition = mouthWidth > 50;
      bool heightCondition = mouthHeight > 50;
      bool mouthMovedCondition = mouthHeight > 20;

      return ratio > openThreshold &&
          widthCondition &&
          heightCondition &&
          mouthMovedCondition;
    }
    return false;
  }

  // 놀람
  bool _isSurprise(Face face) {
    return _isEyebrowRaised(face) && _isMouthOpen(face);
  }

  // 찡그리기
  bool _isFrowning(Face face) {
    FaceContour? leftEyebrowTop = face.contours[FaceContourType.leftEyebrowTop];
    FaceContour? rightEyebrowTop =
        face.contours[FaceContourType.rightEyebrowTop];
    FaceContour? leftEye = face.contours[FaceContourType.leftEye];
    FaceContour? rightEye = face.contours[FaceContourType.rightEye];

    if (leftEyebrowTop != null &&
        rightEyebrowTop != null &&
        leftEye != null &&
        rightEye != null) {
      double leftEyebrowY = leftEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          leftEyebrowTop.points.length;
      double rightEyebrowY = rightEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          rightEyebrowTop.points.length;
      double leftEyeHeight = leftEye.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a > b ? a : b) -
          leftEye.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a < b ? a : b);
      double rightEyeHeight = rightEye.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a > b ? a : b) -
          rightEye.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a < b ? a : b);
      double faceHeight = face.boundingBox.height.toDouble();
      double faceTop = face.boundingBox.top.toDouble();
      double leftEyebrowPositionRatio = (leftEyebrowY - faceTop) / faceHeight;
      double rightEyebrowPositionRatio = (rightEyebrowY - faceTop) / faceHeight;
      double leftEyeHeightRatio = leftEyeHeight / faceHeight;
      double rightEyeHeightRatio = rightEyeHeight / faceHeight;
      double eyebrowPositionThreshold = 0.24;
      double eyeHeightThreshold = 0.041;

      print('Left Eyebrow Position Ratio: $leftEyebrowPositionRatio');
      print('Right Eyebrow Position Ratio: $rightEyebrowPositionRatio');
      print('Left Eye Height Ratio: $leftEyeHeightRatio');
      print('Right Eye Height Ratio: $rightEyeHeightRatio');

      bool eyebrowsLowered =
          (leftEyebrowPositionRatio > eyebrowPositionThreshold) &&
              (rightEyebrowPositionRatio > eyebrowPositionThreshold);
      bool eyesNarrowed = (leftEyeHeightRatio < eyeHeightThreshold) &&
          (rightEyeHeightRatio < eyeHeightThreshold);

      return eyebrowsLowered && eyesNarrowed;
    }
    return false;
  }
}
