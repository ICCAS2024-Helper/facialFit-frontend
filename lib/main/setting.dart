import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SmileHelper/main/main_stage.dart'; // MainHome import
import 'package:SmileHelper/shop/shop_main.dart'; // ShopMain import
import 'package:SmileHelper/main/mypage.dart'; // MyPage import

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSoundOn = true;
  String language = 'English';
  String version = '1.0.0';
  double _androidImageHeight = 80; // 초기 이미지 높이 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF48AA7B), // 배경색 설정
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 없애기
        title: Image.asset(
          'assets/images/Logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Text(
                'Setting',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(50.0),
                margin: EdgeInsets.all(10.0),
                height: 600.0, // 높이 설정 (예: 400.0)
                decoration: BoxDecoration(
                  color: Color(0xFFFAF9E0),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 중앙 배치
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSettingItem(
                      'My Page',
                      Icons.person,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyPage()),
                        );
                      },
                    ),
                    _buildSettingItem(
                      'Sound ${isSoundOn ? "On" : "Off"}',
                      isSoundOn ? Icons.volume_up : Icons.volume_off,
                          () {
                        setState(() {
                          isSoundOn = !isSoundOn;
                        });
                      },
                    ),
                    _buildSettingItem(
                      'Language: $language',
                      Icons.language,
                          () {
                        _showLanguageDialog();
                      },
                    ),
                    _buildSettingItem(
                      'Version: $version',
                      Icons.info,
                      null,
                    ),
                    SizedBox(height: 50), // 아이콘과 텍스트 사이에 간격 추가
                    Image.asset(
                      'assets/images/android.jpg', // Android 아이콘 경로
                      height: _androidImageHeight,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Color(0xFF48AA7B),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShopMain()),
                          );
                        },
                        child: Text('Shop'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainHome()),
                          );
                        },
                        child: Text('Main'),
                      ),
                    ),
                  ),
                  // Statistics 버튼은 주석 처리했습니다. 필요시 주석 해제하세요.
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => Statistics()),
                  //         );
                  //       },
                  //       child: Text('Statistics'),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback? onTap) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // 흰색 border 설정
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Container(
            height: 100,
            child: Column(
              children: [
                RadioListTile(
                  title: Text('English'),
                  value: 'English',
                  groupValue: language,
                  onChanged: (value) {
                    setState(() {
                      language = value.toString();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}