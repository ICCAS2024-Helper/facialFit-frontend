import 'dart:convert';
import 'package:SmileHelper/game/controller/stage_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:SmileHelper/css/screen.dart'; // BaseScreen import

import '../../hardmode/hard_mode_screen.dart'; // Get 패키지 import
import 'finish.dart'; // FinishPage import

class StoryStage extends StatefulWidget {
  @override
  _StoryStageState createState() => _StoryStageState();
}

class _StoryStageState extends State<StoryStage> {
  final StageController stageController = Get.put(StageController());
  Map<int, bool> stageProgress = {};

  @override
  void initState() {
    super.initState();
    _fetchStageProgress();
  }

  Future<void> _fetchStageProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      final url = Uri.parse('http://34.47.88.29:8082/api/users/$userId/stages/progress');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          for (var entry in jsonResponse) {
            stageProgress[entry['stageId']] = entry['cleared'];
          }
        });
      } else {
        print('Failed to fetch stage progress: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print('User ID or access token is missing.');
    }
  }

  Future<void> _navigateToHardMode() async {
    final cameras = await availableCameras();
    Get.to(() => HardModeScreen(cameras: cameras));
  }

  Future<void> _navigateToHardMode2() async {
    final cameras = await availableCameras();
    Get.to(() => HardModeScreen2(cameras: cameras));
  }

  Future<void> _navigateToHardMode3() async {
    final cameras = await availableCameras();
    Get.to(() => HardModeScreen3(cameras: cameras));
  }

  Future<void> _navigateToHardMode4() async {
    final cameras = await availableCameras();
    Get.to(() => HardModeScreen4(cameras: cameras));
  }

  Future<void> _navigateToHardMode5() async {
    final cameras = await availableCameras();
    Get.to(() => HardModeScreen5(cameras: cameras));
  }

  Future<void> _navigateToHardMode6() async {
    final cameras = await availableCameras();
    Get.to(() => HardModeScreen6(cameras: cameras));
  }

  void _showStageDialog(int stage, Function navigateToStage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stage $stage'),
          content: Text('There is one question for stage $stage. If you follow the expression presented in 5 seconds, you\'ll get it right?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Start'),
              onPressed: () {
                stageController.setStage(stage);
                Navigator.of(context).pop();
                navigateToStage();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMissingStagesDialog(List<int> missingStages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stages Incomplete'),
          content: Text('You need to complete the following stages: ${missingStages.join(', ')}'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkWeddingUnlock() {
    List<int> missingStages = [];
    for (int i = 1; i <= 6; i++) {
      if (stageProgress[i] != true) {
        missingStages.add(i);
      }
    }

    if (missingStages.isEmpty) {
      Get.to(() => FinishPage());
    } else {
      _showMissingStagesDialog(missingStages);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BaseScreen(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // 하단 중앙 이미지
            Positioned(
              left: 0,
              top: screenHeight * 0.71,
              child: GestureDetector(
                onTap: _checkWeddingUnlock,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.192,
                  child: Center(
                    child: Image.asset(
                      'assets/images/weding.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            // 왼쪽 이미지 목록
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: screenWidth * 0.2,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      'assets/images/forest.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            // 오른쪽 이미지 목록
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: screenWidth * 0.2,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      'assets/images/forest.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            // 스테이지 버튼들
            _buildStageButton(screenWidth, screenHeight, 0.25, 0.1, 1, 'assets/images/stage1.png', () => _showStageDialog(1, _navigateToHardMode)),
            _buildStageButton(screenWidth, screenHeight, 0.50, 0.22, 2, 'assets/images/stage2.png', () => _showStageDialog(2, _navigateToHardMode2)),
            _buildStageButton(screenWidth, screenHeight, 0.20, 0.33, 3, 'assets/images/stage3.png', () => _showStageDialog(3, _navigateToHardMode3)),
            _buildStageButton(screenWidth, screenHeight, 0.50, 0.43, 4, 'assets/images/stage4.png', () => _showStageDialog(4, _navigateToHardMode4)),
            _buildStageButton(screenWidth, screenHeight, 0.20, 0.51, 5, 'assets/images/stage5.png', () => _showStageDialog(5, _navigateToHardMode5)),
            _buildStageButton(screenWidth, screenHeight, 0.5, 0.60, 6, 'assets/images/stage6.png', () => _showStageDialog(6, _navigateToHardMode6)),
          ],
        ),
      ),
    );
  }

  // 스테이지 버튼을 생성하는 헬퍼 메서드
  Widget _buildStageButton(double screenWidth, double screenHeight, double leftFactor, double topFactor, int stage, String imagePath, Function onPressed) {
    return Positioned(
      left: screenWidth * leftFactor,
      top: screenHeight * topFactor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // 버튼의 배경색을 투명하게 설정
          shadowColor: Colors.transparent, // 그림자를 투명하게 설정
        ),
        onPressed: () {
          onPressed();
        },
        child: Image.asset(
          imagePath,
          height: 100, // 이미지 크기를 더 크게 설정
          width: 100,
        ),
      ),
    );
  }
}
