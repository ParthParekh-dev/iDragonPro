// @dart=2.9
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idragon_pro/localeString.dart';
import 'package:idragon_pro/screens/iDragonMain.dart';
import 'package:idragon_pro/screens/splashScreen.dart';

void main() async {
  await GetStorage.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 500),
      translations: LocaleString(),
      locale: Locale('en', 'US'),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
