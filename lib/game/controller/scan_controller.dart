import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';
import 'package:SmileHelper/game/controller/getPredict.dart';
import 'package:SmileHelper/game/controller/mlkit.dart';
import 'package:SmileHelper/game/controller/stage_controller.dart';
import 'package:SmileHelper/game/countdown.dart';
import 'package:SmileHelper/game/result/stageclear1.dart';
import 'package:SmileHelper/game/result/stagefail1.dart';
import 'package:SmileHelper/main/main_stage.dart';
import 'package:SmileHelper/quest/quest_test2.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';
import 'package:get/state_manager.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  ScanController({required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }
  late List<CameraDescription> _cameras; //= <CameraDescription>[];
  late CameraController _cameraController;

  final RxBool _isInitialized = RxBool(false);

  CameraImage? _cameraImage;
  final RxList<Uint8List> _imageList = RxList([]);

  CameraController get cameraController => _cameraController;
  final StageController stageController = Get.put(StageController());

  bool get isInitialized => _isInitialized.value;
  List<Uint8List> get imageList => _imageList;

  var isCameraInitialized = false.obs;
  var _imageCount = 0;

  // 스테이지 관련 변수 추가
  //스테이지 관리

  // "동작"

  int _currentStage = 0;
  String get currentStage =>
      '스테이지 ${stageController.currentStage.value}: ${_stages[stageController.currentStage.value - 1].join(', ')}';
  // "동작"
  final List<List<String>> _stages = [
    ['웃음'], // 1단계
    ['웃음', '입 벌리기'], // 2단계
    ['웃음', '입 벌리기', '찡그리기'], // 3단계
    ['눈썹 들어올리기', '볼 부풀리기', '입 벌리기', '찡그리기'], // 4단계
    ['입 벌리기', '눈 웃음', '놀람', '눈 감기', '볼 부풀리기'], // 5단계
    ['웃기', '볼 부풀리기', '눈 찡그리기', '입 벌리기', '눈 감기', '놀람'] // 6단계
  ];

  void _selectSequentialExpression() {
    var expressions = _stages[stageController.currentStage.value - 1];
    if (expressions != null) {
      int index = _currentStage % expressions.length;
      currentExpression = expressions[index];
      Logger().e("expression: $currentExpression");
    }
  }

  // 표정을 랜덤으로 선택하는 함수
  void _selectRandomExpression() {
    var expressions = _stages[stageController.currentStage.value - 1];
    if (expressions != null) {
      currentExpression = expressions[Random().nextInt(expressions.length)];
    }
  }

  Timer? _stageTimer;

  //String get currentStage =>      '스테이지 ${stageController.currentStage.value}: ${_stages[stageController.currentStage.value - 1].join(', ')}';
  late String currentExpression; // 현재 스테이지에서 랜덤으로 선택된 표정

  bool get canProcess => _canProcess;

  bool get isBusy => _isBusy;

  get landmarks => _landmarks;

  set isBusy(bool isBusy) {
    _isBusy = isBusy;
  }

  bool _isDisposed = false;

  @override
  void onInit() async {
    super.onInit();
    /*if (await Permission.camera.request().isGranted) {
      _initCamera();
    } else {
      Get.snackbar('Error', 'Camera permission not granted',
          snackPosition: SnackPosition.BOTTOM);
    }*/

    _initCamera();
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _isInitialized.value = false;
    _imageList.clear();
    _cameraController.dispose();
  }

  //사진 찍은 횟수
  RxInt _picture_count = RxInt(0);
  get picture_count => _picture_count.value;

  // 유효성 검사 함수
  bool _validateStage(Face face) {
    //조건추가
    switch (_currentStage) {
      case 0:
        //휘파람
        return _isFrowning(face);
      case 1:
        //눈썹 올리기
        return _isFrowning(face);
      case 2:
        //볼 부풀리기
        return _isCheekPuffed(face);
      case 3:
        //눈 감기
        return _isEyeClosed(face);
      case 4:
        //입 벌리기
        return _isMouthOpen(face);
      case 5:
        //놀람
        return _isSurprise(face);
      case 6:
        //웃음
        return _isSmile(face);
      case 7:
        //찡그리기
        return _isFrowning(face);
      default:
        return false;
    }
  }

  RxInt _countdown = RxInt(0);
  get countdown => _countdown;
  // 스테이지 시작 함수
  void _startStage() {
    if (_stageTimer != null) {
      _stageTimer!.cancel();
    }
    // 표정을 랜덤으로 선택
    //_selectRandomExpression();
    //표정을 순서대로 선택
    _selectSequentialExpression();
    // 현재 스테이지 메시지 표시
    _showPopup('현재 스테이지: $currentStage, 표정: $currentExpression');
    // 각 스테이지에 맞는 사진 촬영 횟수 조정
    int requiredImages =
        _getRequiredImagesForStage(stageController.currentStage.value);

// 10초 카운트 뒤에 사진 촬영 및 스테이지 이동
    _countdown.value = 10;
    _stageTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown.value == 0) {
        timer.cancel();

        // 10초 후에 사진 촬영 및 스테이지 이동
        if (imageList.length < requiredImages) {
          takePicture().then((file) {
            if (file != null) {
              _processImage(InputImage.fromFilePath(file.path)).then((_) {
                _picture_count.value += 1;
                _moveToNextStage();
              });
            } else {
              _picture_count.value += 1;
              _moveToNextStage();
            }
          });
        } else {
          _moveToNextStage();
        }
      } else {
        _countdown.value--;
      }
    });
  }

//사진찍는횟수
  var _picture_limit = 3;
//끝났는지 판단
  var _isDone = false;
//맞은 개수
  RxInt correct = RxInt(0);
//틀린 개수
  RxInt wrong = RxInt(0);
  var isSuccessImageVisible = false.obs; // 성공 이미지 표시 상태
  var isFailImageVisible = false.obs; // 실패 이미지 표시 상태

  var isImageProcessing = false.obs; // 이미지 처리 중 플래그
  void _showSuccessImage() {
    isSuccessImageVisible.value = true;
    isImageProcessing.value = true;
    Timer(Duration(seconds: 1), () {
      isSuccessImageVisible.value = false;
      isImageProcessing.value = false;
      isSuccessImageVisible.value = true;
      isImageProcessing.value = true;
      isSuccessImageVisible.value = false;
      isImageProcessing.value = false;
    });
  }

  void _showFailImage() {
    isFailImageVisible.value = true;
    isImageProcessing.value = true;
    Timer(Duration(seconds: 1), () {
      isFailImageVisible.value = false;
      isImageProcessing.value = false;
    });
  }

// 각 스테이지에 필요한 사진 촬영 횟수를 반환하는 함수
  int _getRequiredImagesForStage(int stage) {
    switch (stage) {
      case 1:
        return 1;
      case 2:
      case 3:
        return 2;
      case 4:
      case 5:
      case 6:
        return 3;
      default:
        return 1;
    }
  }

  // 다음 스테이지로 이동
  void _moveToNextStage() async {
    int requiredImages =
        _getRequiredImagesForStage(stageController.currentStage.value);

    //종료조건
    if (imageList.length > requiredImages) {
      await _showPopup('사진이 $requiredImages개가 됐어요 ');
      _showPopup(correct.value.toString());
      _showPopup(wrong.value.toString());

      Timer(Duration(seconds: 1), () {
        // 정답이 더 많으면 StageClear1 페이지로 이동, 그렇지 않으면 StageFail1 페이지로 이동
        if (correct.value >= wrong.value) {
          //같을경우 통과?하는
          //if (correct.value > wrong.value) { //값이 2씩 올라가긴한다
          Get.to(StageClear());
        } else {
          Get.to(StageFail());
        }
      });

      //종료하는척
      _isInitialized.value = false;
      _imageList.clear();

      correct.value = 0;
      wrong.value = 0;
      _currentStage = 0;
      stageController.setStage(1); // 초기화
      onClose();
    } else {
      //실행조건
      //_showPopup("사진이 아직 3개가 안됐어요");
      if (_message.value == 'success') {
        _showSuccessImage();
      } else if (_message.value == 'fail') {
        _showFailImage();
      }

      Logger()
          .e("실행조건: ${correct.value}  ${wrong.value}   ${imageList.length}}");
      _currentStage += 1;
      _startStage();
    }
  }

  _disposeCamera() {
    _canProcess = false;
    _faceDetector.close();
    _isInitialized.value = false;
    _imageList.clear();
    _cameraController.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _disposeCamera();
    super.onClose();
  }

// 카메라 초기화 후 스테이지 시작
  Future<void> _initCamera() async {
    if (_isDisposed) return;
    Logger().e('_initCamera()');

    try {
      _cameraController = CameraController(
          _cameras[1], ResolutionPreset.veryHigh,
          imageFormatGroup: ImageFormatGroup.jpeg, enableAudio: false);

      await _cameraController.initialize();
      if (_isDisposed) return; // dispose 상태인 경우 초기화 방지
      _isInitialized.value = true;
      await _cameraController.startImageStream((CameraImage image) async {
        _cameraImage = image;
      });

      _isInitialized.refresh();
      _startStage(); // 스테이지 시작
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
        Logger().e('User denied camera access');
        Get.snackbar(
          'Error',
          'User denied camera access',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else {
        Logger().e('CameraException: ${e.code}');
        Get.snackbar(
          'Error',
          'Failed to initialize camera: ${e.code}',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Logger().e('Unknown error: $e');
      Get.snackbar(
        'Error',
        'Unknown error occurred while initializing camera',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<XFile?> takePicture() async {
    //final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      //showInSnackBar('Error: select a camera first.');
      Logger().e('Error: select a camera first.');
      return null;
    }
    if (isImageProcessing.value) {
      return null; // 이미지가 표시 중이면 사진 찍지 않음
    }
    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      Logger().e('takePicture(): $file');
      //Logger().e(file);
      final path = file.path;
      final Uint8List bytes = await File(path).readAsBytes();
      Logger().e('Uint8List bytes: $bytes');

      // predict
      Future<String> response =
          Getpredict().predict(file); //Image.file(File(path))
      Logger().e('take_picture: ${response}');
      //

      _imageList.add(bytes);

      _processImage(InputImage.fromFilePath(path));

      //thumbnailWidget();

      _imageList.refresh();
      Logger().e('_imageList: $_imageList');

      return file;
    } on CameraException catch (e) {
      Logger().e(e);
      //_showCameraException(e);
      return null;
    }
  }

  XFile? imageFile;
  VideoPlayerController? videoController;

  Widget thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;
    //imageFile = controller.takePicture();
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Logger().e('thumbnailWidget: ${imageFile?.path}');
            if (imageFile == null) //localVideoController == null &&
              Container()
            else
              SizedBox(
                width: 64.0,
                height: 64.0,
                child: (localVideoController == null)
                    ? (
                        // The captured image on the web contains a network-accessible URL
                        // pointing to a location within the browser. It may be displayed
                        // either with Image.network or Image.memory after loading the image
                        // bytes to memory.
                        kIsWeb
                            ? Image.network(imageFile!.path)
                            : Image.file(File(imageFile!.path)))
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.pink)),
                        child: Center(
                          child: AspectRatio(
                              aspectRatio:
                                  localVideoController.value.aspectRatio,
                              child: VideoPlayer(localVideoController)),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  final RxString _message = ''.obs; // 팝업 메시지
  String get message => _message.value;
  final RxList<Point<int>> _landmarks =
      RxList<Point<int>>(); // 얼굴 랜드마크 저장 FaceLandmark

// mlkit facedetector
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: true),
  );

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  var _cameraLensDirection = CameraLensDirection.front;
  String? _text;
  String? get text => this._text;

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    Logger().e('init _processimage');
    final faces = await _faceDetector.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      Logger().e('found face length: $text');
      if (faces.isEmpty) {
        _showPopup('얼굴 없음');
      } else {
        for (final face in faces) {
          text += 'face: ${face.boundingBox}\n\n';
          boundingBox.add(face.boundingBox);
          contour.add(face.contours);

          Logger().e('boundingBox: $boundingBox');
          Logger().e('contour!!!!!: ${contour.first.entries}');
          _landmarks.clear();

          face.landmarks.forEach((type, landmark) {
            if (landmark != null &&
                (type == FaceLandmarkType.leftEye ||
                    type == FaceLandmarkType.rightEye ||
                    type == FaceLandmarkType.noseBase ||
                    type == FaceLandmarkType.leftMouth ||
                    type == FaceLandmarkType.rightMouth ||
                    type == FaceLandmarkType.bottomMouth)) {
              _landmarks.add(landmark.position);

              Logger().e("landmark position: ${landmark.position}");
            }
          });

          bool isActionDetected = _validateStage(face);
          Logger().e('isactiondetected: $isActionDetected');
          if (isActionDetected) {
            _showPopup('Success');
            isSuccessImageVisible.value = true;
            correct.value++;

            ///
            Future.delayed(Duration(seconds: 1), () {
              isSuccessImageVisible.value = false;
            });
          } else {
            _showPopup('Fail');

            wrong.value++;
            isFailImageVisible.value = true;
            Future.delayed(Duration(seconds: 1), () {
              isFailImageVisible.value = false;
            });
          }
        }
      }
      _text = text;
    }
    _isBusy = false;
  }

  //로직-------------------------------------------------------------------------

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
//웃음

  bool _isSmile(Face face) {
    return (face.smilingProbability! > 0.6) ? true : false;
  }

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

  //----------------------------------------------------------------------------

  bool _showPopup(String message) {
    _message.value = message;
    Get.snackbar(
      '얼굴 인식 결과',
      _message.value, //message
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
    return message.isNotEmpty;
  }

  RxList<Map<FaceContourType, FaceContour?>> contour = RxList([]);
  RxList<Rect> boundingBox = RxList([]);
}
