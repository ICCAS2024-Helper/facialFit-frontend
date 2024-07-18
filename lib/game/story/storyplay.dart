import 'package:SmileHelper/game/camera_view.dart';
import 'package:SmileHelper/global_binding.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:SmileHelper/game/camera_screen.dart';
import 'package:SmileHelper/game/result/stageclear1.dart';
import 'package:SmileHelper/css/screen.dart'; // BaseScreen import
import 'package:get/get.dart';

class StoryPlay extends StatelessWidget {
  const StoryPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: ListView(
        children: [
          Container(
            width: 478,
            height: 710,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 478,
                    height: 841,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(color: Color(0xFF87CEEB)),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16,
                          top: 19,
                          child: Container(
                            width: 445,
                            height: 804,
                          ),
                        ),
                        Positioned(
                          left: 110,
                          top: 34,
                          child: Text(
                            Get.arguments, //'Stage 1',
                            style: TextStyle(
                              color: Color(0xFFFFF3F3),
                              fontSize: 45,
                              fontFamily: 'ABeeZee',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 55,
                          top: 127,
                          child: Container(
                            width: 310,
                            height: 550,
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CameraScreen(),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
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
