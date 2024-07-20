import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:SmileHelper/main/main_stage.dart';
import 'package:SmileHelper/game/story/story_stage.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StageClear2 extends StatefulWidget {
  final String result;

  StageClear2({required this.result});

  @override
  _StageClear2State createState() => _StageClear2State();
}

class _StageClear2State extends State<StageClear2> {
  late AudioPlayer _audioPlayer;
  int userCoins = 0;
  late String result;

  @override
  void initState() {
    super.initState();
    result = widget.result;
    _audioPlayer = AudioPlayer();
    _playSound();
    _increaseCoin();
    _fetchUserCoins();
    _completeStage(2); // 스테이지 2 완료 처리 호출
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('clear.mp3'), volume: 15.0);
    Future.delayed(Duration(seconds: 2), () {
      _audioPlayer.stop();
    });
  }

  Future<void> _increaseCoin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      final url = Uri.parse('http://34.47.88.29:8082/api/user/increase-coin?userId=$userId&coin=3');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        print('Coin increased successfully.');
        _fetchUserCoins();
      } else {
        print('Failed to increase coin: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print('User ID or access token is missing.');
    }
  }

  Future<void> _fetchUserCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      final response = await http.get(
        Uri.parse('http://34.47.88.29:8082/api/user/coin'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          userCoins = jsonResponse['coin'] ?? 0;
        });
      } else {
        print('Failed to load user coins: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  Future<void> _completeStage(int stageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      final url = Uri.parse('http://34.47.88.29:8082/api/users/$userId/stages/complete/$stageId');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        print('Stage completed successfully.');
      } else {
        print('Failed to complete stage: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print('User ID or access token is missing.');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget buildShimmerButton(BuildContext context, String text, Widget page) {
    return Container(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Color(0xFF8B4513),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        onPressed: () {
          Get.to(page);
        },
        child: Shimmer.fromColors(
          baseColor: Colors.black,
          highlightColor: Color(0xFFD2691E),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF8B4513),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/Logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8B4513),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF8B4513),
                  ),
                  child: Text(
                    '2 Stage!!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/Congratulation!.png',
                        fit: BoxFit.contain,
                        width: 350,
                        height: 150,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Result: $result',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Image.asset(
                        'assets/gifs/clapping.gif',
                        fit: BoxFit.contain,
                        width: 500,
                        height: 150,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildShimmerButton(context, 'Stage', StoryStage()),
                    SizedBox(width: 20),
                    buildShimmerButton(context, 'Home', MainHome()),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: screenWidth * 0.06,
            top: screenHeight * 0.02,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/coin.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 10),
                Text(
                  '$userCoins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
