import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iccas_test1/etc/calendar.dart';
import 'package:iccas_test1/etc/quest.dart';
import 'package:iccas_test1/etc/shop.dart';
import 'package:iccas_test1/etc/statistics.dart';
import 'package:iccas_test1/main/select.dart';
import 'package:iccas_test1/massage/select.dart';
import 'package:iccas_test1/settings/select.dart';

/*

    이미지 하나도 안나온(잘모른)다
    추가하던지 해서 사용

*/
class MainStage extends StatelessWidget {
  //const MainStage({super.key});

  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: 478,
            height: 841,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 478,
                    height: 841,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 478,
                            height: 841,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 602,
                                  child: Container(
                                    width: 478,
                                    height: 239,
                                    decoration:
                                        BoxDecoration(color: Color(0xFF48AA7B)),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 1,
                                  child: Container(
                                    width: 478,
                                    height: 600,
                                    decoration:
                                        BoxDecoration(color: Color(0xFFFAF9E0)),
                                  ),
                                ),
                                Positioned(
                                  left: 292,
                                  top: 319,
                                  child: Container(
                                    width: 193,
                                    height: 283,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/refrigerator.png"),
                                      ), //"assets/images/loading.png"
                                      //image: DecorationImage(image: NetworkImage("https://via.placeholder.com/193x283"),fit: BoxFit.fill,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 6,
                                  top: 421,
                                  child: Container(
                                    width: 182,
                                    height: 182,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/desk.png"),

                                        //image: NetworkImage("https://via.placeholder.com/182x182"),fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),

                                //////////////////////// 상점 //////////////////////////

                                Positioned(
                                  left: 44,
                                  top: 755,
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Shop())),
                                    child: Container(
                                      width: 107,
                                      height: 49,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/button.png"),

                                          //image: NetworkImage("https://via.placeholder.com/182x182"),fit: BoxFit.fill,
                                        ),
                                      ) //FlutterLogo(), //왜 플러터 로고?
                                      ,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'shop',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),

                                /////////////////////////// 통계 보는 화면 버튼 /////////////////////////////////

                                Positioned(
                                  left: 327,
                                  top: 755,
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Statistics())),
                                    child: Container(
                                      width: 107,
                                      height: 49,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFFD9D9D9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                        ),
                                      ),
                                      child: Positioned(
                                        left: 346,
                                        top: 768,
                                        child: SizedBox(
                                          width: 69,
                                          height: 18,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'statistics',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                ///////////////////////////////////////////////////////////////

                                //////////////////////////  홈 >>> 있어야하나?  ///////////////////////////////
                                Positioned(
                                  left: 187,
                                  top: 755,
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainStage())),
                                    child: Container(
                                        width: 106,
                                        height: 49,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFFD9D9D9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                          ),
                                        ),
                                        child: Positioned(
                                          left: 217,
                                          top: 768,
                                          child: SizedBox(
                                            width: 44,
                                            height: 24,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'home',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),

/////////////////////////////  화분  //////////////////////////////////////
                                Positioned(
                                  left: 58,
                                  top: 560,
                                  child: Container(
                                    width: 116,
                                    height: 162,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage("assets/images/pot.png"),
                                      ),
                                    ),
                                  ),
                                ),

                                //////////////////////////  코인 개수  ////////////////////////
                                Positioned(
                                  left: 23,
                                  top: 21,
                                  child: Container(
                                    width: 67,
                                    height: 30,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 33,
                                              height: 33,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/coin.png"))),
                                            )),
                                        Positioned(
                                          left: 36,
                                          top: 4,
                                          child: SizedBox(
                                            width: 31,
                                            height: 26,
                                            child: Text(
                                              '\$35',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF48AA7B),
                                                fontSize: 17.77,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                ////////////////////////  세팅  ///////////////////////////
                                Positioned(
                                  left: 411,
                                  top: 16,
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Setting())),
                                    child: Container(
                                      width: 38,
                                      height: 41,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/setting.png"))),
                                    ),
                                  ),
                                ),
                                ////////////////////////////////  달력   //////////////////////////////////
                                Positioned(
                                    left: 363,
                                    top: 17,
                                    child: InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Calendar())),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/calendar.png"))),
                                        ))),

                                ////////////////////////////////  퀘스트  /////////////////////////////////
                                Positioned(
                                  left: 306,
                                  top: 17,
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Quest())),
                                    child: Container(
                                      width: 48,
                                      height: 41,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/Parchment.png"),
                                          //image: NetworkImage("https://via.placeholder.com/48x41"),fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
//////////////////////////////////////////////////////////////////////////

////////////////////////  상단 유저 이름 표시  /////////////////////////////
                                Positioned(
                                  left: 354,
                                  top: 78,
                                  child: Text(
                                    '\$USERNAME ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.77,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                ),

                                ///////////////////////////  캐릭터  ////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////                        /////       //////       ///
///////////////////////////////////                         /////       //////       ///
/////////////////////////////////////////////////////       /////       //////       ///
/////////////////////////////////////////////////////       /////       //////       ///
///////////////////////////////////                         /////       //////       ///
///////////////////////////////////                         /////                    ///
////////////////////////////////////////////////////        /////                    ///
                                ////////////////////        /////       //////       ///
                                ////////////////////        /////       //////       ///
                                ////////////////////        /////       //////       ///
                                ////////////////////        /////       //////       ///
                                ////////////////////////////////////////////////////////
                                Positioned(
                                  left: 186,
                                  top: 483,
                                  child: InkWell(
                                    onTap: () {
                                      //Opacity(opacity: opacity);
                                      _opacity = 0.5;
                                      //setState(() => _opacity = 0.5);

                                      log(_opacity);
                                    },

                                    /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectGame())),*/

                                    child: Container(
                                      width: 200,
                                      height: 240,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/loading.png"), //임시로 로딩이미지 출력
                                          //NetworkImage( "https://via.placeholder.com/200x240"),fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /////////////////////////////////////////////////////////////////////

                                //////////////////////////////  말풍선  /////////////////////////////////////
                                Positioned(
                                  left: 202,
                                  top: 416,
                                  child: Transform(
                                    transform: Matrix4.identity()
                                      ..translate(0.0, 0.0)
                                      ..rotateZ(0), //3.14
                                    child: Container(
                                      child: Container(
                                        width: 110,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Topic.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Positioned(
                                          left: 165,
                                          top: 434,
                                          child: Text(
                                            '   반갑습니다! \n   \$username!',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.40,
                                              fontFamily: 'ABeeZee',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /////////////// username 쪽 변경가능하도록 구현 //////////////////////
                              ],
                            ),
                          ),
                        ),

                        ////////////////////////////////////  전등  ////////////////////////////////////
                        Positioned(
                          left: 145,
                          top: 110,
                          child: Container(
                              width: 201,
                              height: 197,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/light.png"),
                                  //opacity: _opacity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Opacity(opacity: _opacity)),
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

class MassageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
      left: 19,
      top: 419,
      child: InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectMassage())),
          child: Container(
            width: 157,
            height: 103,
            decoration: ShapeDecoration(
              color: Color(0xFFFAF9E0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Align(
                alignment: Alignment.center,
                child: Positioned(
                  left: 321,
                  top: 441,
                  child: SizedBox(
                    width: 123,
                    height: 59,
                    child: Text(
                      '얼굴 마사지',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.77,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                )),
          )),
    );
  }
}
