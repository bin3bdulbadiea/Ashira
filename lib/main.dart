// ignore_for_file: depend_on_referenced_packages

import 'package:ashira/firebase_options.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/layouts/home/home_layout.dart';
import 'package:ashira/controllers/menu_drawer_controller.dart';
import 'package:ashira/screens/auth_screens/login/login.dart';
import 'package:ashira/themes/dark.dart';
import 'package:ashira/themes/light.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  timeago.setLocaleMessages('ar', timeago.ArMessages());

  timeago.setLocaleMessages('en', timeago.EnMessages());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MenuDrawerController()
        ..changeThemeMode()
        ..loadMode(),
      builder: (controller) => MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
        locale: controller.selectedLocale.value,
        onGenerateTitle: (context) => S.of(context).appTitle,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: controller.isNight.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeLayout();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
