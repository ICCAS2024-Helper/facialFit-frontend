import 'dart:async';
import 'dart:math';
import 'package:SmileHelper/game/result/stageclear5.dart';
import 'package:SmileHelper/game/result/stagefail5.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';

import '../game/result/stageclear1.dart';
import '../game/result/stagefail1.dart';

class HardModeController5 extends GetxController {
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  final RxList<String> _currentExpressions = RxList([]);
  final RxInt _countdown = RxInt(5);
  final RxString _message = RxString('');
  final RxBool _isCapturing = RxBool(false);
  final RxInt _currentExpressionIndex = RxInt(0);
  final RxInt _correctExpressions = RxInt(0);
  final RxString _feedbackMessage = RxString('');
  final RxInt _totalExpressions = RxInt(3);

  CameraController get cameraController => _cameraController;
  bool get isInitialized => _isInitialized.value;
  List<String> get currentExpressions => _currentExpressions;
  int get countdown => _countdown.value;
  String get message => _message.value;
  bool get isCapturing => _isCapturing.value;
  String get feedbackMessage => _feedbackMessage.value;
  int get totalExpressions => _totalExpressions.value;
  RxString currentExpression = RxString('');
  final List<String> allExpressions = [
    'SURPRISE',
    'OPEN_MOUTH',
    'BLINK',
    'RAISE_EYEBROWS',
    'PUFF_CHEEKS',
    'PUCKER_LIPS',
    'TEMP1'
  ];

  final RxBool _showStartButton = RxBool(true);
  bool get showStartButton => _showStartButton.value;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
    ),
  );

  HardModeController5({required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }

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
      _cameraController = CameraController(_cameras[1], ResolutionPreset.high);
      await _cameraController.initialize();
      _isInitialized.value = true;
      update();
    } catch (e) {
      Logger().e('Failed to initialize camera: $e');
    }
  }

  void startStage() {
    _showStartButton.value = false;
    _selectRandomExpressions();
    _updateMessage();
    _startCountdown();
  }

  void _selectRandomExpressions() {
    _currentExpressions.value =
        (allExpressions.toList()..shuffle()).take(3).toList();
    currentExpression.value =
        _currentExpressions.value[_currentExpressionIndex.value];
    _currentExpressionIndex.value = 0;
    _correctExpressions.value = 0;
  }

  void _updateMessage() {
    _message.value =
        'FACE ${_currentExpressionIndex.value + 1}: ${_currentExpressions[_currentExpressionIndex.value]}';
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
        _feedbackMessage.value = 'Cheer Up...!';
        _showFeedback(false);
        return;
      }

      final face = faces.first;
      bool isExpressionCorrect = _validateExpression(
          face, _currentExpressions[_currentExpressionIndex.value]);

      if (isExpressionCorrect) {
        _correctExpressions.value++;
        _feedbackMessage.value = 'Perfect!';
        _showFeedback(true);
      } else {
        _feedbackMessage.value = 'Cheer Up...!';
        _showFeedback(false);
      }
    } catch (e) {
      Logger().e('Error during capture and analysis: $e');
      _feedbackMessage.value = '오류가 발생했습니다.';
      _showFeedback(false);
    }
  }

  void _showFeedback(bool isCorrect) {
    _isCapturing.value = false;
    Timer(Duration(seconds: 3), () {
      _feedbackMessage.value = '';
      if (_currentExpressionIndex.value < _currentExpressions.length - 1) {
        _currentExpressionIndex.value++;
        _updateMessage();
        _startCountdown();
      } else {
        _finishStage();
      }
    });
  }

  void _moveToNextExpression() {
    if (_currentExpressionIndex.value < _currentExpressions.length - 1) {
      _currentExpressionIndex.value++;
      _updateMessage();
      _startCountdown();
    } else {
      _finishStage();
    }
  }

  void _finishStage() {
    String result = '${_correctExpressions.value}/$totalExpressions';
    if (_correctExpressions.value > 1) {
      Get.off(() => StageClear5(result: result), arguments: result);
    } else {
      Get.off(() => StageFail5(result: result), arguments: result);
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

  // 여기에 _isSmiling, _isMouthOpen, _isEyeClosed, _isEyebrowRaised, _isCheekPuffed, _isFrowning 메서드를 구현합니다.
  // 이 메서드들은 기존 ScanController에서 가져와 사용할 수 있습니다.

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
      // 왼쪽 눈썹의 평균 y 좌표를 계산합니다
      double leftEyebrowY = leftEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          leftEyebrowTop.points.length;

      // 오른쪽 눈썹의 평균 y 좌표를 계산합니다
      double rightEyebrowY = rightEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          rightEyebrowTop.points.length;

      // 왼쪽 눈의 평균 y 좌표를 계산합니다
      double leftEyeY =
          leftEye.points.map((p) => p.y.toDouble()).reduce((a, b) => a + b) /
              leftEye.points.length;

      // 오른쪽 눈의 평균 y 좌표를 계산합니다
      double rightEyeY =
          rightEye.points.map((p) => p.y.toDouble()).reduce((a, b) => a + b) /
              rightEye.points.length;

      // 눈썹과 눈 사이의 거리를 계산합니다
      double leftEyebrowEyeDistance = leftEyeY - leftEyebrowY;
      double rightEyebrowEyeDistance = rightEyeY - rightEyebrowY;

      // 얼굴 높이에 대한 상대적 거리를 계산합니다
      double relativeLeftDistance =
          leftEyebrowEyeDistance / face.boundingBox.height;
      double relativeRightDistance =
          rightEyebrowEyeDistance / face.boundingBox.height;

      // 임계값 설정
      double threshold = 0.09; // 얼굴 높이의 9%를 임계값으로 설정

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

    // 로그로 출력
    print('Left Eye Open Probability: $leftEyeOpen');
    print('Right Eye Open Probability: $rightEyeOpen');

    return leftEyeOpen != null &&
        rightEyeOpen != null &&
        leftEyeOpen < 0.2 &&
        rightEyeOpen < 0.2; // 임계값 설정
  }

  //볼 부풀리기
  bool _isCheekPuffed(Face face) {
    FaceContour? leftCheek = face.contours[FaceContourType.leftCheek];
    FaceContour? rightCheek = face.contours[FaceContourType.rightCheek];
    FaceContour? noseBridge = face.contours[FaceContourType.noseBridge];

    if (leftCheek != null && rightCheek != null && noseBridge != null) {
      // 양 볼의 가장 바깥쪽 점을 찾습니다
      Point<int> leftOuterPoint = leftCheek.points
          .reduce((curr, next) => curr.x < next.x ? curr : next);
      Point<int> rightOuterPoint = rightCheek.points
          .reduce((curr, next) => curr.x > next.x ? curr : next);

      // 코의 중앙점을 찾습니다
      Point<int> noseCenter = noseBridge.points[noseBridge.points.length ~/ 2];

      // 볼의 너비를 계산합니다
      double cheekWidth =
          (rightOuterPoint.x - leftOuterPoint.x).abs().toDouble();

      // 코에서 양 볼까지의 거리를 계산합니다
      double leftCheekDistance =
          (noseCenter.x - leftOuterPoint.x).abs().toDouble();
      double rightCheekDistance =
          (rightOuterPoint.x - noseCenter.x).abs().toDouble();

      // 볼의 대칭성을 확인합니다
      double cheekSymmetry =
          (leftCheekDistance - rightCheekDistance).abs() / cheekWidth;

      // 임계값 설정
      double widthThreshold = 0.41; // 얼굴 너비 대비 볼 너비의 임계값
      double symmetryThreshold = 0.1; // 볼 대칭성의 임계값

      print('Cheek Width: $cheekWidth');
      print('Face Width: ${face.boundingBox.width}');
      print('Cheek Symmetry: $cheekSymmetry');

      return (cheekWidth / face.boundingBox.width < widthThreshold) &&
          (cheekSymmetry < symmetryThreshold);
    }
    return false;
  }

/*
  double _calculateContourArea(List<Point<int>> points) {
    // 다각형 면적 계산 (shoelace formula)
    double area = 0;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      area += points[i].x * points[j].y;
      area -= points[j].x * points[i].y;
    }
    area = area.abs() / 2.0;
    return area;
  }
*/

  //입 오므리기
  bool _isLipsWhistling(Face face) {
    FaceLandmark? leftMouth = face.landmarks[FaceLandmarkType.leftMouth];
    FaceLandmark? rightMouth = face.landmarks[FaceLandmarkType.rightMouth];
    FaceLandmark? upperLip = face.landmarks[FaceLandmarkType.noseBase];
    FaceLandmark? lowerLip = face.landmarks[FaceLandmarkType.bottomMouth];

    if (leftMouth != null &&
        rightMouth != null &&
        upperLip != null &&
        lowerLip != null) {
      // 입 너비 계산
      double mouthWidth =
          (rightMouth.position.x - leftMouth.position.x).abs().toDouble();

      // 입 높이 계산
      double mouthHeight =
          (lowerLip.position.y - upperLip.position.y).abs().toDouble();

      // 입 모양 비율 계산 (높이/너비) - 값이 커질수록 입을 오무림
      double mouthRatio = mouthHeight / mouthWidth;

      print('Mouth Width: $mouthWidth');
      print('Mouth Height: $mouthHeight');
      print('Mouth Ratio: $mouthRatio');

      // 임계값 설정
      double widthThreshold = 210; // 입 너비 임계값 - 로그 보고 조정해야함
      double ratioThreshold = 0.8; // 입 오무리기 비율 - 낮을수록 난이도 내려감

      // 입 너비가 줄어들고, 동그랗게 변할 때 휘파람 모양으로 판단
      return mouthWidth < widthThreshold && mouthRatio > ratioThreshold;
    }
    return false;
  }

  //입 벌리기
  bool _isMouthOpen(Face face) {
    FaceLandmark? leftMouth = face.landmarks[FaceLandmarkType.leftMouth];
    FaceLandmark? rightMouth = face.landmarks[FaceLandmarkType.rightMouth];
    FaceLandmark? bottomMouth = face.landmarks[FaceLandmarkType.bottomMouth];
    FaceLandmark? upperMouth =
        face.landmarks[FaceLandmarkType.noseBase]; // 코 기저부를 윗입술로 사용

    if (leftMouth != null &&
        rightMouth != null &&
        bottomMouth != null &&
        upperMouth != null) {
      // 각 랜드마크의 위치를 로그로 출력
      print('Left Mouth: ${leftMouth.position}');
      print('Right Mouth: ${rightMouth.position}');
      print('Bottom Mouth: ${bottomMouth.position}');
      print('Upper Mouth (Nose Base): ${upperMouth.position}');

      double mouthWidth =
          (rightMouth.position.x.toDouble() - leftMouth.position.x.toDouble())
              .abs();
      double mouthHeight =
          (bottomMouth.position.y.toDouble() - upperMouth.position.y.toDouble())
              .abs();

      // 입 벌림 판단 기준 설정
      double ratio = mouthHeight / mouthWidth;

      // 매우 높은 임계값 설정
      double openThreshold = 1.0; // 1.0 이상이면 입을 벌렸다고 판단

      // 추가 조건: 최소 너비와 높이를 설정하여 잘못된 인식을 방지합니다.
      bool widthCondition = mouthWidth > 50; // 예시 값
      bool heightCondition = mouthHeight > 50; // 예시 값

      // 입술의 움직임을 감지하는 추가 조건
      bool mouthMovedCondition = mouthHeight > 20; // 예시 값

      return ratio > openThreshold &&
          widthCondition &&
          heightCondition &&
          mouthMovedCondition;
    }
    return false;
  }

  //놀람
  bool _isSurprise(Face face) {
    return _isEyebrowRaised(face) && _isMouthOpen(face);
  }

  //찡그리기
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
      // 1. 눈썹 위치 계산
      double leftEyebrowY = leftEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          leftEyebrowTop.points.length;
      double rightEyebrowY = rightEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          rightEyebrowTop.points.length;

      // 2. 눈 크기 계산
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

      // 3. 얼굴 전체 높이에 대한 눈썹 위치의 비율 계산
      double faceHeight = face.boundingBox.height.toDouble();
      double faceTop = face.boundingBox.top.toDouble();
      double leftEyebrowPositionRatio = (leftEyebrowY - faceTop) / faceHeight;
      double rightEyebrowPositionRatio = (rightEyebrowY - faceTop) / faceHeight;

      // 4. 눈 크기의 비율 계산
      double leftEyeHeightRatio = leftEyeHeight / faceHeight;
      double rightEyeHeightRatio = rightEyeHeight / faceHeight;

      // 임계값 설정
      double eyebrowPositionThreshold = 0.24; // 눈썹이 내려온 비율
      double eyeHeightThreshold = 0.041; // 눈 크기

      print('Left Eyebrow Position Ratio: $leftEyebrowPositionRatio');
      print('Right Eyebrow Position Ratio: $rightEyebrowPositionRatio');
      print('Left Eye Height Ratio: $leftEyeHeightRatio');
      print('Right Eye Height Ratio: $rightEyeHeightRatio');

      // 찡그림 판단
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
