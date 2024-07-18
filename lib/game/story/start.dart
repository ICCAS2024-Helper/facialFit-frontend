import 'package:flutter/material.dart';
import 'package:SmileHelper/game/story/storyplay.dart';
import 'package:get/get.dart';
import 'package:SmileHelper/css/screen.dart'; // BaseScreen import

class StoryStart extends StatelessWidget {
  final String stage;

  const StoryStart({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // 화면 높이에 맞추도록 설정
          child: Center(
            child: Container(
              width: 424,
              height: 805,
              child: Stack(
                children: [
                  Positioned(
                    left: 120,
                    top: 40,
                    child: Text(
                      stage, //여기서 이전에 클릭한 단계 표시
                      style: TextStyle(
                        color: Color(0xFFFFF3F3),
                        fontSize: 40,
                        fontFamily: 'ABeeZee',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 111,
                    top: 250,
                    child: GestureDetector(
                      onTap: () {
                        //Get.to(StoryPlay());

                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StoryPlay()),
                        );*/
                        Get.to(StoryPlay(), arguments: stage);
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFF87CEEB),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'Start',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 30,
                              fontFamily: 'ABeeZee',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 550,
                    child: SizedBox(
                      width: 400,
                      height: 120,
                      child: Text(
                        'Explanation: You’ll get a random challenge. Hold the expression for 10 seconds. We’ll snap one photo at a time.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
