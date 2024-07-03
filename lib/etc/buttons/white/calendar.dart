import 'package:flutter/material.dart';
import 'package:iccas_test1/etc/calendar.dart';

class BtnCalendar extends StatelessWidget {
  const BtnCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 363,
        top: 17,
        child: InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Calendar())),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  //color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/wCalendar.png"))),
            )));
  }
}
