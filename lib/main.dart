import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';
import 'package:roomie_finder/models/UserModel.dart';
import 'package:roomie_finder/screens/RFSplashScreen.dart';
import 'package:roomie_finder/store/AppStore.dart';
import 'package:roomie_finder/utils/AppTheme.dart';
import 'package:roomie_finder/utils/RFConstant.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:roomie_finder/firebase_options.dart';

AppStore appStore = AppStore();
UserModel? userModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  userModel = await RFAuthController().getCurrentUserData();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: 'roomie finder',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        home: const RFSplashScreen(),
      ),
    );
  }
}
