import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  final FaceDetector _faceDetector;

  FaceDetectionService()
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
              enableContours: true,
              enableLandmarks: true,
              enableClassification: true,
              enableTracking: true),
        );

  Future<List<Face>> detectFaces(InputImage image) async {
    return await _faceDetector.processImage(image);
  }

  void dispose() {
    _faceDetector.close();
  }
}
