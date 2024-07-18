import 'dart:math';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class ExpressionValidator {
  bool isSmiling(Face face) {
    return face.smilingProbability != null && face.smilingProbability! > 0.8;
  }

  bool isMouthOpen(Face face) {
    FaceLandmark? leftMouth = face.landmarks[FaceLandmarkType.leftMouth];
    FaceLandmark? rightMouth = face.landmarks[FaceLandmarkType.rightMouth];
    FaceLandmark? bottomMouth = face.landmarks[FaceLandmarkType.bottomMouth];
    FaceLandmark? upperMouth = face.landmarks[FaceLandmarkType.noseBase];

    if (leftMouth != null &&
        rightMouth != null &&
        bottomMouth != null &&
        upperMouth != null) {
      double mouthWidth =
          (rightMouth.position.x - leftMouth.position.x).toDouble().abs();
      double mouthHeight =
          (bottomMouth.position.y - upperMouth.position.y).toDouble().abs();

      double ratio = mouthHeight / mouthWidth;
      double openThreshold = 1.0;

      bool widthCondition = mouthWidth > 50;
      bool heightCondition = mouthHeight > 50;

      return ratio > openThreshold && widthCondition && heightCondition;
    }
    return false;
  }

  bool isEyeClosed(Face face) {
    final double? leftEyeOpen = face.leftEyeOpenProbability;
    final double? rightEyeOpen = face.rightEyeOpenProbability;

    return leftEyeOpen != null &&
        rightEyeOpen != null &&
        leftEyeOpen < 0.2 &&
        rightEyeOpen < 0.2;
  }

  bool isEyebrowRaised(Face face) {
    FaceContour? leftEyebrowTop = face.contours[FaceContourType.leftEyebrowTop];
    FaceContour? leftEyebrowBottom =
        face.contours[FaceContourType.leftEyebrowBottom];
    FaceContour? rightEyebrowTop =
        face.contours[FaceContourType.rightEyebrowTop];
    FaceContour? rightEyebrowBottom =
        face.contours[FaceContourType.rightEyebrowBottom];

    if (leftEyebrowTop != null &&
        leftEyebrowBottom != null &&
        rightEyebrowTop != null &&
        rightEyebrowBottom != null) {
      double leftEyebrowTopY = leftEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          leftEyebrowTop.points.length;
      double leftEyebrowBottomY = leftEyebrowBottom.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          leftEyebrowBottom.points.length;
      double rightEyebrowTopY = rightEyebrowTop.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          rightEyebrowTop.points.length;
      double rightEyebrowBottomY = rightEyebrowBottom.points
              .map((p) => p.y.toDouble())
              .reduce((a, b) => a + b) /
          rightEyebrowBottom.points.length;

      double leftEyebrowRaise = leftEyebrowBottomY - leftEyebrowTopY;
      double rightEyebrowRaise = rightEyebrowBottomY - rightEyebrowTopY;

      // 임계값 조정
      double threshold = 30.0; // 눈썹 올리는 임계값

      bool isLeftEyebrowRaised = leftEyebrowRaise > threshold;
      bool isRightEyebrowRaised = rightEyebrowRaise > threshold;

      return isLeftEyebrowRaised || isRightEyebrowRaised;
    }
    return false;
  }

  bool isCheekPuffed(Face face) {
    FaceContour? leftCheek = face.contours[FaceContourType.leftCheek];
    FaceContour? rightCheek = face.contours[FaceContourType.rightCheek];

    if (leftCheek != null && rightCheek != null) {
      double leftCheekArea = _calculateContourArea(leftCheek.points);
      double rightCheekArea = _calculateContourArea(rightCheek.points);

      return leftCheekArea > 1000 && rightCheekArea > 1000; // 임계값 설정
    }
    return false;
  }

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
}
