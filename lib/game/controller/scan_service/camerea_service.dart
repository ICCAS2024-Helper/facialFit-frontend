import 'package:camera/camera.dart';

class CameraService {
  late CameraController _cameraController;

  CameraController get cameraController => _cameraController;

  Future<void> initCamera(List<CameraDescription> cameras) async {
    _cameraController = CameraController(cameras[1], ResolutionPreset.veryHigh,
        imageFormatGroup: ImageFormatGroup.jpeg, enableAudio: false);

    await _cameraController.initialize();
  }

  Future<XFile?> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    return await _cameraController.takePicture();
  }

  void dispose() {
    _cameraController.dispose();
  }
}
