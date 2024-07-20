import 'package:SmileHelper/global_binding.dart';
import 'package:SmileHelper/game/camera_screen.dart';
import 'package:SmileHelper/game/camera_view.dart';
import 'package:SmileHelper/main/setting.dart';
import 'package:flutter/material.dart';
import 'package:SmileHelper/survey.dart';
import 'package:SmileHelper/register_main.dart';
import 'package:SmileHelper/login_main.dart';
import 'package:SmileHelper/shop/shop_main.dart';
import 'package:SmileHelper/quest/quest_test2.dart';
import 'package:get/get.dart';
import 'package:SmileHelper/main/main_stage.dart';
import 'package:SmileHelper/main/mypage.dart';
import 'package:SmileHelper/calendar/events_provider.dart';
import 'package:SmileHelper/calendar/user_info_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'calendar/calendar.dart';
import 'game/result/stageclear1.dart';
import 'game/result/stagefail1.dart';
import 'package:SmileHelper/game/story/start.dart';
import 'package:SmileHelper/game/story/story_stage.dart';
import 'package:SmileHelper/game/story/prolog.dart';
import 'package:SmileHelper/game/bonus/bonus_game.dart';
import 'package:SmileHelper/game/story/finish.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', '');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690), // Design size setting
        builder: (context, child) {
          return GetMaterialApp(
            initialBinding: GlobalBindings(),
            debugShowCheckedModeBanner: false,
            title: "Camera Application",
            theme: ThemeData(
              textTheme: GoogleFonts.robotoMonoTextTheme(
                Theme.of(context).textTheme,
              ).copyWith(
                bodyLarge: GoogleFonts.robotoMono(
                  textStyle: TextStyle(color: Colors.black, fontSize: 18),
                ),
                bodyMedium: GoogleFonts.robotoMono(
                  textStyle: TextStyle(color: Colors.black, fontSize: 16),
                ),
                headlineLarge: GoogleFonts.robotoMono(
                  textStyle: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                // Add other needed text styles
              ),
            ),
            home: child,
            initialRoute: "/Login",
            getPages: [
              // GetPage(
              //   name: '/CameraView',
              //   page: () => CameraView(),
              // ),
              // GetPage(
              //   name: '/CameraScreen',
              //   page: () => CameraScreen(
              //     cameras: [],
              //   ),
              //   transition: Transition.zoom,
              // ),
              GetPage(name: '/bonus', page: () => BonusGame()),
              //GetPage(name: '/Splash', page: () => SplashScreen()),
            ],
            routes: {
              "/Login": (context) => LoginMain(),
              "/Register": (context) => RegisterMain(),
              "/Home": (context) => MainHome(),
              "/Shop": (context) => ShopMain(),
              "/survey": (context) => Survey(
                registrationData: {},
              ),
              "/Quest": (context) => QuestTest2(),
              "/MyPage": (context) => MyPage(),
              "/Prolog": (context) => Prolog(),
              "/Story": (context) => StoryStage(),
              "/Finish": (context) => FinishPage(),
              "/stageclear1": (context) => StageClear1(),
              "/stagefail1": (context) => StageFail(),
              "/Calendar": (context) => CalendarPage(),
              "/Setting": (context) => Setting(),
            },
          );
        },
        child: LoginMain(), // Initial screen setting
      ),
    );
  }
}
