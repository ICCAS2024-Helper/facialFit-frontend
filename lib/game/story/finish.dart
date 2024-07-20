import 'package:SmileHelper/game/story/story_stage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:SmileHelper/css/screen.dart'; // BaseScreen import
import 'package:shimmer/shimmer.dart'; // Shimmer effect

class FinishPage extends StatefulWidget {
  @override
  _PrologPageState createState() => _PrologPageState();
}

class _PrologPageState extends State<FinishPage> {
  late VideoPlayerController _controller;
  double _volume = 10; // 초기 볼륨 설정

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/wedding.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.setLooping(false);
    _controller.setVolume(_volume); // 초기 볼륨 설정
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToStage() {
    _controller.pause(); // 동영상 일시정지
    _controller.dispose(); // 동영상 종료

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StoryStage()), // StagePage로 대체
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : CircularProgressIndicator(),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: buildShimmerButton(context, 'Stage', _navigateToStage),
          ),
        ],
      ),
    );
  }

  Widget buildShimmerButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      height: 50, // 버튼 높이 설정
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Color(0xFF8B4513), // 버튼 배경색을 흰색으로 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // 버튼을 둥글게 설정
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 패딩 조정
        ),
        onPressed: onPressed,
        child: Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Color(0xFFD2691E),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
